from flask import Blueprint, request, jsonify
from services.firebase_service import FirebaseService
from datetime import datetime
from threading import Thread
import logging
import uuid

bp = Blueprint('credit_score', __name__, url_prefix='/api/credit/score')
firebase_service = FirebaseService()
logger = logging.getLogger(__name__)

_predictionJobs = {}

@bp.route('/overview/<ic_number>', methods=['GET'])
def get_credit_overview(ic_number):
    """Get complete credit overview including score, category, and all credit cards with bank details"""
    try:
        credit_score_doc = firebase_service.db.collection('credit_score').document(ic_number).get()
        
        if not credit_score_doc.exists:
            return jsonify({
                'success': False,
                'error': 'Credit score not found',
                'message': f'No credit score data for IC number: {ic_number}'
            }), 404
        
        credit_score_data = credit_score_doc.to_dict()
        
        credit_cards_query = firebase_service.db.collection('credit_cards')\
            .where('icNumber', '==', ic_number)\
            .where('isActive', '==', True)\
            .stream()
        
        credit_cards = []
        for card_doc in credit_cards_query:
            card_data = card_doc.to_dict()
            
            bank_id = card_data.get('bankId')
            if bank_id:
                bank_doc = firebase_service.db.collection('banks').document(bank_id).get()
                if bank_doc.exists:
                    bank_data = bank_doc.to_dict()
                    card_data['bankName'] = bank_data.get('bankName')
                    card_data['bankLogoUrl'] = bank_data.get('bankLogoUrl')
                    card_data['primaryColor'] = bank_data.get('primaryColor')
                    card_data['cardScheme'] = bank_data.get('cardScheme')
            
            card_number = card_data.get('accountReference', '')
            if len(card_number) >= 4:
                masked_part = '•' * (len(card_number) - 4)
                visible_part = card_number[-4:]
                
                masked_formatted = ' '.join([masked_part[i:i+4] for i in range(0, len(masked_part), 4)])
                card_data['maskedCardNumber'] = f"{masked_formatted} {visible_part}".strip()
            else:
                card_data['maskedCardNumber'] = card_number
            
            credit_cards.append({
                'id': card_data.get('creditCardId'),
                'cardNumber': card_data.get('accountReference'),
                'maskedCardNumber': card_data.get('maskedCardNumber'),
                'bankId': card_data.get('bankId'),
                'bankName': card_data.get('bankName'),
                'bankLogoUrl': card_data.get('bankLogoUrl'),
                'primaryColor': card_data.get('primaryColor'),
                'cardScheme': card_data.get('cardScheme'),
                'currentBalance': card_data.get('currentBalance'),
                'creditLimit': card_data.get('creditLimit'),
                'availableCredit': card_data.get('availableCredit'),
            })
        
        last_updated = credit_score_data.get('lastUpdated')
        if hasattr(last_updated, 'isoformat'):
            last_updated_str = last_updated.isoformat()
        elif isinstance(last_updated, str):
            last_updated_str = last_updated
        else:
            last_updated_str = datetime.now().isoformat()
        
        response_data = {
            'creditScore': {
                'score': credit_score_data.get('currentCreditScore'),
                'category': credit_score_data.get('currentCategory'),
                'lastUpdated': last_updated_str,
            },
            'creditCards': credit_cards
        }
        
        return jsonify({
            'success': True,
            'data': response_data
        }), 200
        
    except Exception as e:
        return jsonify({
            'success': False,
            'error': 'Failed to get credit overview',
            'message': str(e)
        }), 500

def convert_timestamps(data):
    """Convert Firestore timestamps to ISO format strings"""
    if not data:
        return data
    
    converted = {}
    for key, value in data.items():
        if key == 'predictions' and isinstance(value, list):
            converted[key] = []
            for pred in value:
                pred_converted = {}
                for k, v in pred.items():
                    if hasattr(v, 'timestamp'):
                        pred_converted[k] = v.isoformat()
                    elif isinstance(v, datetime):
                        pred_converted[k] = v.isoformat()
                    else:
                        pred_converted[k] = v
                converted[key].append(pred_converted)
        elif hasattr(value, 'timestamp'):
            converted[key] = value.isoformat()
        elif isinstance(value, datetime):
            converted[key] = value.isoformat()
        else:
            converted[key] = value
    return converted

