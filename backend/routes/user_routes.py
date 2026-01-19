from flask import Blueprint, request, jsonify
from services.firebase_service import FirebaseService
from models.user import User
from datetime import datetime

bp = Blueprint('user', __name__, url_prefix='/api/user')
firebase_service = FirebaseService()

@bp.route('/<ic_number>', methods=['GET'])
def get_user(ic_number):
    try:
        user = firebase_service.get_user(ic_number)
        
        if user:
            return jsonify({
                'success': True,
                'user': user.to_dict()
            }), 200
        else:
            return jsonify({
                'success': False,
                'message': 'User not found'
            }), 404
            
    except Exception as e:
        return jsonify({
            'error': 'Failed to get user',
            'message': str(e)
        }), 500

@bp.route('/', methods=['POST'])
def create_user():
    try:
        data = request.get_json()
        
        if not data or 'icNumber' not in data:
            return jsonify({
                'error': 'Missing required fields',
                'message': 'icNumber is required'
            }), 400
        
        def parse_datetime(date_str):
            if not date_str:
                return None
            date_str = date_str.replace('Z', '+00:00')
            return datetime.fromisoformat(date_str)
        
        user = User(
            ic_number=data['icNumber'],
            profile_image_url=data.get('profileImageUrl'),
            sur_name=data.get('surName'),
            connected_banks=data.get('connectedBanks', []),
            data_consent_given=data.get('dataConsentGiven', False),
            data_consent_date=parse_datetime(data.get('dataConsentDate')),
            created_at=parse_datetime(data.get('createdAt'))
        )
        
        firebase_service.create_user(user)
        
        return jsonify({
            'success': True,
            'message': 'User created successfully',
            'user': user.to_dict()
        }), 201
        
    except Exception as e:
        return jsonify({
            'error': 'Failed to create user',
            'message': str(e)
        }), 500

@bp.route('/<ic_number>', methods=['PUT'])
def update_user(ic_number):
    try:
        data = request.get_json()
        
        if not data:
            return jsonify({
                'error': 'Missing request body',
                'message': 'User data is required'
            }), 400
        
        def parse_datetime(date_str):
            if not date_str:
                return None
            date_str = date_str.replace('Z', '+00:00')
            return datetime.fromisoformat(date_str)
        
        user = User(
            ic_number=ic_number,
            profile_image_url=data.get('profileImageUrl'),
            sur_name=data.get('surName'),
            connected_banks=data.get('connectedBanks', []),
            data_consent_given=data.get('dataConsentGiven', False),
            data_consent_date=parse_datetime(data.get('dataConsentDate')),
            created_at=parse_datetime(data.get('createdAt')) or datetime.now()
        )
        
        firebase_service.update_user(user)
        
        return jsonify({
            'success': True,
            'message': 'User updated successfully',
            'user': user.to_dict()
        }), 200
        
    except Exception as e:
        return jsonify({
            'error': 'Failed to update user',
            'message': str(e)
        }), 500

@bp.route('/<ic_number>/profile-image', methods=['PUT'])
def update_profile_image(ic_number):
    try:
        data = request.get_json()
        
        if not data or 'imageUrl' not in data:
            return jsonify({
                'error': 'Missing required fields',
                'message': 'imageUrl is required'
            }), 400
        
        image_url = data['imageUrl']
        
        firebase_service.update_profile_image(ic_number, image_url)
        
        return jsonify({
            'success': True,
            'message': 'Profile image updated successfully'
        }), 200
        
    except Exception as e:
        return jsonify({
            'error': 'Failed to update profile image',
            'message': str(e)
        }), 500

@bp.route('/<ic_number>/connected-banks', methods=['POST'])
def add_connected_bank(ic_number):
    try:
        data = request.get_json()
        
        if not data or 'bankId' not in data:
            return jsonify({
                'error': 'Missing required fields',
                'message': 'bankId is required'
            }), 400
        
        bank_id = data['bankId']
        
        firebase_service.add_connected_bank(ic_number, bank_id)
        
        return jsonify({
            'success': True,
            'message': 'Connected bank added successfully'
        }), 200
        
    except Exception as e:
        return jsonify({
            'error': 'Failed to add connected bank',
            'message': str(e)
        }), 500

@bp.route('/current', methods=['GET'])
def get_current_user():
    try:
        ic_number = request.headers.get('X-User-IC-Number')
        
        if not ic_number:
            return jsonify({
                'success': False,
                'message': 'No active session'
            }), 401
        
        user = firebase_service.get_user(ic_number)
        
        if user:
            return jsonify({
                'success': True,
                'user': user.to_dict()
            }), 200
        else:
            return jsonify({
                'success': False,
                'message': 'User not found'
            }), 404
            
    except Exception as e:
        return jsonify({
            'error': 'Failed to get current user',
            'message': str(e)
        }), 500
