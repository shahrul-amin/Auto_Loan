"""
Loan approval routes for officer decision forms
"""
from flask import Blueprint, request, jsonify, render_template
from datetime import datetime
from itsdangerous import SignatureExpired, BadSignature
from config import Config
from services.firebase_service import FirebaseService

bp = Blueprint('loan_approval', __name__, url_prefix='/api/loan-approval')
firebase_service = FirebaseService()

@bp.route('/form', methods=['GET'])
def approval_form():
    """
    Display the loan approval/rejection form for officers
    URL: /api/loan-approval/form?token=<secure_token>
    """
    try:
        token = request.args.get('token')
        
        if not token:
            return jsonify({
                'error': 'Missing token',
                'message': 'Authorization token is required'
            }), 400
        
        # Verify token (7 days expiry)
        serializer = Config.get_serializer()
        try:
            data = serializer.loads(token, salt='loan-approval', max_age=604800)  # 7 days
        except SignatureExpired:
            return """
                <html>
                <body style="font-family: Arial; padding: 50px; text-align: center;">
                    <h1 style="color: #EF4444;">Link Expired</h1>
                    <p>This approval link has expired after 7 days.</p>
                    <p>The application has been automatically rejected due to no officer response.</p>
                </body>
                </html>
            """, 410
        except BadSignature:
            return """
                <html>
                <body style="font-family: Arial; padding: 50px; text-align: center;">
                    <h1 style="color: #EF4444;">Invalid Link</h1>
                    <p>This approval link is invalid or has been tampered with.</p>
                </body>
                </html>
            """, 400
        
        application_id = data.get('applicationId')
        
        # Get application details from Firestore
        app_doc = firebase_service.db.collection('loan_applications').document(application_id).get()
        
        if not app_doc.exists:
            return """
                <html>
                <body style="font-family: Arial; padding: 50px; text-align: center;">
                    <h1 style="color: #EF4444;">Application Not Found</h1>
                    <p>The loan application could not be found.</p>
                </body>
                </html>
            """, 404
        
        app_data = app_doc.to_dict()
        
        # Check if already processed
        if app_data.get('status') in ['credited', 'rejected']:
            status_text = 'approved and credited' if app_data.get('status') == 'credited' else 'rejected'
            return f"""
                <html>
                <body style="font-family: Arial; padding: 50px; text-align: center;">
                    <h1 style="color: #6B7280;">Already Processed</h1>
                    <p>This application has already been {status_text}.</p>
                    <p><strong>Application ID:</strong> {application_id}</p>
                    <p><strong>Status:</strong> {app_data.get('status')}</p>
                    <p><strong>Officer Remarks:</strong> {app_data.get('officerRemarks', 'N/A')}</p>
                </body>
                </html>
            """, 200
        
        # Render the form
        return render_template(
            'loan_approval_form.html',
            application_id=application_id,
            token=token,
            ic_number=app_data.get('icNumber'),
            loan_type=app_data.get('loanType'),
            requested_amount=app_data.get('requestedAmount', 0),
            tenure=app_data.get('tenure'),
            purpose_of_loan=app_data.get('purposeOfLoan', 'N/A'),
            ml_approved=app_data.get('status') == 'approved',
            ml_confidence=app_data.get('mlConfidence', 0),
            rejection_reason=app_data.get('rejectionReason', '')
        )
        
    except Exception as e:
        return jsonify({
            'error': 'Failed to load form',
            'message': str(e)
        }), 500