@bp.route('/<ic_number>', methods=['GET'])
def get_credit_score(ic_number):
    """Get current credit score for a user"""
    try:
        doc = firebase_service.db.collection('credit_score').document(ic_number).get()
        
        if not doc.exists:
            return jsonify({
                'success': True,
                'data': None,
                'message': 'No credit score found'
            }), 200
        
        data = doc.to_dict()
        converted_data = convert_timestamps(data)
        
        return jsonify({
            'success': True,
            'data': {
                'icNumber': converted_data.get('icNumber'),
                'currentCreditScore': converted_data.get('currentCreditScore'),
                'currentCategory': converted_data.get('currentCategory'),
                'lastUpdated': converted_data.get('lastUpdated')
            }
        }), 200
        
    except Exception as e:
        return jsonify({
            'success': False,
            'error': 'Failed to get credit score',
            'message': str(e)
        }), 500

@bp.route('/<ic_number>/history', methods=['GET'])
def get_credit_score_history(ic_number):
    """Get credit score history for a user"""
    try:
        limit = request.args.get('limit', 12, type=int)
        
        doc = firebase_service.db.collection('credit_score').document(ic_number).get()
        
        if not doc.exists:
            return jsonify({
                'success': True,
                'data': [],
                'message': 'No credit score history found'
            }), 200
        
        data = doc.to_dict()
        converted_data = convert_timestamps(data)
        
        history = converted_data.get('history', [])
        limited_history = history[:limit] if history and limit else history
        
        return jsonify({
            'success': True,
            'data': limited_history,
            'count': len(limited_history) if limited_history else 0
        }), 200
        
    except Exception as e:
        return jsonify({
            'success': False,
            'error': 'Failed to get credit score history',
            'message': str(e)
        }), 500

@bp.route('/', methods=['POST'])
def create_credit_score():
    """Create a new credit score record"""
    try:
        data = request.get_json()
        
        if not data or 'icNumber' not in data:
            return jsonify({
                'error': 'Missing required fields',
                'message': 'icNumber is required'
            }), 400
        
        ic_number = data['icNumber']
        firebase_service.db.collection('credit_score').document(ic_number).set(data)
        
        return jsonify({
            'success': True,
            'message': 'Credit score created successfully',
            'data': data
        }), 201
        
    except Exception as e:
        return jsonify({
            'error': 'Failed to create credit score',
            'message': str(e)
        }), 500

@bp.route('/<ic_number>', methods=['PUT'])
def update_credit_score(ic_number):
    """Update credit score record"""
    try:
        data = request.get_json()
        
        if not data:
            return jsonify({
                'error': 'Missing request body',
                'message': 'Credit score data is required'
            }), 400
        
        firebase_service.db.collection('credit_score').document(ic_number).update(data)
        
        return jsonify({
            'success': True,
            'message': 'Credit score updated successfully',
            'data': data
        }), 200
        
    except Exception as e:
        return jsonify({
            'success': False,
            'error': 'Failed to update credit score',
            'message': str(e)
        }), 500

