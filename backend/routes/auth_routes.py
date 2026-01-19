from flask import Blueprint, request, jsonify
from services.firebase_service import FirebaseService
from services.twilio_service import TwilioService
from threading import Thread
import logging

bp = Blueprint('auth', __name__, url_prefix='/api/auth')
firebase_service = FirebaseService()
twilio_service = TwilioService()
logger = logging.getLogger(__name__)

@bp.route('/validate-username', methods=['POST'])
def validate_username():
    try:
        data = request.get_json()
        
        if not data or 'bankCode' not in data or 'username' not in data:
            return jsonify({
                'error': 'Missing required fields',
                'message': 'bankCode and username are required'
            }), 400
        
        bank_code = data['bankCode']
        username = data['username']
        
        result = firebase_service.validate_username(bank_code, username)
        
        if result:
            return jsonify({
                'success': True,
                'userIcon': result['userIcon'],
                'icNumber': result['icNumber']
            }), 200
        else:
            return jsonify({
                'success': False,
                'message': 'Username not found or inactive'
            }), 404
            
    except Exception as e:
        return jsonify({
            'error': 'Validation failed',
            'message': str(e)
        }), 500

@bp.route('/validate-password', methods=['POST'])
def validate_password():
    try:
        data = request.get_json()
        
        if not data or 'bankCode' not in data or 'username' not in data or 'password' not in data:
            return jsonify({
                'error': 'Missing required fields',
                'message': 'bankCode, username, and password are required'
            }), 400
        
        bank_code = data['bankCode']
        username = data['username']
        password = data['password']
        
        is_valid = firebase_service.validate_password(bank_code, username, password)
        
        if is_valid:
            bank_user = firebase_service.get_bank_user(bank_code, username)
            if bank_user:
                firebase_service.store_pending_auth(bank_code, username, bank_user.ic_number)
            
            return jsonify({
                'success': True,
                'message': 'Password validated successfully'
            }), 200
        else:
            return jsonify({
                'success': False,
                'message': 'Invalid password'
            }), 401
            
    except Exception as e:
        return jsonify({
            'error': 'Validation failed',
            'message': str(e)
        }), 500

@bp.route('/send-otp', methods=['POST'])
def send_otp():
    try:
        data = request.get_json()
        
        if not data or 'bankCode' not in data or 'username' not in data:
            return jsonify({
                'error': 'Missing required fields',
                'message': 'bankCode and username are required'
            }), 400
        
        bank_code = data['bankCode']
        username = data['username']
        
        logger.info(f"Sending OTP - bankCode: {bank_code}, username: {username}")
        
        bank_user = firebase_service.get_bank_user(bank_code, username)
        if not bank_user:
            return jsonify({
                'error': 'User not found',
                'message': 'Bank user not found'
            }), 404
        
        personal_info = firebase_service.get_personal_info(bank_user.ic_number)
        if not personal_info or not personal_info.get('phoneNumber'):
            return jsonify({
                'error': 'Phone number not found',
                'message': 'User phone number not found in personal info'
            }), 404
        
        phone_number = personal_info['phoneNumber']
        logger.info(f"Sending OTP to: {phone_number}")
        
        sent, message = twilio_service.send_verification(phone_number)
        if not sent:
            return jsonify({
                'error': 'Failed to send OTP',
                'message': message
            }), 429 if 'Too many attempts' in message else 500
        
        masked_phone = phone_number[-4:]
        logger.info(f"OTP sent successfully to ****{masked_phone}")
        
        return jsonify({
            'success': True,
            'message': f'OTP sent to ****{masked_phone}'
        }), 200
        
    except Exception as e:
        logger.error(f"Failed to send OTP: {str(e)}")
        return jsonify({
            'error': 'Failed to send OTP',
            'message': str(e)
        }), 500

