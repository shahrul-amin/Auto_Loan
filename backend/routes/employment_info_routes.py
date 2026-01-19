from flask import Blueprint, request, jsonify
from services.firebase_service import FirebaseService
from google.cloud.firestore_v1 import SERVER_TIMESTAMP
from datetime import datetime

bp = Blueprint('employment_info', __name__, url_prefix='/api/profile/employment')
firebase_service = FirebaseService()

def serialize_timestamp(data):
    """Convert Firestore timestamps to ISO format strings"""
    if isinstance(data, dict):
        result = {}
        for key, value in data.items():
            if hasattr(value, 'timestamp'):  # Firestore Timestamp
                result[key] = datetime.fromtimestamp(value.timestamp()).isoformat()
            elif isinstance(value, dict):
                result[key] = serialize_timestamp(value)
            else:
                result[key] = value
        return result
    return data

@bp.route('/<ic_number>', methods=['GET'])
def get_employment_info(ic_number):
    try:
        doc = firebase_service.db.collection('employment_info').document(ic_number).get()
        
        if not doc.exists:
            return jsonify({
                'success': False,
                'message': 'Employment info not found'
            }), 404
        
        employment_data = serialize_timestamp(doc.to_dict())
        
        return jsonify({
            'success': True,
            'employmentInfo': employment_data
        }), 200
        
    except Exception as e:
        return jsonify({
            'error': 'Failed to get employment info',
            'message': str(e)
        }), 500

@bp.route('/', methods=['POST'])
def create_employment_info():
    try:
        data = request.get_json()
        
        if not data or 'icNumber' not in data:
            return jsonify({
                'error': 'Missing required fields',
                'message': 'icNumber is required'
            }), 400
        
        ic_number = data['icNumber']
        firebase_service.db.collection('employment_info').document(ic_number).set(data)
        
        return jsonify({
            'success': True,
            'message': 'Employment info created successfully',
            'employmentInfo': data
        }), 201
        
    except Exception as e:
        return jsonify({
            'error': 'Failed to create employment info',
            'message': str(e)
        }), 500

@bp.route('/<ic_number>', methods=['PUT'])
def update_employment_info(ic_number):
    try:
        data = request.get_json()
        
        if not data:
            return jsonify({
                'error': 'Missing request body',
                'message': 'Employment info data is required'
            }), 400
        
        firebase_service.db.collection('employment_info').document(ic_number).update(data)
        
        return jsonify({
            'success': True,
            'message': 'Employment info updated successfully',
            'employmentInfo': data
        }), 200
        
    except Exception as e:
        return jsonify({
            'error': 'Failed to update employment info',
            'message': str(e)
        }), 500
