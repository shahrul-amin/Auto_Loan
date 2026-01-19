from flask import Blueprint, jsonify
from services.firebase_service import FirebaseService

bp = Blueprint('banks', __name__, url_prefix='/api/banks')
firebase_service = FirebaseService()

@bp.route('/', methods=['GET'])
def get_all_banks():
    try:
        banks_ref = firebase_service.db.collection('banks').where('isActive', '==', True).stream()
        
        banks = []
        for bank_doc in banks_ref:
            bank_data = bank_doc.to_dict()
            banks.append(bank_data)
        
        banks.sort(key=lambda x: x['bankName'])
        
        return jsonify({
            'success': True,
            'data': banks
        }), 200
        
    except Exception as e:
        return jsonify({
            'error': 'Failed to fetch banks',
            'message': str(e)
        }), 500

@bp.route('/<bank_id>', methods=['GET'])
def get_bank(bank_id):
    try:
        bank_doc = firebase_service.db.collection('banks').document(bank_id).get()
        
        if not bank_doc.exists:
            return jsonify({
                'success': False,
                'message': 'Bank not found'
            }), 404
        
        return jsonify({
            'success': True,
            'data': bank_doc.to_dict()
        }), 200
        
    except Exception as e:
        return jsonify({
            'error': 'Failed to fetch bank',
            'message': str(e)
        }), 500
