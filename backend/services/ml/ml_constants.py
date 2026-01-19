from enum import Enum

class CreditScoreCategory(Enum):
    POOR = 'Poor'
    FAIR = 'Fair'
    GOOD = 'Good'
    VERY_GOOD = 'Very Good'
    EXCELLENT = 'Excellent'

class CCRISStatus(Enum):
    EXCELLENT = 'Excellent'
    GOOD = 'Good'
    FAIR = 'Fair'
    POOR = 'Poor'

class EmploymentStatusType(Enum):
    EMPLOYED = 'Employed'
    SELF_EMPLOYED = 'Self-Employed'
    UNEMPLOYED = 'Unemployed'

class MLConstants:
    MONTHS_IN_YEAR = 12
    DAYS_IN_YEAR = 365.25
    
    CREDIT_SCORE_POOR_MAX = 579
    CREDIT_SCORE_FAIR_MIN = 580
    CREDIT_SCORE_FAIR_MAX = 669
    CREDIT_SCORE_GOOD_MIN = 670
    CREDIT_SCORE_GOOD_MAX = 739
    CREDIT_SCORE_VERY_GOOD_MIN = 740
    CREDIT_SCORE_VERY_GOOD_MAX = 799
    CREDIT_SCORE_EXCELLENT_MIN = 800
    
    PAYMENT_HISTORY_BASE_SCORE = 100
    PAYMENT_HISTORY_MISSED_PENALTY = 10
    PAYMENT_HISTORY_DEFAULT_PENALTY = 20
    PAYMENT_HISTORY_MIN_SCORE = 0
    
    CCRIS_EXCELLENT_MAX_DEFAULTS = 0
    CCRIS_EXCELLENT_MAX_MISSED = 1
    CCRIS_GOOD_MAX_DEFAULTS = 0
    CCRIS_GOOD_MAX_MISSED = 3
    CCRIS_FAIR_MAX_DEFAULTS = 1
    CCRIS_FAIR_MAX_MISSED = 6
    
    LOAN_STATUS_ACTIVE = 'Active'
    LOAN_STATUS_APPROVED = 'Approved'
    
    DEFAULT_EPF_CONTRIBUTION = 0.0
    DEFAULT_EPF_BALANCE = 0.0
    DEFAULT_EDUCATION_LEVEL = 'Unknown'
    DEFAULT_HOME_OWNERSHIP = 'Unknown'

class EmploymentTypeMapping:
    MAPPINGS = {
        'Permanent': EmploymentStatusType.EMPLOYED,
        'Contract': EmploymentStatusType.EMPLOYED,
        'Part-time': EmploymentStatusType.EMPLOYED,
        'Self-employed': EmploymentStatusType.SELF_EMPLOYED,
        'Freelance': EmploymentStatusType.SELF_EMPLOYED,
        'Business': EmploymentStatusType.SELF_EMPLOYED,
        'Unemployed': EmploymentStatusType.UNEMPLOYED
    }
    
    @staticmethod
    def map(employmentType: str) -> str:
        mapped = EmploymentTypeMapping.MAPPINGS.get(employmentType)
        return mapped.value if mapped else EmploymentStatusType.EMPLOYED.value
