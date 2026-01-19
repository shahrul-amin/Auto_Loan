from twilio.rest import Client
from config import Config
import logging
from datetime import datetime, timedelta

logger = logging.getLogger(__name__)

class TwilioService:
    def __init__(self):
        self.client = Client(
            Config.TWILIO_ACCOUNT_SID,
            Config.TWILIO_AUTH_TOKEN
        )
        self.verify_sid = Config.TWILIO_VERIFY_SID
        self._rate_limit_store = {}
        self.MAX_ATTEMPTS_PER_HOUR = 3
        self.COOLDOWN_MINUTES = 60
    
    def _check_rate_limit(self, phone_number: str) -> tuple[bool, str]:
        """Check if phone number has exceeded rate limit. Returns (is_allowed, error_message)"""
        now = datetime.now()
        
        if phone_number in self._rate_limit_store:
            attempts = self._rate_limit_store[phone_number]
            
            recent_attempts = [
                timestamp for timestamp in attempts
                if now - timestamp < timedelta(minutes=self.COOLDOWN_MINUTES)
            ]
            
            self._rate_limit_store[phone_number] = recent_attempts
            
            if len(recent_attempts) >= self.MAX_ATTEMPTS_PER_HOUR:
                minutes_left = int(
                    (self.COOLDOWN_MINUTES - (now - recent_attempts[0]).total_seconds() / 60)
                )
                return False, f"Too many attempts. Please try again in {minutes_left} minutes."
        
        return True, ""
    
    def _record_attempt(self, phone_number: str):
        """Record an OTP send attempt"""
        if phone_number not in self._rate_limit_store:
            self._rate_limit_store[phone_number] = []
        self._rate_limit_store[phone_number].append(datetime.now())
    
    def send_verification(self, phone_number: str) -> tuple[bool, str]:
        """Send verification code. Returns (success, message)"""
        is_allowed, error_msg = self._check_rate_limit(phone_number)
        if not is_allowed:
            logger.warning(f"Rate limit exceeded for {phone_number}")
            return False, error_msg
        
        try:
            verification = self.client.verify \
                .v2 \
                .services(self.verify_sid) \
                .verifications \
                .create(to=phone_number, channel='sms')
            
            logger.info(f"OTP sent to {phone_number}, status: {verification.status}")
            
            if verification.status == 'pending':
                self._record_attempt(phone_number)
                return True, "OTP sent successfully"
            else:
                return False, f"Failed to send OTP: {verification.status}"
                
        except Exception as e:
            logger.error(f"Failed to send OTP to {phone_number}: {str(e)}")
            return False, f"Failed to send OTP: {str(e)}"
    
    def check_verification(self, phone_number: str, code: str) -> bool:
        try:
            verification_check = self.client.verify \
                .v2 \
                .services(self.verify_sid) \
                .verification_checks \
                .create(to=phone_number, code=code)
            
            logger.info(f"OTP verification for {phone_number}, status: {verification_check.status}")
            return verification_check.status == 'approved'
        except Exception as e:
            logger.error(f"Failed to verify OTP for {phone_number}: {str(e)}")
            return False