@bp.route('/submit', methods=['POST'])
def submit_decision():
    """
    Submit officer's approval/rejection decision
    """
    try:
        data = request.get_json()
        
        if not data:
            return jsonify({
                'error': 'Request body is required'
            }), 400
        
        token = data.get('token')
        decision = data.get('decision')
        officer_remarks = data.get('officerRemarks')
        
        if not token or not decision or not officer_remarks:
            return jsonify({
                'error': 'Missing required fields',
                'message': 'token, decision, and officerRemarks are required'
            }), 400
        
        # Verify token
        serializer = Config.get_serializer()
        try:
            token_data = serializer.loads(token, salt='loan-approval', max_age=604800)
        except SignatureExpired:
            return jsonify({
                'error': 'Token expired',
                'message': 'This approval link has expired'
            }), 410
        except BadSignature:
            return jsonify({
                'error': 'Invalid token',
                'message': 'The authorization token is invalid'
            }), 400
        
        application_id = token_data.get('applicationId')
        
        # Get application data from Firestore
        app_doc = firebase_service.db.collection('loan_applications').document(application_id).get()
        
        if not app_doc.exists:
            return jsonify({
                'error': 'Application not found',
                'message': 'Loan application does not exist'
            }), 404
        
        app_data = app_doc.to_dict()
        
        # Validate decision-specific fields
        if decision == 'approve':
            interest_rate = data.get('interestRate')
            approved_amount = data.get('approvedAmount')
            
            if not interest_rate or not approved_amount:
                return jsonify({
                    'error': 'Missing approval fields',
                    'message': 'interestRate and approvedAmount are required for approval'
                }), 400
            
            # Convert to proper types
            try:
                interest_rate = float(interest_rate)
                approved_amount = float(approved_amount)
            except ValueError:
                return jsonify({
                    'error': 'Invalid field types',
                    'message': 'interestRate and approvedAmount must be numbers'
                }), 400
            
            # Validate ranges
            if not (2 <= interest_rate <= 15):
                return jsonify({
                    'error': 'Invalid interest rate',
                    'message': 'Interest rate must be between 2% and 15%'
                }), 400
            
            if approved_amount < 1000:
                return jsonify({
                    'error': 'Invalid approved amount',
                    'message': 'Approved amount must be at least RM 1,000'
                }), 400
            
            # Update application with approval
            update_data = {
                'status': 'credited',
                'interestRate': interest_rate,
                'approvedAmount': int(approved_amount),
                'officerRemarks': officer_remarks,
                'lastUpdated': datetime.now()
            }
            
            # Create entry in existing_loans collection
            _createExistingLoan(
                ic_number=app_data.get('icNumber'),
                application_id=application_id,
                loan_type=app_data.get('loanType'),
                principal_amount=approved_amount,
                interest_rate=interest_rate,
                tenure_months=app_data.get('tenure') * 12,  # Convert years to months
                approved_date=datetime.now()
            )
            
            # Update DSR in CCRIS profile
            _updateCCRISWithNewLoan(
                ic_number=app_data.get('icNumber'),
                monthly_payment=_calculateMonthlyPayment(
                    approved_amount, 
                    interest_rate, 
                    app_data.get('tenure') * 12
                )
            )
        
        else:  # reject
            # Update application with rejection
            update_data = {
                'status': 'rejected',
                'officerRemarks': officer_remarks,
                'rejectionReason': officer_remarks,  # Override ML rejection reason
                'lastUpdated': datetime.now()
            }
        
        # Update Firestore
        firebase_service.db.collection('loan_applications').document(application_id).update(update_data)
        
        return jsonify({
            'success': True,
            'message': f'Application {decision}d successfully',
            'data': {
                'applicationId': application_id,
                'status': update_data['status']
            }
        }), 200
        
    except Exception as e:
        return jsonify({
            'error': 'Failed to submit decision',
            'message': str(e)
        }), 500


def _calculateMonthlyPayment(principal: float, annual_rate: float, tenure_months: int) -> float:
    """Calculate monthly loan payment using amortization formula"""
    if tenure_months == 0 or principal == 0:
        return 0.0
    
    monthly_rate = (annual_rate / 100) / 12
    
    if monthly_rate == 0:
        return principal / tenure_months
    
    numerator = principal * monthly_rate * pow(1 + monthly_rate, tenure_months)
    denominator = pow(1 + monthly_rate, tenure_months) - 1
    
    return round(numerator / denominator, 2)


