from datetime import datetime
from typing import Optional, List

class User:
    def __init__(
        self,
        ic_number: str,
        profile_image_url: Optional[str] = None,
        sur_name: Optional[str] = None,
        connected_banks: List[str] = None,
        data_consent_given: bool = False,
        data_consent_date: Optional[datetime] = None,
        last_login: Optional[datetime] = None,
        created_at: Optional[datetime] = None
    ):
        self.ic_number = ic_number
        self.profile_image_url = profile_image_url
        self.sur_name = sur_name
        self.connected_banks = connected_banks or []
        self.data_consent_given = data_consent_given
        self.data_consent_date = data_consent_date
        self.last_login = last_login
        self.created_at = created_at or datetime.now()

    def to_dict(self):
        return {
            'icNumber': self.ic_number,
            'profileImageUrl': self.profile_image_url,
            'surName': self.sur_name,
            'connectedBanks': self.connected_banks,
            'dataConsentGiven': self.data_consent_given,
            'dataConsentDate': self.data_consent_date.isoformat() if self.data_consent_date else None,
            'lastLogin': self.last_login.isoformat() if self.last_login else None,
            'createdAt': self.created_at.isoformat()
        }

    def to_firestore(self):
        return {
            'icNumber': self.ic_number,
            'profileImageUrl': self.profile_image_url,
            'surName': self.sur_name,
            'connectedBanks': self.connected_banks,
            'dataConsentGiven': self.data_consent_given,
            'dataConsentDate': self.data_consent_date,
            'lastLogin': self.last_login,
            'createdAt': self.created_at
        }

    @staticmethod
    def from_firestore(doc_data):
        return User(
            ic_number=doc_data.get('icNumber'),
            profile_image_url=doc_data.get('profileImageUrl'),
            sur_name=doc_data.get('surName'),
            connected_banks=doc_data.get('connectedBanks', []),
            data_consent_given=doc_data.get('dataConsentGiven', False),
            data_consent_date=doc_data.get('dataConsentDate'),
            last_login=doc_data.get('lastLogin'),
            created_at=doc_data.get('createdAt')
        )

class BankUser:
    def __init__(
        self,
        bank_id: str,
        username: str,
        password_hash: str,
        ic_number: str,
        account_number: str = '',
        is_active: bool = True,
        last_login_at: Optional[datetime] = None,
        created_at: Optional[datetime] = None
    ):
        self.bank_id = bank_id
        self.username = username
        self.password_hash = password_hash
        self.ic_number = ic_number
        self.account_number = account_number
        self.is_active = is_active
        self.last_login_at = last_login_at
        self.created_at = created_at or datetime.now()

    @property
    def composite_id(self):
        return f"{self.username}_{self.bank_id}"

    def to_dict(self):
        return {
            'bankId': self.bank_id,
            'username': self.username,
            'passwordHash': self.password_hash,
            'icNumber': self.ic_number,
            'accountNumber': self.account_number,
            'isActive': self.is_active,
            'lastLoginAt': self.last_login_at.isoformat() if self.last_login_at else None,
            'createdAt': self.created_at.isoformat()
        }

    def to_firestore(self):
        return {
            'bankId': self.bank_id,
            'username': f"{self.username}_{self.bank_id}",
            'passwordHash': self.password_hash,
            'icNumber': self.ic_number,
            'accountNumber': self.account_number,
            'isActive': self.is_active,
            'lastLoginAt': self.last_login_at,
            'createdAt': self.created_at
        }

    @staticmethod
    def from_firestore(doc_data):
        username = doc_data.get('username', '')
        extracted_username = username.split('_')[0] if '_' in username else username
        
        return BankUser(
            bank_id=doc_data.get('bankId'),
            username=extracted_username,
            password_hash=doc_data.get('passwordHash'),
            ic_number=doc_data.get('icNumber'),
            account_number=doc_data.get('accountNumber', ''),
            is_active=doc_data.get('isActive', True),
            last_login_at=doc_data.get('lastLoginAt'),
            created_at=doc_data.get('createdAt')
        )
