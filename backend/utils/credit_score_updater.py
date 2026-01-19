import logging
from datetime import datetime
from typing import Dict
from services.firebase_service import FirebaseService

logger = logging.getLogger(__name__)

class CreditScoreUpdater:
    _MAX_HISTORY_SIZE = 12
    
    @staticmethod
    def updateCreditScore(
        firebaseService: FirebaseService,
        icNumber: str,
        predictedScore: int,
        predictedCategory: str
    ) -> bool:
        try:
            docRef = firebaseService.db.collection('credit_score').document(icNumber)
            existingDoc = docRef.get()
            
            currentTimestamp = datetime.now()
            
            if existingDoc.exists:
                return CreditScoreUpdater._updateExistingScore(
                    docRef,
                    existingDoc,
                    predictedScore,
                    predictedCategory,
                    currentTimestamp
                )
            else:
                return CreditScoreUpdater._createNewScore(
                    docRef,
                    icNumber,
                    predictedScore,
                    predictedCategory,
                    currentTimestamp
                )
                
        except Exception as e:
            logger.error(f"Failed to update credit score for {icNumber}: {str(e)}", exc_info=True)
            return False
    
    @staticmethod
    def _updateExistingScore(
        docRef,
        existingDoc,
        predictedScore: int,
        predictedCategory: str,
        currentTimestamp: datetime
    ) -> bool:
        try:
            currentData = existingDoc.to_dict()
            history = currentData.get('history', [])
            
            monthString = f"{currentTimestamp.year}-{currentTimestamp.month:02d}"
            
            newEntry = {
                'creditScore': predictedScore,
                'category': predictedCategory,
                'month': monthString,
                'predictedAt': currentTimestamp
            }
            
            existingMonthIndex = -1
            for i, entry in enumerate(history):
                if entry.get('month') == monthString:
                    existingMonthIndex = i
                    break
            
            if existingMonthIndex >= 0:
                history[existingMonthIndex] = newEntry
                logger.info(f"Updated existing {monthString} entry in history")
            else:
                history.append(newEntry)
                logger.info(f"Added new {monthString} entry to history")
            
            history.sort(key=lambda x: x.get('month', ''))
            
            if len(history) > CreditScoreUpdater._MAX_HISTORY_SIZE:
                history = history[-CreditScoreUpdater._MAX_HISTORY_SIZE:]
            
            docRef.update({
                'currentCreditScore': predictedScore,
                'currentCategory': predictedCategory,
                'lastUpdated': currentTimestamp,
                'history': history
            })
            
            logger.info(f"Updated credit score for {existingDoc.id}: {predictedScore} ({predictedCategory})")
            return True
            
        except Exception as e:
            logger.error(f"Failed to update existing score: {str(e)}", exc_info=True)
            return False
    
    @staticmethod
    def _createNewScore(
        docRef,
        icNumber: str,
        predictedScore: int,
        predictedCategory: str,
        currentTimestamp: datetime
    ) -> bool:
        try:
            monthString = f"{currentTimestamp.year}-{currentTimestamp.month:02d}"
            
            docRef.set({
                'icNumber': icNumber,
                'currentCreditScore': predictedScore,
                'currentCategory': predictedCategory,
                'lastUpdated': currentTimestamp,
                'history': [{
                    'creditScore': predictedScore,
                    'category': predictedCategory,
                    'month': monthString,
                    'predictedAt': currentTimestamp
                }]
            })
            
            logger.info(f"Created new credit score for {icNumber}: {predictedScore} ({predictedCategory})")
            return True
            
        except Exception as e:
            logger.error(f"Failed to create new score: {str(e)}", exc_info=True)
            return False