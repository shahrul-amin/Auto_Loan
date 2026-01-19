import os
import sys
import pickle
import logging
import numpy as np
import pandas as pd
from typing import Optional, Dict
from datetime import datetime
from services.firebase_service import FirebaseService
from services.ml.ml_feature_service import MLFeatureService

logger = logging.getLogger(__name__)

baseDir = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
sys.path.insert(0, baseDir)

class RestrictedUnpickler(pickle.Unpickler):
    def find_class(self, module, name):
        if module == 'utils.preprocessing':
            from ml_models.utils.preprocessing import CreditScorePreprocessor
            return CreditScorePreprocessor
        return super().find_class(module, name)

_model = None
_preprocessor = None

class CreditScorePredictionService:
    _DROPPED_COLUMNS = [
        'ApplicationDate', 'CreditScoreCategory', 'CreditScore', 'CCRISStatus',
        'LoanType', 'LoanAmount', 'LoanDuration', 'InterestRate', 
        'MonthlyLoanPayment', 'GuarantorAvailable', 'DSR', 'NetMonthlyIncome',
        'LoanToIncomeRatio', 'LoanApproved'
    ]
    _MIN_SCORE = 300
    _MAX_SCORE = 850
    
    def __init__(self, firebaseService: FirebaseService):
        global _model, _preprocessor
        
        self._firebaseService = firebaseService
        self._mlFeatureService = MLFeatureService(firebaseService)
        
        if _model is None or _preprocessor is None:
            modelDir = os.path.join(baseDir, 'ml_models', 'credit_score', 'v1.0.0')
            modelPath = os.path.join(modelDir, 'model.pkl')
            preprocessorPath = os.path.join(modelDir, 'preprocessor.pkl')
            
            with open(modelPath, 'rb') as f:
                _model = pickle.load(f)
            
            with open(preprocessorPath, 'rb') as f:
                _preprocessor = RestrictedUnpickler(f).load()
            
            logger.info(f"Model loaded from {modelPath}")
            logger.info(f"Preprocessor loaded from {preprocessorPath}")
        
        self._model = _model
        self._preprocessor = _preprocessor
    
    def predict(self, icNumber: str) -> Optional[Dict]:
        try:
            features = self._mlFeatureService.getAllFeatures(icNumber)
            
            if not features:
                logger.error(f"Failed to fetch features for {icNumber}")
                return None
            
            featuresDataFrame = self._prepareFeatures(features)
            processedFeatures = self._preprocessor.transform(featuresDataFrame)
            
            rawScore = self._model.predict(processedFeatures)[0]
            score = int(np.clip(rawScore, self._MIN_SCORE, self._MAX_SCORE))
            category = self._categorizeScore(score)
            
            result = {
                'icNumber': icNumber,
                'predictedScore': score,
                'predictedCategory': category,
                'predictedAt': datetime.now()
            }
            
            logger.info(f"Prediction successful for {icNumber}: {score} ({category})")
            return result
            
        except Exception as e:
            logger.error(f"Prediction failed for {icNumber}: {str(e)}", exc_info=True)
            return None
    
    def _prepareFeatures(self, features: Dict) -> pd.DataFrame:
        featureDict = {k: v for k, v in features.items() if k not in self._DROPPED_COLUMNS}
        return pd.DataFrame([featureDict])
    
    def _categorizeScore(self, score: int) -> str:
        if score >= 800:
            return 'Excellent'
        elif score >= 740:
            return 'Very Good'
        elif score >= 670:
            return 'Good'
        elif score >= 580:
            return 'Fair'
        else:
            return 'Poor'
