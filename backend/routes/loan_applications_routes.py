from flask import Blueprint, request, jsonify
from services.firebase_service import FirebaseService
from services.ml.loan_approval_service import LoanApprovalPredictionService
from datetime import datetime
import threading

bp = Blueprint('loan_applications', __name__, url_prefix='/api/loan-applications')
firebase_service = FirebaseService()
loan_approval_service = LoanApprovalPredictionService(firebase_service)

def convert_timestamps(data):
    """Convert Firestore timestamps to ISO format strings"""
    if not data:
        return data
    
    converted = {}
    for key, value in data.items():
        if hasattr(value, 'timestamp'):
            converted[key] = value.isoformat()
        elif isinstance(value, datetime):
            converted[key] = value.isoformat()
        elif isinstance(value, list):
            converted[key] = [
                item.isoformat() if hasattr(item, 'timestamp') or isinstance(item, datetime) else item
                for item in value
            ]
        else:
            converted[key] = value
    return converted

@bp.route('/<ic_number>', methods=['GET'])
def get_loan_applications(ic_number):
    try:
        status_filter = request.args.get('status')
        
        query = firebase_service.db.collection('loan_applications').where('icNumber', '==', ic_number)
        
        if status_filter:
            query = query.where('status', '==', status_filter)
        
        docs = query.stream()
        
        applications = []
        for doc in docs:
            data = doc.to_dict()
            data['applicationId'] = doc.id
            
            # Ensure required fields exist with defaults
            data.setdefault('requiredDocuments', [])
            data.setdefault('uploadedDocuments', [])
            
            converted_data = convert_timestamps(data)
            applications.append(converted_data)
        
        return jsonify({
            'success': True,
            'data': applications,
            'count': len(applications)
        }), 200
        
    except Exception as e:
        return jsonify({
            'success': False,
            'error': 'Failed to get loan applications',
            'message': str(e)
        }), 500

@bp.route('/application/<application_id>', methods=['GET'])
def get_application_by_id(application_id):
    try:
        doc = firebase_service.db.collection('loan_applications').document(application_id).get()
        
        if not doc.exists:
            return jsonify({
                'success': False,
                'message': 'Loan application not found'
            }), 404
        
        data = doc.to_dict()
        converted_data = convert_timestamps(data)
        
        return jsonify({
            'success': True,
            'data': converted_data
        }), 200
        
    except Exception as e:
        return jsonify({
            'success': False,
            'error': 'Failed to get loan application',
            'message': str(e)
        }), 500