@bp.route('/verify-otp', methods=['POST'])
def verify_otp():
    try:
        data = request.get_json()
        
        if not data or 'bankCode' not in data or 'username' not in data or 'otp' not in data:
            return jsonify({
                'error': 'Missing required fields',
                'message': 'bankCode, username, and otp are required'
            }), 400
        
        bank_code = data['bankCode']
        username = data['username']
        otp = data['otp']
        
        logger.info(f"Verifying OTP - bankCode: {bank_code}, username: {username}")
        
        bank_user = firebase_service.get_bank_user(bank_code, username)
        if not bank_user:
            return jsonify({
                'error': 'User not found',
                'message': 'Bank user not found'
            }), 404
        
        personal_info = firebase_service.get_personal_info(bank_user.ic_number)
        if not personal_info or not personal_info.get('phoneNumber'):
            return jsonify({
                'error': 'Phone number not found',
                'message': 'User phone number not found'
            }), 404
        
        phone_number = personal_info['phoneNumber']
        
        is_valid = twilio_service.check_verification(phone_number, otp)
        
        if is_valid:
            firebase_service.update_last_login(bank_code, username)
            _updateUserLastLogin(bank_user.ic_number)
            
            logger.info(f"OTP verified successfully for {username}")
            
            return jsonify({
                'success': True,
                'message': 'OTP verified successfully'
            }), 200
        else:
            logger.warning(f"Invalid OTP for {username}")
            return jsonify({
                'success': False,
                'message': 'Invalid OTP code'
            }), 401
            
    except Exception as e:
        logger.error(f"OTP verification failed: {str(e)}")
        return jsonify({
            'error': 'OTP verification failed',
            'message': str(e)
        }), 500

@bp.route('/complete-authentication', methods=['POST'])
def complete_authentication():
    try:
        data = request.get_json()
        
        if not data or 'bankId' not in data or 'username' not in data:
            return jsonify({
                'error': 'Missing required fields',
                'message': 'bankId and username are required'
            }), 400
        
        bank_id = data['bankId']
        username = data['username']
        
        bank_user = firebase_service.get_bank_user(bank_id, username)
        if not bank_user:
            return jsonify({
                'error': 'Bank user not found',
                'message': 'User not found in the system'
            }), 404
        
        user = firebase_service.get_user(bank_user.ic_number)
        if not user:
            return jsonify({
                'error': 'User not found',
                'message': 'User profile not found'
            }), 404
        
        firebase_service.store_pending_auth(bank_id, username, user.ic_number)
        
        return jsonify({
            'success': True,
            'user': user.to_dict()
        }), 200
        
    except Exception as e:
        return jsonify({
            'error': 'Authentication failed',
            'message': str(e)
        }), 500

def _updateUserLastLogin(icNumber: str):
    try:
        from datetime import datetime, timezone, timedelta
        logger.info(f"[DEBUG] Starting lastLogin update for {icNumber}")
        
        userRef = firebase_service.db.collection('users').document(icNumber)
        userDoc = userRef.get()
        
        if not userDoc.exists:
            logger.error(f"[DEBUG] User document not found for {icNumber}")
            return
        
        malaysia_tz = timezone(timedelta(hours=8))
        currentTime = datetime.now(malaysia_tz)
        userRef.update({'lastLogin': currentTime})
        logger.info(f"[DEBUG] Successfully updated lastLogin for {icNumber} to {currentTime}")
        
    except Exception as e:
        logger.error(f"[DEBUG] Failed to update lastLogin for {icNumber}: {str(e)}", exc_info=True)

@bp.route('/resend-otp', methods=['POST'])
def resend_otp():
    try:
        data = request.get_json()
        
        if not data or 'bankCode' not in data or 'username' not in data:
            return jsonify({
                'error': 'Missing required fields',
                'message': 'bankCode and username are required'
            }), 400
        
        bank_code = data['bankCode']
        username = data['username']
        
        logger.info(f"Resending OTP - bankCode: {bank_code}, username: {username}")
        
        bank_user = firebase_service.get_bank_user(bank_code, username)
        if not bank_user:
            return jsonify({
                'error': 'User not found',
                'message': 'Bank user not found'
            }), 404
        
        personal_info = firebase_service.get_personal_info(bank_user.ic_number)
        if not personal_info or not personal_info.get('phoneNumber'):
            return jsonify({
                'error': 'Phone number not found',
                'message': 'User phone number not found'
            }), 404
        
        phone_number = personal_info['phoneNumber']
        
        sent = twilio_service.send_verification(phone_number)
        if not sent:
            return jsonify({
                'error': 'Failed to resend OTP',
                'message': 'Could not send SMS verification code'
            }), 500
        
        masked_phone = phone_number[-4:]
        logger.info(f"OTP resent successfully to ****{masked_phone}")
        
        return jsonify({
            'success': True,
            'message': f'OTP resent to ****{masked_phone}'
        }), 200
        
    except Exception as e:
        logger.error(f"Failed to resend OTP: {str(e)}")
        return jsonify({
            'error': 'Failed to resend OTP',
            'message': str(e)
        }), 500
