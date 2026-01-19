"""
Loan Approval Prediction Service using trained sklearn model and DiCE explainer
"""
import os
import sys
import pickle
import logging
import numpy as np
import pandas as pd
from typing import Optional, Dict, List
from datetime import datetime
from services.firebase_service import FirebaseService
from services.ml.ml_feature_service import MLFeatureService

logger = logging.getLogger(__name__)

baseDir = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
sys.path.insert(0, baseDir)

class RestrictedUnpickler(pickle.Unpickler):
    def find_class(self, module, name):
        if module == 'utils.preprocessing':
            from ml_models.utils.preprocessing import LoanApprovalPreprocessor
            return LoanApprovalPreprocessor
        elif module == 'utils.dice_config':
            from ml_models.utils import dice_config
            return getattr(dice_config, name)
        return super().find_class(module, name)

_model = None
_preprocessor = None
_dice_explainer = None

class LoanApprovalPredictionService:
    _MIN_CONFIDENCE = 0.0
    _MAX_CONFIDENCE = 1.0
    
    def __init__(self, firebaseService: FirebaseService):
        global _model, _preprocessor, _dice_explainer
        
        self._firebaseService = firebaseService
        self._mlFeatureService = MLFeatureService(firebaseService)
        
        if _model is None or _preprocessor is None:
            modelDir = os.path.join(baseDir, 'ml_models', 'loan_approval', 'v1.0.0')
            modelPath = os.path.join(modelDir, 'model.pkl')
            preprocessorPath = os.path.join(modelDir, 'preprocessor.pkl')
            dicePath = os.path.join(modelDir, 'dice_explainer.pkl')
            
            with open(modelPath, 'rb') as f:
                _model = pickle.load(f)
            
            with open(preprocessorPath, 'rb') as f:
                _preprocessor = RestrictedUnpickler(f).load()
            
            # Load DiCE explainer if available
            if os.path.exists(dicePath):
                try:
                    with open(dicePath, 'rb') as f:
                        _dice_explainer = RestrictedUnpickler(f).load()
                    logger.info(f"DiCE explainer loaded from {dicePath}")
                except Exception as e:
                    logger.warning(f"Could not load DiCE explainer: {e}")
                    _dice_explainer = None
            else:
                _dice_explainer = None
            
            logger.info(f"sklearn model loaded from {modelPath}")
            logger.info(f"Preprocessor loaded from {preprocessorPath}")
        
        self._model = _model
        self._preprocessor = _preprocessor
        self._dice_explainer = _dice_explainer
    
    def predict_loan_approval(self, icNumber: str, loanData: Dict) -> Optional[Dict]:
        """
        Predict loan approval for a user
        
        Args:
            icNumber: User's IC number
            loanData: Dict containing loan-specific fields:
                - loanType: str
                - requestedAmount: float
                - tenure: int (months)
                - guarantorAvailable: bool
        
        Returns:
            Dict with:
                - approved: bool
                - confidence: float
                - predictedAt: datetime
        """
        try:
            # Get all ML features for the user
            features = self._mlFeatureService.getAllFeatures(icNumber)
            
            if not features:
                logger.error(f"Failed to fetch features for {icNumber}")
                return None
            
            # Add loan-specific data to features
            features['LoanType'] = loanData.get('loanType', 'Personal')
            features['LoanAmount'] = float(loanData.get('requestedAmount', 0))
            
            # Convert tenure from years to months
            tenureYears = int(loanData.get('tenure', 1))
            features['LoanDuration'] = tenureYears * 12
            
            features['GuarantorAvailable'] = 1 if loanData.get('guarantorAvailable', False) else 0
            
            # Calculate derived fields
            # Assuming standard interest rate for prediction (officer will set actual rate)
            assumedInterestRate = self._getAssumedInterestRate(features['LoanType'])
            features['InterestRate'] = assumedInterestRate
            
            # Monthly payment calculation: P * r * (1 + r)^n / ((1 + r)^n - 1)
            principal = features['LoanAmount']
            monthlyRate = assumedInterestRate / 12
            numPayments = features['LoanDuration']
            
            if monthlyRate > 0:
                monthlyPayment = principal * monthlyRate * (1 + monthlyRate) ** numPayments / \
                                ((1 + monthlyRate) ** numPayments - 1)
            else:
                monthlyPayment = principal / numPayments
            
            features['MonthlyLoanPayment'] = monthlyPayment
            
            # Calculate additional ratios
            monthlyIncome = features.get('MonthlyIncome', 0)
            existingCommitments = features.get('ExistingLoanCommitments', 0)
            
            features['DSR'] = (existingCommitments + monthlyPayment) / monthlyIncome if monthlyIncome > 0 else 999
            features['NetMonthlyIncome'] = monthlyIncome - existingCommitments - monthlyPayment
            features['LoanToIncomeRatio'] = features['LoanAmount'] / features.get('AnnualIncome', 1)
            
            # Prepare DataFrame
            featuresDataFrame = pd.DataFrame([features])
            
            # Auto-reject based on hard business rules and data range validation
            dsr = features.get('DSR', 0)
            netIncome = features.get('NetMonthlyIncome', 0)
            loanToIncomeRatio = features.get('LoanToIncomeRatio', 0)
            monthlyIncome = features.get('MonthlyIncome', 0)
            loanAmount = features.get('LoanAmount', 0)
            
            # Check each auto-reject condition and build explanation
            autoRejectReasons = []
            
            if dsr > 0.7:
                autoRejectReasons.append(f"Your Debt Service Ratio ({dsr:.1%}) exceeds the maximum allowed (70%)")
            if netIncome < 1000:
                autoRejectReasons.append(f"Net monthly income after loan payment (RM {netIncome:,.0f}) is below minimum requirement (RM 1,000)")
            if loanToIncomeRatio > 10:
                autoRejectReasons.append(f"Loan amount is {loanToIncomeRatio:.1f}x your annual income (maximum allowed: 10x)")
            if dsr > 2.0:
                autoRejectReasons.append(f"Your total debt payments ({dsr:.0%}) are extremely high")
            if monthlyIncome < 1800:
                autoRejectReasons.append(f"Monthly income (RM {monthlyIncome:,.0f}) is below minimum requirement (RM 1,800)")
            if loanAmount < 5000:
                autoRejectReasons.append(f"Loan amount (RM {loanAmount:,.0f}) is below minimum (RM 5,000)")
            elif loanAmount > 800000:
                autoRejectReasons.append(f"Loan amount (RM {loanAmount:,.0f}) exceeds maximum limit (RM 800,000)")
            
            if autoRejectReasons:
                logger.info(f"Auto-rejected loan for {icNumber}: {', '.join(autoRejectReasons)}")
                
                # Build clear explanation for auto-rejection
                explanation = "Your loan application was automatically declined due to the following reason(s):\n\n"
                for i, reason in enumerate(autoRejectReasons, 1):
                    explanation += f"{i}. {reason}\n"
                
                explanation += "\nRecommendations:\n"
                if loanAmount > 800000:
                    explanation += f"• Reduce your loan amount to RM 800,000 or below\n"
                if dsr > 0.7 or netIncome < 1000:
                    explanation += f"• Consider requesting a smaller loan amount to reduce monthly payments\n"
                    explanation += f"• Pay down existing debts to improve your debt-to-income ratio\n"
                if loanToIncomeRatio > 10:
                    explanation += f"• Request a loan amount that is 10x or less than your annual income\n"
                if monthlyIncome < 1800:
                    explanation += f"• Our minimum income requirement is RM 1,800 per month\n"
                
                explanation += "\nPlease contact our loan officer for personalized assistance."
                
                return {
                    'approved': False,
                    'confidence': 0.0,
                    'predictedAt': datetime.now(),
                    'rejectionReason': explanation
                }
            
            # Drop features not used in loan approval model (credit scoring features)
            columns_to_drop = [
                'CCRISStatus', 'NumCreditFacilities', 'OutstandingFacilities',
                'CreditCardLimit', 'CreditCardBalance', 'CreditUtilization',
                'PaymentHistoryScore', 'CreditHistoryLength'
            ]
            featuresDataFrame = featuresDataFrame.drop(
                columns=[col for col in columns_to_drop if col in featuresDataFrame.columns]
            )
            
            # Preprocess
            processedFeatures = self._preprocessor.transform(featuresDataFrame)
            
            # sklearn model was trained with DataFrame, keep as DataFrame for consistency
            # Ensure column order matches training data
            X_df = processedFeatures[self._preprocessor.feature_names]
            
            # Predict (sklearn model returns class probabilities)
            predictionProba = self._model.predict_proba(X_df)[0][1]
            prediction = self._model.predict(X_df)[0]
            
            approved = bool(prediction == 1)
            confidence = float(predictionProba)
            
            result = {
                'approved': approved,
                'confidence': confidence,
                'predictedAt': datetime.now()
            }
            
            logger.info(f"Loan approval prediction for {icNumber}: {'APPROVED' if approved else 'REJECTED'} (confidence: {confidence:.2%})")
            return result
            
        except Exception as e:
            logger.error(f"Loan approval prediction failed for {icNumber}: {str(e)}", exc_info=True)
            return None
    
    def generate_rejection_explanation(self, icNumber: str, loanData: Dict) -> Optional[str]:
        """
        Generate human-readable explanation for loan rejection using DiCE
        
        Args:
            icNumber: User's IC number
            loanData: Same dict as predict_loan_approval
        
        Returns:
            Human-readable string explaining why loan was rejected and what to improve
        """
        try:
            # Get features same as prediction
            features = self._mlFeatureService.getAllFeatures(icNumber)
            
            if not features:
                logger.error(f"Failed to fetch features for {icNumber}")
                return None
            
            # Add loan-specific data
            features['LoanType'] = loanData.get('loanType', 'Personal')
            features['LoanAmount'] = float(loanData.get('requestedAmount', 0))
            
            # Convert tenure from years to months
            tenureYears = int(loanData.get('tenure', 1))
            features['LoanDuration'] = tenureYears * 12
            
            features['GuarantorAvailable'] = 1 if loanData.get('guarantorAvailable', False) else 0
            
            # Calculate derived fields (same as prediction)
            assumedInterestRate = self._getAssumedInterestRate(features['LoanType'])
            features['InterestRate'] = assumedInterestRate
            
            principal = features['LoanAmount']
            monthlyRate = assumedInterestRate / 12
            numPayments = features['LoanDuration']
            
            if monthlyRate > 0:
                monthlyPayment = principal * monthlyRate * (1 + monthlyRate) ** numPayments / \
                                ((1 + monthlyRate) ** numPayments - 1)
            else:
                monthlyPayment = principal / numPayments
            
            features['MonthlyLoanPayment'] = monthlyPayment
            
            monthlyIncome = features.get('MonthlyIncome', 0)
            existingCommitments = features.get('ExistingLoanCommitments', 0)
            
            features['DSR'] = (existingCommitments + monthlyPayment) / monthlyIncome if monthlyIncome > 0 else 999
            features['NetMonthlyIncome'] = monthlyIncome - existingCommitments - monthlyPayment
            features['LoanToIncomeRatio'] = features['LoanAmount'] / features.get('AnnualIncome', 1)
            
            queryInstance = pd.DataFrame([features])
            
            columns_to_drop = [
                'ApplicationDate', 'CreditScoreCategory', 'LoanApproved',
                'CCRISStatus', 'NumCreditFacilities', 'OutstandingFacilities',
                'CreditCardLimit', 'CreditCardBalance', 'CreditUtilization',
                'PaymentHistoryScore', 'CreditHistoryLength'
            ]
            queryInstance = queryInstance.drop(
                columns=[col for col in columns_to_drop if col in queryInstance.columns]
            )
            
            if queryInstance.isnull().any().any():
                logger.warning(f"Query instance has NaN values: {queryInstance.isnull().sum().to_dict()}")
                queryInstance = queryInstance.fillna(0)
            
            processedQuery = self._preprocessor.transform(queryInstance)
            
            # Reset index to match DiCE training data format
            processedQuery = processedQuery.reset_index(drop=True)
            
            actionableFeatures = [
                'DSR',
                'LoanAmount',  
                'CreditScore', 
                'SavingsBalance',  
                'EPFBalance',  
                'ExistingLoanCommitments',
                'MonthlyIncome',  
                'GuarantorAvailable',  
            ]
            featuresToVary = [f for f in actionableFeatures if f in processedQuery.columns]
            
            # Generate counterfactuals with genetic method (sklearn backend)
            cfExamples = self._dice_explainer.generate_counterfactuals(
                processedQuery,
                total_CFs=3,
                desired_class=1,
                features_to_vary=featuresToVary
            )
            
            if cfExamples is None:
                return "Unable to generate specific recommendations. Please contact our loan officer for personalized advice."
            
            # Format to human-readable text (inverse-transform scaled values)
            explanationText = self._format_counterfactual_text(queryInstance, cfExamples, processedQuery)
            
            logger.info(f"Generated rejection explanation for {icNumber}")
            return explanationText
            
        except Exception as e:
            logger.error(f"Failed to generate rejection explanation for {icNumber}: {str(e)}", exc_info=True)
            return "Unable to generate specific recommendations due to technical issues. Please contact our loan officer."
    
    def _format_counterfactual_text(self, originalInstance: pd.DataFrame, cfExamples, processedQuery: pd.DataFrame) -> str:
        try:
            cfDf = cfExamples.cf_examples_list[0].final_cfs_df
            
            if cfDf.empty:
                return "Unable to generate specific recommendations. Please contact our loan officer."
            
            cfRow = cfDf.iloc[0]
            origProcessed = processedQuery.iloc[0]
            origRaw = originalInstance.iloc[0]
            
            text = "To improve your chances of loan approval, consider the following changes:\n\n"
            
            changeCount = 0
            priorityFeatures = [
                'DSR', 'LoanAmount', 'CreditScore', 'MonthlyIncome', 'ExistingLoanCommitments', 
                'SavingsBalance', 'EPFBalance', 'GuarantorAvailable'
            ]
            
            for feature in priorityFeatures:
                if feature not in cfRow.index or feature not in origProcessed.index:
                    continue
                
                origVal = origProcessed[feature]
                cfVal = cfRow[feature]
                
                if isinstance(origVal, (int, float)) and isinstance(cfVal, (int, float)):
                    if abs(cfVal - origVal) < 0.01:
                        continue
                elif origVal == cfVal:
                    continue
                
                changeCount += 1
                featureName = feature.replace('_', ' ')
                
                if feature == 'DSR':
                    if cfVal > origVal:
                        changeCount -= 1
                        continue
                    current_dsr = origVal
                    target_dsr = max(cfVal, 0.55)
                    if target_dsr >= current_dsr:
                        changeCount -= 1
                        continue
                    
                    monthly_income = origRaw.get('MonthlyIncome', 0)
                    existing_commitments = origRaw.get('ExistingLoanCommitments', 0)
                    current_loan_payment = origRaw.get('MonthlyLoanPayment', 0)
                    current_loan_amount = origRaw.get('LoanAmount', 0)
                    
                    total_monthly_debt = existing_commitments + current_loan_payment
                    target_income = total_monthly_debt / target_dsr if target_dsr > 0 else 0
                    
                    target_total_payment = target_dsr * monthly_income
                    target_loan_payment = target_total_payment - existing_commitments
                    
                    text += f"{changeCount}. Debt Service Ratio:\n"
                    text += f"   Current: {current_dsr:.1%}\n"
                    text += f"   Recommended: {target_dsr:.1%}\n"
                    
                    if target_loan_payment > 0 and current_loan_payment > 0:
                        reduction_ratio = target_loan_payment / current_loan_payment
                        suggested_loan_amount = current_loan_amount * reduction_ratio
                        text += f"   Option A: Reduce loan to RM {suggested_loan_amount:,.0f}\n"
                        text += f"   Option B: Increase income to RM {target_income:,.0f}\n\n"
                    else:
                        text += f"   Action: Increase income to RM {target_income:,.0f} or reduce existing debts\n\n"
                
                elif feature in ['MonthlyIncome', 'LoanAmount', 'SavingsBalance', 'ExistingLoanCommitments']:
                    if feature in ['MonthlyIncome', 'SavingsBalance'] and cfVal < origVal:
                        changeCount -= 1
                        continue
                    if feature in ['ExistingLoanCommitments', 'LoanAmount'] and cfVal > origVal:
                        changeCount -= 1
                        continue
                    
                    text += f"{changeCount}. {featureName}:\n"
                    text += f"   Current: RM {origVal:,.0f}\n"
                    text += f"   Recommended: RM {cfVal:,.0f}\n"
                    diff = cfVal - origVal
                    text += f"   Change needed: RM {abs(diff):,.0f} "
                    text += f"({'increase' if diff > 0 else 'decrease'})\n\n"
                
                elif feature == 'CreditScore':
                    if cfVal < origVal:
                        changeCount -= 1
                        continue
                    
                    text += f"{changeCount}. Credit Score:\n"
                    text += f"   Current: {origVal:.0f}\n"
                    text += f"   Recommended: {cfVal:.0f}\n"
                    text += f"   Improve by {(cfVal - origVal):.0f} points through timely payments\n\n"
                
                elif feature == 'GuarantorAvailable':
                    if cfVal == 1 and origVal == 0:
                        text += f"{changeCount}. Guarantor:\n"
                        text += f"   Adding a guarantor may significantly improve approval chances\n\n"
                    else:
                        changeCount -= 1
                
                else:
                    text += f"{changeCount}. {featureName}:\n"
                    text += f"   Current: {origVal}\n"
                    text += f"   Recommended: {cfVal}\n\n"
                
                if changeCount >= 5:
                    break
            
            if changeCount == 0:
                text = "Your application is borderline. Please contact our loan officer for personalized advice on improving your application.\n"
            
            text += "\nNote: These are suggestions based on statistical analysis. Actual approval depends on comprehensive assessment by our loan officers."
            
            return text
            
        except Exception as e:
            logger.error(f"Error formatting counterfactual text: {str(e)}", exc_info=True)
            return "Unable to generate specific recommendations. Please contact our loan officer."
    
    def _getAssumedInterestRate(self, loanType: str) -> float:
        """Get nterest rate for loan type (for prediction purposes only)"""
        rateMap = {
            'Housing': 0.0375,
            'IslamicHousing': 0.0395,
            'Vehicle': 0.0285,
            'Personal': 0.0775,
            'IslamicPersonal': 0.0795
        }
        return rateMap.get(loanType, 0.065)