@bp.route('/', methods=['POST'])
def create_loan_application():
    """
    Create a new loan application with ML prediction and officer notification
    
    Request body:
    {
        "icNumber": "string",
        "loanType": "string",
        "requestedAmount": number,
        "tenure": number,
        "purposeOfLoan": "string",
        "guarantorAvailable": boolean,
        "uploadedDocuments": ["string"]
    }
    """
    try:
        data = request.get_json()
        
        if not data:
            return jsonify({
                'error': 'Request body is required'
            }), 400
        
        # Validate required fields
        required_fields = ['icNumber', 'loanType', 'requestedAmount', 'tenure', 'purposeOfLoan']
        missing_fields = [field for field in required_fields if field not in data]
        
        if missing_fields:
            return jsonify({
                'error': 'Missing required fields',
                'message': f'Required fields: {", ".join(missing_fields)}'
            }), 400
        
        ic_number = data['icNumber']
        loan_type = data['loanType']
        
        # Check for duplicate application
        if firebase_service.check_duplicate_application(ic_number, loan_type):
            return jsonify({
                'error': 'Duplicate application',
                'message': f'You already have an active {loan_type} loan application'
            }), 409
        
        # Use application ID from frontend (already generated for document uploads)
        application_id = data.get('applicationId')
        timestamp = datetime.now()
        if not application_id:
            # Fallback: Generate application ID if not provided
            application_id = f"{ic_number}_{timestamp.strftime('%d%m%y%H%M%S')}"
        
        # Prepare application data
        application_data = {
            'applicationId': application_id,
            'icNumber': ic_number,
            'loanType': loan_type,
            'requestedAmount': int(data['requestedAmount']),
            'tenure': int(data['tenure']),
            'purposeOfLoan': data['purposeOfLoan'],
            'guarantorAvailable': data.get('guarantorAvailable', False),
            'uploadedDocuments': data.get('uploadedDocuments', []),
            'requiredDocuments': [],
            'status': 'pending',  # Initial status
            'applicationDate': timestamp,
            'lastUpdated': timestamp,
            'interestRate': None,
            'approvedAmount': None,
            'rejectionReason': None,
            'officerRemarks': None
        }
        
        # Save to Firestore
        firebase_service.db.collection('loan_applications').document(application_id).set(application_data)
        
        # Move uploaded documents from temp folder to final application folder
        temp_app_id = data.get('tempApplicationId')
        if temp_app_id:
            firebase_service.move_application_documents(ic_number, temp_app_id, application_id)
        
        # Trigger ML prediction in background
        def process_ml_prediction():
            try:
                from app import email_service, app
                
                # Prepare loan data for ML
                loan_data = {
                    'loanType': loan_type,
                    'requestedAmount': data['requestedAmount'],
                    'tenure': data['tenure'],
                    'guarantorAvailable': data.get('guarantorAvailable', False)
                }
                
                # Run ML prediction
                prediction = loan_approval_service.predict_loan_approval(ic_number, loan_data)
                
                if prediction:
                    update_data = {
                        'lastUpdated': datetime.now()
                    }
                    
                    if prediction['approved']:
                        # ML approved - notify officer
                        update_data['status'] = 'approved'
                        update_data['mlConfidence'] = prediction['confidence']
                        
                        # Update Firestore
                        firebase_service.db.collection('loan_applications').document(application_id).update(update_data)
                        
                        # Get officer email
                        officer_email = firebase_service.get_officer_email_for_user(ic_number)
                        
                        if officer_email:
                            # Get user data for email
                            user = firebase_service.get_user(ic_number)
                            bank_id = user.connected_banks[0] if user and user.connected_banks else None
                            
                            officer_name = "Loan Officer"
                            if bank_id:
                                bank_doc = firebase_service.db.collection('banks').document(bank_id).get()
                                if bank_doc.exists:
                                    officer_name = bank_doc.to_dict().get('loanOfficerName', 'Loan Officer')
                            
                            # Send officer notification
                            email_data = {
                                'applicationId': application_id,
                                'icNumber': ic_number,
                                'loanType': loan_type,
                                'requestedAmount': data['requestedAmount'],
                                'tenure': data['tenure'],
                                'purposeOfLoan': data['purposeOfLoan'],
                                'officerEmail': officer_email,
                                'officerName': officer_name,
                                'mlApproved': True,
                                'mlConfidence': prediction['confidence'],
                                'uploadedDocuments': data.get('uploadedDocuments', [])
                            }
                            
                            # Send email within Flask app context
                            with app.app_context():
                                email_service.send_officer_notification(email_data)
                    
                    else:
                        # ML rejected
                        update_data['status'] = 'rejected'
                        update_data['mlConfidence'] = prediction['confidence']
                        
                        # Use rejection reason from prediction if available (auto-reject), otherwise generate with DiCE
                        if 'rejectionReason' in prediction:
                            update_data['rejectionReason'] = prediction['rejectionReason']
                        else:
                            explanation = loan_approval_service.generate_rejection_explanation(ic_number, loan_data)
                            if explanation:
                                update_data['rejectionReason'] = explanation
                        
                        # Update Firestore
                        firebase_service.db.collection('loan_applications').document(application_id).update(update_data)
            
            except Exception as e:
                print(f"ML prediction error for {application_id}: {str(e)}")
                # Mark as failed for manual review
                firebase_service.db.collection('loan_applications').document(application_id).update({
                    'status': 'pending',
                    'officerRemarks': 'ML prediction failed - requires manual review',
                    'lastUpdated': datetime.now()
                })
        
        # Start background thread
        thread = threading.Thread(target=process_ml_prediction)
        thread.daemon = True
        thread.start()
        
        # Return immediately to user
        return jsonify({
            'success': True,
            'message': 'Loan application submitted successfully',
            'data': {
                'applicationId': application_id,
                'status': 'pending',
                'applicationDate': timestamp.isoformat()
            }
        }), 201
        
    except Exception as e:
        return jsonify({
            'error': 'Failed to create loan application',
            'message': str(e)
        }), 500

@bp.route('/<application_id>', methods=['PUT'])
def update_loan_application(application_id):
    try:
        data = request.get_json()
        
        if not data:
            return jsonify({
                'error': 'Missing request body',
                'message': 'Loan application data is required'
            }), 400
        
        firebase_service.db.collection('loan_applications').document(application_id).update(data)
        
        return jsonify({
            'success': True,
            'message': 'Loan application updated successfully',
            'data': data
        }), 200
        
    except Exception as e:
        return jsonify({
            'error': 'Failed to update loan application',
            'message': str(e)
        }), 500

@bp.route('/<application_id>/status', methods=['PATCH'])
def update_application_status(application_id):
    try:
        data = request.get_json()
        
        if not data or 'status' not in data:
            return jsonify({
                'error': 'Missing required fields',
                'message': 'status is required'
            }), 400
        
        update_data = {
            'status': data['status'],
            'lastUpdated': datetime.now()
        }
        
        if 'rejectionReason' in data:
            update_data['rejectionReason'] = data['rejectionReason']
        if 'approvedAmount' in data:
            update_data['approvedAmount'] = data['approvedAmount']
        if 'officerRemarks' in data:
            update_data['officerRemarks'] = data['officerRemarks']
        
        firebase_service.db.collection('loan_applications').document(application_id).update(update_data)
        
        return jsonify({
            'success': True,
            'message': 'Application status updated successfully',
            'data': update_data
        }), 200
        
    except Exception as e:
        return jsonify({
            'error': 'Failed to update application status',
            'message': str(e)
        }), 500

@bp.route('/<application_id>', methods=['DELETE'])
def delete_loan_application(application_id):
    try:
        firebase_service.db.collection('loan_applications').document(application_id).delete()
        
        return jsonify({
            'success': True,
            'message': 'Loan application deleted successfully'
        }), 200
        
    except Exception as e:
        return jsonify({
            'error': 'Failed to delete loan application',
            'message': str(e)
        }), 500


# Document upload endpoints removed - documents will be uploaded directly to Firebase Storage from Flutter
