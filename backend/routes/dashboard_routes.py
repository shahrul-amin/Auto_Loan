from flask import Blueprint, jsonify
from services.firebase_service import FirebaseService
from services.ml.ml_feature_service import MLFeatureService
from datetime import datetime, timezone, timedelta

bp = Blueprint('dashboard', __name__, url_prefix='/api/dashboard')
firebase_service = FirebaseService()
ml_feature_service = MLFeatureService(firebase_service)

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
        elif isinstance(value, dict):
            converted[key] = convert_timestamps(value)
        else:
            converted[key] = value
    return converted

@bp.route('/<ic_number>/summary', methods=['GET'])
def get_dashboard_summary(ic_number):
    """
    Get aggregated dashboard data for home screen
    Returns: DSR, commitments, credit score, loan applications, success rate, etc.
    """
    try:
        malaysia_tz = timezone(timedelta(hours=8))
        current_time = datetime.now(malaysia_tz)
        
        user_ref = firebase_service.db.collection('users').document(ic_number)
        user_ref.update({'lastLogin': current_time})
        
        _triggerPredictionIfNeeded(ic_number, current_time)
        
        personal_info_doc = firebase_service.db.collection('personal_info').document(ic_number).get()
        personal_info = personal_info_doc.to_dict() if personal_info_doc.exists else {}
        
        employment_info_doc = firebase_service.db.collection('employment_info').document(ic_number).get()
        employment_info = employment_info_doc.to_dict() if employment_info_doc.exists else {}
        
        ccris_profile_doc = firebase_service.db.collection('ccris_credit_profiles').document(ic_number).get()
        ccris_profile = ccris_profile_doc.to_dict() if ccris_profile_doc.exists else {}
        
        credit_score_doc = firebase_service.db.collection('credit_score').document(ic_number).get()
        credit_score_data = credit_score_doc.to_dict() if credit_score_doc.exists else {}
        
        user_doc = firebase_service.db.collection('users').document(ic_number).get()
        user_data = user_doc.to_dict() if user_doc.exists else {}
        
        commitments_data = ml_feature_service.calculateTotalCommitments(ic_number)
        
        # Get existing loans
        existing_loans_query = firebase_service.db.collection('existing_loans').where('icNumber', '==', ic_number).where('status', '==', 'Active')
        existing_loans_docs = list(existing_loans_query.stream())
        
        existing_loans = []
        for doc in existing_loans_docs:
            loan_data = doc.to_dict()
            loan_data['loanId'] = doc.id
            existing_loans.append(convert_timestamps(loan_data))
        
        existing_loans.sort(key=lambda x: x.get('startDate', ''), reverse=True)
        recent_existing_loans = existing_loans[:5]
        
        loan_applications_query = firebase_service.db.collection('loan_applications').where('icNumber', '==', ic_number)
        loan_applications_docs = list(loan_applications_query.stream())
        
        loan_applications = []
        total_applications = len(loan_applications_docs)
        credited_applications = 0
        
        for doc in loan_applications_docs:
            app_data = doc.to_dict()
            app_data['id'] = doc.id
            
            if app_data.get('status') == 'credited':
                credited_applications += 1
            
            loan_applications.append(convert_timestamps(app_data))
        
        total_applications = len(loan_applications_docs)
        active_loans_count = len(existing_loans_docs)
        
        success_rate = (credited_applications / total_applications * 100) if total_applications > 0 else 0.0
        
        monthly_income = employment_info.get('monthlyIncome', 0.0)
        total_commitments = commitments_data['totalCommitments']
        
        # Calculate DSR from current data instead of retrieving stored value
        dsr_percentage = (total_commitments / monthly_income * 100) if monthly_income > 0 else 0.0
        
        # Update stored DSR in CCRIS profile to keep it in sync
        if ccris_profile_doc.exists:
            firebase_service.db.collection('ccris_credit_profiles').document(ic_number).update({
                'debtServiceRatio': round(dsr_percentage, 2),
                'lastUpdated': current_time
            })
        
        credit_score_history = credit_score_data.get('history', [])
        if credit_score_history:
            credit_score_history = credit_score_history[:12]
        
        converted_history = []
        for entry in credit_score_history:
            if isinstance(entry, dict):
                converted_entry = {}
                for k, v in entry.items():
                    if hasattr(v, 'timestamp'):
                        converted_entry[k] = v.isoformat()
                    elif isinstance(v, datetime):
                        converted_entry[k] = v.isoformat()
                    else:
                        converted_entry[k] = v
                converted_history.append(converted_entry)
            else:
                converted_history.append(entry)
        
        ccris_status_value = ccris_profile.get('ccrisStatus', 'Unknown')
        
        # If CCRIS status is missing, calculate and store it
        if ccris_status_value == 'Unknown' and ccris_profile_doc.exists:
            try:
                # Get loan history for missed payments
                loan_history_query = firebase_service.db.collection('loan_history').where('icNumber', '==', ic_number)
                loan_history_docs = list(loan_history_query.stream())
                
                total_missed_payments = 0
                for loan in loan_history_docs:
                    loan_data = loan.to_dict()
                    total_missed_payments += loan_data.get('numberOfMissedPayments', 0)
                
                number_of_defaults = ccris_profile.get('numberOfDefaultPayments', 0)
                
                # Calculate CCRIS status
                if number_of_defaults <= 0 and total_missed_payments <= 1:
                    ccris_status_value = 'Excellent'
                elif number_of_defaults <= 0 and total_missed_payments <= 3:
                    ccris_status_value = 'Good'
                elif number_of_defaults <= 1 or total_missed_payments <= 6:
                    ccris_status_value = 'Fair'
                else:
                    ccris_status_value = 'Poor'
                
                # Store the calculated status for future use
                firebase_service.db.collection('ccris_credit_profiles').document(ic_number).update({
                    'ccrisStatus': ccris_status_value,
                    'lastUpdated': current_time
                })
                
                print(f"[CCRIS STATUS INITIALIZED] {ic_number}: {ccris_status_value}")
            except Exception as e:
                print(f"[WARNING] Failed to initialize CCRIS status for {ic_number}: {str(e)}")
                ccris_status_value = 'Good'  # Default fallback
        
        ccris_good = ccris_status_value.lower() in ['excellent', 'good']
        
        response_data = {
            'userFirstName': personal_info.get('surName', 'User'),
            'registrationDate': user_data.get('createdAt'),
            'currentCreditScore': credit_score_data.get('currentCreditScore', 0),
            'creditScoreHistory': converted_history,
            'existingLoans': recent_existing_loans,
            'financialMetrics': {
                'dsrPercentage': round(dsr_percentage, 2),
                'ccrisGood': ccris_good,
                'totalExistingCommitments': round(total_commitments, 2),
                'dsrBreakdown': {
                    'monthlyIncome': round(monthly_income, 2),
                    'totalCommitments': round(total_commitments, 2),
                    'dsrPercentage': round(dsr_percentage, 2)
                },
                'ccrisDetails': f"CCRIS Status: {ccris_status_value}",
                'commitmentsBreakdown': {
                    'Existing Loans': round(commitments_data['loanCommitments'], 2),
                    'Credit Cards': round(commitments_data['creditCardCommitments'], 2)
                }
            },
            'activeLoansCount': active_loans_count,
            'totalApplicationsCount': total_applications,
            'approvedApplicationsCount': credited_applications,
            'successRate': round(success_rate, 2)
        }
        
        converted_response = convert_timestamps(response_data)
        
        return jsonify({
            'success': True,
            'data': converted_response
        }), 200
        
    except Exception as e:
        return jsonify({
            'success': False,
            'error': 'Failed to get dashboard summary',
            'message': str(e)
        }), 500

