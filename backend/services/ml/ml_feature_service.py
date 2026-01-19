from datetime import datetime, timezone
from typing import List, Optional, Dict, Any
from services.firebase_service import FirebaseService
from services.ml.ml_constants import (
    MLConstants, 
    CreditScoreCategory, 
    CCRISStatus, 
    EmploymentTypeMapping
)

class MLFeatureService:
    def __init__(self, firebaseService: FirebaseService):
        self._firebaseService = firebaseService
    
    def getAllFeatures(self, icNumber: str, applicationId: Optional[str] = None) -> Dict[str, Any]:
        personalInfo = self._firebaseService.db.collection('personal_info').document(icNumber).get()
        employmentInfo = self._firebaseService.db.collection('employment_info').document(icNumber).get()
        user = self._firebaseService.db.collection('users').document(icNumber).get()
        ccrisProfile = self._firebaseService.db.collection('ccris_credit_profiles').document(icNumber).get()
        
        creditCards = list(self._firebaseService.db.collection('credit_cards')
                          .where('icNumber', '==', icNumber)
                          .where('isActive', '==', True)
                          .stream())
        
        existingLoans = list(self._firebaseService.db.collection('existing_loans')
                            .where('icNumber', '==', icNumber)
                            .where('status', '==', MLConstants.LOAN_STATUS_ACTIVE)
                            .stream())
        
        loanHistory = list(self._firebaseService.db.collection('loan_history')
                          .where('icNumber', '==', icNumber)
                          .stream())
        
        loanApplication = None
        if applicationId:
            loanApplication = self._firebaseService.db.collection('loan_applications').document(applicationId).get()
        
        personal = personalInfo.to_dict() if personalInfo.exists else {}
        employment = employmentInfo.to_dict() if employmentInfo.exists else {}
        userData = user.to_dict() if user.exists else {}
        ccris = ccrisProfile.to_dict() if ccrisProfile.exists else {}
        loanApp = loanApplication.to_dict() if loanApplication and loanApplication.exists else {}
        
        features = {}
        
        features['ApplicationDate'] = loanApp.get('applicationDate')
        features['Age'] = self._calculateAge(personal.get('dateOfBirth'))
        features['MonthlyIncome'] = employment.get('monthlyIncome', 0.0)
        features['AnnualIncome'] = self._calculateAnnualIncome(employment.get('monthlyIncome', 0.0))
        features['EmploymentStatus'] = self._mapEmploymentStatus(employment.get('employmentType', ''))
        features['EmploymentSector'] = employment.get('industry', '')
        features['EducationLevel'] = personal.get('educationLevel', MLConstants.DEFAULT_EDUCATION_LEVEL)
        features['WorkExperience'] = self._calculateWorkExperience(employment.get('employmentStartDate'))
        features['EPFMonthlyContribution'] = employment.get('epfMonthlyContribution', MLConstants.DEFAULT_EPF_CONTRIBUTION)
        features['EPFBalance'] = employment.get('epfBalance', MLConstants.DEFAULT_EPF_BALANCE)
        features['CreditScore'] = ccris.get('creditScore', 0)
        features['CCRISStatus'] = self._deriveCCRISStatus(
            ccris.get('numberOfDefaultPayments', 0),
            self._calculateTotalMissedPayments(loanHistory)
        )
        features['NumCreditFacilities'] = self._countCreditFacilities(existingLoans, creditCards)
        features['OutstandingFacilities'] = len(existingLoans)
        features['CreditCardLimit'] = self._sumCreditCardLimits(creditCards)
        features['CreditCardBalance'] = self._sumCreditCardBalances(creditCards)
        features['CreditUtilization'] = self._calculateCreditUtilization(creditCards)
        features['ExistingLoanCommitments'] = self._sumLoanCommitments(existingLoans)
        features['PaymentHistoryScore'] = self._calculatePaymentHistoryScore(
            loanHistory,
            ccris.get('numberOfDefaultPayments', 0)
        )
        features['CreditHistoryLength'] = self._calculateCreditHistoryLength(existingLoans, loanHistory)
        features['BankingRelationship'] = len(userData.get('connectedBanks', []))
        features['LoanType'] = loanApp.get('loanType', '')
        features['LoanAmount'] = loanApp.get('requestedAmount', 0.0)
        features['LoanDuration'] = loanApp.get('tenure', 0)
        features['MaritalStatus'] = personal.get('maritalStatus', '')
        features['NumDependents'] = personal.get('numberOfDependents', 0)
        features['HomeOwnership'] = personal.get('homeOwnership', MLConstants.DEFAULT_HOME_OWNERSHIP)
        features['SavingsBalance'] = self._getSavingsBalance(icNumber)
        features['OwnsProperty'] = personal.get('ownsProperty', False)
        features['GuarantorAvailable'] = loanApp.get('guarantorAvailable', False)
        
        # Estimate interest rate if not provided
        interestRate = loanApp.get('interestRate')
        if not interestRate:
            interestRate = self._estimateInterestRate(loanApp.get('loanType', ''), ccris.get('creditScore', 0))
        
        features['InterestRate'] = interestRate
        features['MonthlyLoanPayment'] = self._calculateMonthlyLoanPayment(
            loanApp.get('requestedAmount', 0.0),
            interestRate,
            loanApp.get('tenure', 0)
        )
        
        # Recalculate DSR with new loan
        monthlyIncome = employment.get('monthlyIncome', 0.0)
        existingCommitments = features['ExistingLoanCommitments']
        newLoanPayment = features['MonthlyLoanPayment'] or 0.0
        totalMonthlyDebt = existingCommitments + newLoanPayment
        
        features['DSR'] = (totalMonthlyDebt / monthlyIncome) if monthlyIncome > 0 else 999.0
        features['NetMonthlyIncome'] = monthlyIncome - totalMonthlyDebt
        features['LoanToIncomeRatio'] = self._calculateLoanToIncomeRatio(
            loanApp.get('requestedAmount', 0.0),
            monthlyIncome
        )
        features['CreditScoreCategory'] = self._categorizeCreditScore(ccris.get('creditScore', 0))
        features['LoanApproved'] = 1 if loanApp.get('status') == MLConstants.LOAN_STATUS_APPROVED else 0
        
        return features
    
    def _calculateAge(self, dateOfBirth) -> int:
        if not dateOfBirth:
            return 0
        
        if hasattr(dateOfBirth, 'tzinfo') and dateOfBirth.tzinfo is not None:
            today = datetime.now(timezone.utc)
        else:
            today = datetime.now()
        
        age = (today - dateOfBirth).days / MLConstants.DAYS_IN_YEAR
        return int(age)
    
    def _calculateAnnualIncome(self, monthlyIncome: float) -> float:
        return monthlyIncome * MLConstants.MONTHS_IN_YEAR
    
    def _mapEmploymentStatus(self, employmentType: str) -> str:
        return EmploymentTypeMapping.map(employmentType)
    
    def _calculateWorkExperience(self, employmentStartDate) -> float:
        if not employmentStartDate:
            return 0.0
        
        if hasattr(employmentStartDate, 'tzinfo') and employmentStartDate.tzinfo is not None:
            today = datetime.now(timezone.utc)
        else:
            today = datetime.now()
        
        years = (today - employmentStartDate).days / MLConstants.DAYS_IN_YEAR
        return round(years, 2)
    
    def _deriveCCRISStatus(self, numberOfDefaults: int, totalMissedPayments: int) -> str:
        if (numberOfDefaults <= MLConstants.CCRIS_EXCELLENT_MAX_DEFAULTS and 
            totalMissedPayments <= MLConstants.CCRIS_EXCELLENT_MAX_MISSED):
            return CCRISStatus.EXCELLENT.value
        elif (numberOfDefaults <= MLConstants.CCRIS_GOOD_MAX_DEFAULTS and 
              totalMissedPayments <= MLConstants.CCRIS_GOOD_MAX_MISSED):
            return CCRISStatus.GOOD.value
        elif (numberOfDefaults <= MLConstants.CCRIS_FAIR_MAX_DEFAULTS or 
              totalMissedPayments <= MLConstants.CCRIS_FAIR_MAX_MISSED):
            return CCRISStatus.FAIR.value
        else:
            return CCRISStatus.POOR.value
    
    def _calculateTotalMissedPayments(self, loanHistory: List) -> int:
        total = 0
        for loan in loanHistory:
            loanData = loan.to_dict()
            total += loanData.get('numberOfMissedPayments', 0)
        return total
    
    def _countCreditFacilities(self, loans: List, creditCards: List) -> int:
        return len(loans) + len(creditCards)
    
    def _sumCreditCardLimits(self, creditCards: List) -> float:
        total = 0.0
        for card in creditCards:
            cardData = card.to_dict()
            total += cardData.get('creditLimit', 0.0)
        return total
    
    def _sumCreditCardBalances(self, creditCards: List) -> float:
        total = 0.0
        for card in creditCards:
            cardData = card.to_dict()
            total += cardData.get('currentBalance', 0.0)
        return total
    
    def _calculateCreditUtilization(self, creditCards: List) -> float:
        totalLimit = self._sumCreditCardLimits(creditCards)
        totalBalance = self._sumCreditCardBalances(creditCards)
        
        if totalLimit == 0:
            return 0.0
        
        return round((totalBalance / totalLimit) * 100, 2)
    
    def _sumLoanCommitments(self, loans: List) -> float:
        total = 0.0
        for loan in loans:
            loanData = loan.to_dict()
            total += loanData.get('monthlyInstallment', 0.0)
        return total
    
    def _sumCreditCardMinimumPayments(self, creditCards: List) -> float:
        total = 0.0
        for card in creditCards:
            cardData = card.to_dict()
            total += cardData.get('minimumPayment', 0.0)
        return total
    
    def calculateTotalCommitments(self, icNumber: str) -> Dict[str, float]:
        """
        Calculate total monthly commitments including loans and credit cards
        Returns breakdown and total
        """
        creditCards = list(self._firebaseService.db.collection('credit_cards')
                          .where('icNumber', '==', icNumber)
                          .where('isActive', '==', True)
                          .stream())
        
        existingLoans = list(self._firebaseService.db.collection('existing_loans')
                            .where('icNumber', '==', icNumber)
                            .where('status', '==', MLConstants.LOAN_STATUS_ACTIVE)
                            .stream())
        
        loanCommitments = self._sumLoanCommitments(existingLoans)
        cardCommitments = self._sumCreditCardMinimumPayments(creditCards)
        totalCommitments = loanCommitments + cardCommitments
        
        return {
            'loanCommitments': loanCommitments,
            'creditCardCommitments': cardCommitments,
            'totalCommitments': totalCommitments
        }
    
    def _calculatePaymentHistoryScore(self, loanHistory: List, numberOfDefaults: int) -> int:
        totalMissedPayments = self._calculateTotalMissedPayments(loanHistory)
        
        score = (MLConstants.PAYMENT_HISTORY_BASE_SCORE - 
                (totalMissedPayments * MLConstants.PAYMENT_HISTORY_MISSED_PENALTY) - 
                (numberOfDefaults * MLConstants.PAYMENT_HISTORY_DEFAULT_PENALTY))
        
        return max(MLConstants.PAYMENT_HISTORY_MIN_SCORE, score)
    
    def _calculateCreditHistoryLength(self, existingLoans: List, loanHistory: List) -> float:
        allLoans = []
        
        for loan in existingLoans:
            loanData = loan.to_dict()
            if loanData.get('startDate'):
                allLoans.append(loanData['startDate'])
        
        for loan in loanHistory:
            loanData = loan.to_dict()
            if loanData.get('startDate'):
                allLoans.append(loanData['startDate'])
        
        if not allLoans:
            return 0.0
        
        oldestDate = min(allLoans)
        
        if hasattr(oldestDate, 'tzinfo') and oldestDate.tzinfo is not None:
            today = datetime.now(timezone.utc)
        else:
            today = datetime.now()
        
        years = (today - oldestDate).days / MLConstants.DAYS_IN_YEAR
        
        return round(years, 2)
    
    def _estimateInterestRate(self, loanType: str, creditScore: int) -> float:
        """Estimate interest rate based on loan type and credit score"""
        # Base rates by loan type (Malaysian market rates)
        base_rates = {
            'Housing': 4.5,
            'Islamic-Housing': 4.7,
            'Vehicle': 3.5,
            'Personal': 7.5,
            'Islamic-Personal': 7.8,
            'Education': 4.0,
        }
        
        base_rate = base_rates.get(loanType, 6.0)
        
        # Adjust based on credit score
        if creditScore >= 800:
            adjustment = -0.5
        elif creditScore >= 740:
            adjustment = 0.0
        elif creditScore >= 670:
            adjustment = 1.0
        elif creditScore >= 580:
            adjustment = 2.5
        else:
            adjustment = 4.0
        
        return round(base_rate + adjustment, 2)
    
    def _getSavingsBalance(self, icNumber: str) -> float:
        bankingAccounts = list(self._firebaseService.db.collection('banking_accounts')
                              .where('icNumber', '==', icNumber)
                              .stream())
        
        total = 0.0
        for account in bankingAccounts:
            accountData = account.to_dict()
            total += accountData.get('savingsAccountBalance', 0.0)
        
        return total
    
    def _calculateMonthlyLoanPayment(self, principal: float, annualRate: Optional[float], 
                                    tenureMonths: int) -> Optional[float]:
        if not annualRate or tenureMonths == 0 or principal == 0:
            return None
        
        monthlyRate = (annualRate / 100) / MLConstants.MONTHS_IN_YEAR
        
        if monthlyRate == 0:
            return principal / tenureMonths
        
        numerator = principal * monthlyRate * pow(1 + monthlyRate, tenureMonths)
        denominator = pow(1 + monthlyRate, tenureMonths) - 1
        
        return round(numerator / denominator, 2)
    
    def _calculateNetMonthlyIncome(self, monthlyIncome: float, totalMonthlyDebt: float) -> float:
        return monthlyIncome - totalMonthlyDebt
    
    def _calculateLoanToIncomeRatio(self, loanAmount: float, monthlyIncome: float) -> float:
        if monthlyIncome == 0:
            return 0.0
        
        annualIncome = monthlyIncome * MLConstants.MONTHS_IN_YEAR
        return round(loanAmount / annualIncome, 4)
    
    def _categorizeCreditScore(self, creditScore: int) -> str:
        if creditScore <= MLConstants.CREDIT_SCORE_POOR_MAX:
            return CreditScoreCategory.POOR.value
        elif creditScore <= MLConstants.CREDIT_SCORE_FAIR_MAX:
            return CreditScoreCategory.FAIR.value
        elif creditScore <= MLConstants.CREDIT_SCORE_GOOD_MAX:
            return CreditScoreCategory.GOOD.value
        elif creditScore <= MLConstants.CREDIT_SCORE_VERY_GOOD_MAX:
            return CreditScoreCategory.VERY_GOOD.value
        else:
            return CreditScoreCategory.EXCELLENT.value
