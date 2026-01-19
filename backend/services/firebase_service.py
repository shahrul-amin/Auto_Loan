import firebase_admin
from firebase_admin import credentials, firestore, storage
from datetime import datetime
from typing import Optional
from config import Config
from models.user import User, BankUser

class FirebaseService:
    def __init__(self):
        if not firebase_admin._apps:
            try:
                cred = credentials.Certificate(Config.FIREBASE_CREDENTIALS_PATH)
                firebase_admin.initialize_app(cred, {
                    'storageBucket': 'auto-loan-2c1e8.firebasestorage.app'
                })
                print("Firebase Admin SDK initialized successfully")
            except Exception as e:
                print(f"Warning: Firebase initialization failed: {e}")
                print("Running without Firebase connection")
        
        self.db = firestore.client()
        try:
            self.storage_bucket = storage.bucket()
        except Exception as e:
            print(f"Warning: Storage bucket initialization failed: {e}")
            self.storage_bucket = None
        self._pending_auth = {}

    def get_personal_info(self, ic_number: str) -> Optional[dict]:
        try:
            doc = self.db.collection('personal_info').document(ic_number).get()
            if not doc.exists:
                return None
            return doc.to_dict()
        except Exception as e:
            raise Exception(f"Failed to get personal info: {str(e)}")

    def get_bank_user(self, bank_id: str, username: str) -> Optional[BankUser]:
        try:
            composite_id = f"{username}_{bank_id}"
            doc = self.db.collection('bank_users').document(composite_id).get()
            
            if not doc.exists:
                return None
            
            return BankUser.from_firestore(doc.to_dict())
        except Exception as e:
            raise Exception(f"Failed to get bank user: {str(e)}")

    def validate_username(self, bank_code: str, username: str) -> Optional[dict]:
        try:
            composite_username = f"{username}_{bank_code}"
            doc = self.db.collection('bank_users').document(composite_username).get()
            
            if not doc.exists or not doc.to_dict().get('isActive', False):
                return None
            
            ic_number = doc.to_dict().get('icNumber')
            
            user_doc = self.db.collection('users').document(ic_number).get()
            
            profile_image = None
            if user_doc.exists and user_doc.to_dict().get('profileImageUrl'):
                profile_image = user_doc.to_dict().get('profileImageUrl')
            else:
                profile_image = f"https://i.pravatar.cc/150?u={username}"
            
            return {
                'userIcon': profile_image,
                'icNumber': ic_number
            }
        except Exception as e:
            raise Exception(f"Failed to validate username: {str(e)}")

    def validate_password(self, bank_code: str, username: str, password: str) -> bool:
        try:
            composite_username = f"{username}_{bank_code}"
            doc = self.db.collection('bank_users').document(composite_username).get()
            
            if not doc.exists:
                return False
            
            data = doc.to_dict()
            return data.get('passwordHash') == password and data.get('isActive', False)
        except Exception as e:
            raise Exception(f"Failed to validate password: {str(e)}")

    def update_last_login(self, bank_id: str, username: str):
        try:
            composite_id = f"{username}_{bank_id}"
            self.db.collection('bank_users').document(composite_id).update({
                'lastLoginAt': firestore.SERVER_TIMESTAMP
            })
        except Exception as e:
            raise Exception(f"Failed to update last login: {str(e)}")

    def get_user(self, ic_number: str) -> Optional[User]:
        try:
            doc = self.db.collection('users').document(ic_number).get()
            
            if not doc.exists:
                return None
            
            return User.from_firestore(doc.to_dict())
        except Exception as e:
            raise Exception(f"Failed to get user: {str(e)}")

    def create_user(self, user: User):
        try:
            self.db.collection('users').document(user.ic_number).set(user.to_firestore())
        except Exception as e:
            raise Exception(f"Failed to create user: {str(e)}")

    def update_user(self, user: User):
        try:
            self.db.collection('users').document(user.ic_number).update(user.to_firestore())
        except Exception as e:
            raise Exception(f"Failed to update user: {str(e)}")

    def update_profile_image(self, ic_number: str, image_url: str):
        try:
            self.db.collection('users').document(ic_number).update({
                'profileImageUrl': image_url
            })
        except Exception as e:
            raise Exception(f"Failed to update profile image: {str(e)}")

    def add_connected_bank(self, ic_number: str, bank_id: str):
        try:
            user_ref = self.db.collection('users').document(ic_number)
            user_ref.update({
                'connectedBanks': firestore.ArrayUnion([bank_id])
            })
        except Exception as e:
            raise Exception(f"Failed to add connected bank: {str(e)}")

    def store_pending_auth(self, bank_id: str, username: str, ic_number: str):
        key = f"{bank_id}_{username}"
        self._pending_auth[key] = {
            'bank_id': bank_id,
            'username': username,
            'ic_number': ic_number,
            'timestamp': datetime.now()
        }

    def get_pending_auth(self, bank_id: str, username: str) -> Optional[dict]:
        key = f"{bank_id}_{username}"
        return self._pending_auth.get(key)

    def clear_pending_auth(self, bank_id: str, username: str):
        key = f"{bank_id}_{username}"
        if key in self._pending_auth:
            del self._pending_auth[key]

    def get_officer_email_for_user(self, ic_number: str) -> Optional[str]:
        """Get the loan officer email for the user's connected bank"""
        try:
            user = self.get_user(ic_number)
            if not user or not user.connected_banks:
                return None
            
            primary_bank_id = user.connected_banks[0]
            
            bank_doc = self.db.collection('banks').document(primary_bank_id).get()
            if not bank_doc.exists:
                return None
            
            bank_data = bank_doc.to_dict()
            return bank_data.get('loanOfficerEmail')
        except Exception as e:
            raise Exception(f"Failed to get officer email: {str(e)}")

    def check_duplicate_application(self, ic_number: str, loan_type: str) -> bool:
        """Check if user has an active application for the same loan type"""
        try:
            existing_query = self.db.collection('loan_applications')\
                .where('icNumber', '==', ic_number)\
                .where('loanType', '==', loan_type)\
                .where('status', 'in', ['pending', 'approved'])\
                .limit(1)\
                .stream()
            
            existing_apps = list(existing_query)
            return len(existing_apps) > 0
        except Exception as e:
            raise Exception(f"Failed to check duplicate application: {str(e)}")
