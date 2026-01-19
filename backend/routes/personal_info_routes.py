from flask import Blueprint, request, jsonify
from services.firebase_service import FirebaseService
from google.cloud.firestore_v1 import SERVER_TIMESTAMP
from datetime import datetime

bp = Blueprint('personal_info', __name__, url_prefix='/api/profile/personal')
firebase_service = FirebaseService()

def convert_timestamps(data):
    """Convert Firestore timestamps to ISO format strings"""
    if not data:
        return data
    
    converted = {}
    for key, value in data.items():
        if hasattr(value, 'timestamp'):  # Firestore Timestamp
            converted[key] = value.isoformat()
        elif isinstance(value, datetime):
            converted[key] = value.isoformat()
        else:
            converted[key] = value
    return converted

@bp.route('/<ic_number>', methods=['GET'])
def get_personal_info(ic_number):
    try:
        doc = firebase_service.db.collection('personal_info').document(ic_number).get()
        
        if not doc.exists:
            return jsonify({
                'success': False,
                'message': 'Personal info not found'
            }), 404
        
        data = doc.to_dict()
        converted_data = convert_timestamps(data)
        
        return jsonify({
            'success': True,
            'personalInfo': converted_data
        }), 200
        
    except Exception as e:
        return jsonify({
            'error': 'Failed to get personal info',
            'message': str(e)
        }), 500

@bp.route('/', methods=['POST'])
def create_personal_info():
    try:
        data = request.get_json()
        
        if not data or 'icNumber' not in data:
            return jsonify({
                'error': 'Missing required fields',
                'message': 'icNumber is required'
            }), 400
        
        ic_number = data['icNumber']
        firebase_service.db.collection('personal_info').document(ic_number).set(data)
        
        return jsonify({
            'success': True,
            'message': 'Personal info created successfully',
            'personalInfo': data
        }), 201
        
    except Exception as e:
        return jsonify({
            'error': 'Failed to create personal info',
            'message': str(e)
        }), 500

@bp.route('/<ic_number>', methods=['PUT'])
def update_personal_info(ic_number):
    try:
        data = request.get_json()
        
        if not data:
            return jsonify({
                'error': 'Missing request body',
                'message': 'Personal info data is required'
            }), 400
        
        firebase_service.db.collection('personal_info').document(ic_number).update(data)
        
        return jsonify({
            'success': True,
            'message': 'Personal info updated successfully',
            'personalInfo': data
        }), 200
        
    except Exception as e:
        return jsonify({
            'error': 'Failed to update personal info',
            'message': str(e)
        }), 500