def _createExistingLoan(ic_number: str, application_id: str, loan_type: str, 
                       principal_amount: float, interest_rate: float, 
                       tenure_months: int, approved_date: datetime):
    """Create a new entry in existing_loans collection when loan is credited"""
    try:
        monthly_payment = _calculateMonthlyPayment(principal_amount, interest_rate, tenure_months)
        
        # Get user's connected bank
        user_doc = firebase_service.db.collection('users').document(ic_number).get()
        user_data = user_doc.to_dict() if user_doc.exists else {}
        connected_banks = user_data.get('connectedBanks', [])
        bank_id = connected_banks[0] if connected_banks else 'unknown'
        
        # Generate loan ID using the pattern: icNumber_bankId_timestamp
        loan_id = f"{ic_number}_{bank_id}_{int(approved_date.timestamp() * 1000)}"
        
        # Generate account reference
        account_reference = f"ML{ic_number}{str(int(approved_date.timestamp() * 1000))[-3:]}"
        
        # Calculate end date based on tenure
        from dateutil.relativedelta import relativedelta
        end_date = approved_date + relativedelta(months=tenure_months)
        
        # Next payment date is next month
        next_payment_date = approved_date + relativedelta(months=1)
        
        loan_data = {
            'loanId': loan_id,
            'icNumber': ic_number,
            'accountReference': account_reference,
            'bankId': bank_id,
            'loanType': loan_type,
            'loanAmount': principal_amount,
            'outstandingBalance': principal_amount,
            'interestRate': interest_rate,
            'monthlyInstallment': monthly_payment,
            'tenure': tenure_months,
            'remainingTenure': tenure_months,
            'startDate': approved_date,
            'endDate': end_date,
            'nextPaymentDate': next_payment_date,
            'lastPaymentDate': None,
            'lastSyncedAt': datetime.now(),
            'status': 'Active'
        }
        
        # Use loan_id as document ID
        firebase_service.db.collection('existing_loans').document(loan_id).set(loan_data)
        
        print(f"[LOAN CREDITED] Created existing_loans entry for {ic_number}, loan ID {loan_id}")
        
    except Exception as e:
        print(f"[ERROR] Failed to create existing_loans entry: {str(e)}")
        raise


def _updateCCRISWithNewLoan(ic_number: str, monthly_payment: float):
    """Update CCRIS profile with new loan commitment, recalculate DSR and CCRIS status"""
    try:
        ccris_ref = firebase_service.db.collection('ccris_credit_profiles').document(ic_number)
        ccris_doc = ccris_ref.get()
        
        if not ccris_doc.exists:
            print(f"[WARNING] No CCRIS profile found for {ic_number}")
            return
        
        ccris_data = ccris_doc.to_dict()
        
        # Get employment info for monthly income
        employment_doc = firebase_service.db.collection('employment_info').document(ic_number).get()
        employment_data = employment_doc.to_dict() if employment_doc.exists else {}
        monthly_income = employment_data.get('monthlyIncome', 0.0)
        
        if monthly_income == 0:
            print(f"[WARNING] No monthly income found for {ic_number}, cannot update DSR")
            return
        
        # Calculate new total commitments
        from services.ml.ml_feature_service import MLFeatureService
        ml_feature_service = MLFeatureService(firebase_service)
        commitments = ml_feature_service.calculateTotalCommitments(ic_number)
        total_commitments = commitments['totalCommitments']
        
        # Calculate new DSR
        new_dsr = (total_commitments / monthly_income) * 100
        
        # Calculate CCRIS status
        ccris_status = _calculateCCRISStatus(ic_number, ccris_data)
        
        # Update CCRIS profile with both DSR and status
        ccris_ref.update({
            'debtServiceRatio': round(new_dsr, 2),
            'ccrisStatus': ccris_status,
            'lastUpdated': datetime.now()
        })
        
        print(f"[CCRIS UPDATED] {ic_number}: DSR={new_dsr:.2f}%, Status={ccris_status}")
        
    except Exception as e:
        print(f"[ERROR] Failed to update CCRIS profile: {str(e)}")
        # Don't raise - this is a non-critical update

def _calculateCCRISStatus(ic_number: str, ccris_data: dict) -> str:
    """Calculate CCRIS status based on defaults and missed payments"""
    # Get loan history for missed payments calculation
    loan_history_query = firebase_service.db.collection('loan_history').where('icNumber', '==', ic_number)
    loan_history_docs = list(loan_history_query.stream())
    
    total_missed_payments = 0
    for loan in loan_history_docs:
        loan_data = loan.to_dict()
        total_missed_payments += loan_data.get('numberOfMissedPayments', 0)
    
    number_of_defaults = ccris_data.get('numberOfDefaultPayments', 0)
    
    # Derive CCRIS status (matching MLFeatureService logic)
    if number_of_defaults <= 0 and total_missed_payments <= 1:
        return 'Excellent'
    elif number_of_defaults <= 0 and total_missed_payments <= 3:
        return 'Good'
    elif number_of_defaults <= 1 or total_missed_payments <= 6:
        return 'Fair'
    else:
        return 'Poor'