def _triggerPredictionIfNeeded(icNumber: str, currentTime: datetime):
    try:
        from threading import Thread
        import uuid
        import sys
        import os
        
        sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
        from routes.credit_score_routes import _predictionJobs, _runPredictionAsync
        
        scoreDoc = firebase_service.db.collection('credit_score').document(icNumber).get()
        
        shouldPredict = False
        if not scoreDoc.exists:
            shouldPredict = True
            print(f"[PREDICTION] No credit score found for {icNumber}, triggering prediction")
        else:
            scoreData = scoreDoc.to_dict()
            lastUpdated = scoreData.get('lastUpdated')
            
            if not lastUpdated:
                shouldPredict = True
                print(f"[PREDICTION] No lastUpdated for {icNumber}, triggering prediction")
            else:
                currentMonth = currentTime.month
                currentYear = currentTime.year
                
                if hasattr(lastUpdated, 'month'):
                    lastMonth = lastUpdated.month
                    lastYear = lastUpdated.year
                else:
                    try:
                        lastUpdatedDate = datetime.fromisoformat(str(lastUpdated))
                        lastMonth = lastUpdatedDate.month
                        lastYear = lastUpdatedDate.year
                    except:
                        shouldPredict = True
                        print(f"[PREDICTION] Invalid lastUpdated format for {icNumber}, triggering prediction")
                        return
                
                if currentYear > lastYear or (currentYear == lastYear and currentMonth > lastMonth):
                    shouldPredict = True
                    print(f"[PREDICTION] New month detected for {icNumber} (last: {lastYear}-{lastMonth:02d}, current: {currentYear}-{currentMonth:02d})")
        
        if shouldPredict:
            jobId = str(uuid.uuid4())
            _predictionJobs[jobId] = {
                'status': 'processing',
                'icNumber': icNumber,
                'startedAt': currentTime,
                'result': None,
                'error': None
            }
            
            thread = Thread(target=_runPredictionAsync, args=(jobId, icNumber))
            thread.daemon = True
            thread.start()
            print(f"[PREDICTION] Prediction triggered for {icNumber} (job: {jobId})")
        else:
            print(f"[PREDICTION] Prediction already exists for {icNumber} this month")
            
    except Exception as e:
        print(f"[PREDICTION ERROR] Failed to check/trigger prediction for {icNumber}: {str(e)}")