@bp.route('/trigger-prediction/<ic_number>', methods=['POST'])
def trigger_prediction(ic_number):
    try:
        scoreDoc = firebase_service.db.collection('credit_score').document(ic_number).get()
        
        if scoreDoc.exists:
            scoreData = scoreDoc.to_dict()
            lastUpdated = scoreData.get('lastUpdated')
            
            if lastUpdated:
                currentDate = datetime.now()
                currentMonth = currentDate.month
                currentYear = currentDate.year
                
                if hasattr(lastUpdated, 'month'):
                    lastMonth = lastUpdated.month
                    lastYear = lastUpdated.year
                else:
                    try:
                        lastUpdatedDate = datetime.fromisoformat(str(lastUpdated))
                        lastMonth = lastUpdatedDate.month
                        lastYear = lastUpdatedDate.year
                    except:
                        lastMonth = 0
                        lastYear = 0
                
                if currentYear == lastYear and currentMonth == lastMonth:
                    logger.info(f"Prediction already exists for {ic_number} this month ({currentYear}-{currentMonth:02d})")
                    return jsonify({
                        'success': False,
                        'error': 'Already predicted this month',
                        'message': f'Prediction already completed for {currentYear}-{currentMonth:02d}'
                    }), 400
        
        jobId = str(uuid.uuid4())
        _predictionJobs[jobId] = {
            'status': 'processing',
            'icNumber': ic_number,
            'startedAt': datetime.now(),
            'result': None,
            'error': None
        }
        
        thread = Thread(target=_runPredictionAsync, args=(jobId, ic_number))
        thread.daemon = True
        thread.start()
        
        logger.info(f"Prediction triggered for {ic_number} (job: {jobId})")
        return jsonify({
            'success': True,
            'message': 'Prediction started',
            'jobId': jobId
        }), 202
        
    except Exception as e:
        logger.error(f"Failed to trigger prediction for {ic_number}: {str(e)}", exc_info=True)
        return jsonify({
            'success': False,
            'error': 'Failed to trigger prediction',
            'message': str(e)
        }), 500

@bp.route('/prediction-status/<job_id>', methods=['GET'])
def get_prediction_status(job_id):
    try:
        if job_id not in _predictionJobs:
            return jsonify({
                'success': False,
                'error': 'Job not found',
                'message': f'No prediction job with ID: {job_id}'
            }), 404
        
        job = _predictionJobs[job_id]
        
        response = {
            'success': True,
            'status': job['status'],
            'icNumber': job['icNumber'],
            'startedAt': job['startedAt'].isoformat()
        }
        
        if job['status'] == 'completed' and job['result']:
            response['result'] = {
                'predictedScore': job['result']['predictedScore'],
                'predictedCategory': job['result']['predictedCategory'],
                'completedAt': job['result']['completedAt']
            }
        elif job['status'] == 'failed' and job['error']:
            response['error'] = job['error']
        
        return jsonify(response), 200
        
    except Exception as e:
        return jsonify({
            'success': False,
            'error': 'Failed to get prediction status',
            'message': str(e)
        }), 500

def _runPredictionAsync(jobId: str, icNumber: str):
    try:
        from services.ml.ml_prediction_service import CreditScorePredictionService
        from utils.credit_score_updater import CreditScoreUpdater
        
        logger.info(f"Starting prediction for {icNumber} (job: {jobId})")
        
        predictionService = CreditScorePredictionService(firebase_service)
        prediction = predictionService.predict(icNumber)
        
        if prediction is None:
            _predictionJobs[jobId]['status'] = 'failed'
            _predictionJobs[jobId]['error'] = 'Prediction failed - insufficient data'
            logger.warning(f"Prediction failed for {icNumber} (job: {jobId})")
            return
        
        success = CreditScoreUpdater.updateCreditScore(
            firebase_service,
            prediction['icNumber'],
            prediction['predictedScore'],
            prediction['predictedCategory']
        )
        
        if success:
            _predictionJobs[jobId]['status'] = 'completed'
            _predictionJobs[jobId]['result'] = {
                'predictedScore': prediction['predictedScore'],
                'predictedCategory': prediction['predictedCategory'],
                'completedAt': datetime.now().isoformat()
            }
            logger.info(f"Prediction successful for {icNumber} (job: {jobId}): {prediction['predictedScore']} ({prediction['predictedCategory']})")
        else:
            _predictionJobs[jobId]['status'] = 'failed'
            _predictionJobs[jobId]['error'] = 'Failed to update credit score in database'
            logger.error(f"Failed to update credit score for {icNumber} (job: {jobId})")
            
    except Exception as e:
        _predictionJobs[jobId]['status'] = 'failed'
        _predictionJobs[jobId]['error'] = str(e)
        logger.error(f"Async prediction failed for {icNumber} (job: {jobId}): {str(e)}", exc_info=True)
