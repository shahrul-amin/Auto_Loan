"""
Email service for sending officer notifications and managing email retry queue
"""
import logging
import requests
from datetime import datetime
from typing import Dict, Optional
from flask_mail import Mail, Message
from config import Config
from services.firebase_service import FirebaseService

logger = logging.getLogger(__name__)

class EmailService:
    def __init__(self, mail: Mail, firebaseService: FirebaseService):
        self._mail = mail
        self._firebaseService = firebaseService
        self._serializer = Config.get_serializer()
    
    def send_officer_notification(self, applicationData: Dict) -> bool:
        """
        Send loan application notification email to loan officer
        
        Args:
            applicationData: Dict containing:
                - applicationId: str
                - icNumber: str
                - loanType: str
                - requestedAmount: float
                - tenure: int
                - purposeOfLoan: str
                - officerEmail: str
                - officerName: str
                - mlApproved: bool
                - mlConfidence: float
                - uploadedDocuments: list (optional)
        
        Returns:
            bool: True if sent successfully, False otherwise
        """
        try:
            officerEmail = applicationData.get('officerEmail')
            officerName = applicationData.get('officerName', 'Loan Officer')
            
            if not officerEmail:
                logger.error("Officer email not provided")
                return False
            
            # Generate secure tokens for approval/rejection
            applicationId = applicationData['applicationId']
            token = self._generate_token(applicationId)
            
            # Construct approval URL (will be used in email template)
            baseUrl = 'http://localhost:5000'  # TODO: Make this configurable
            approvalFormUrl = f"{baseUrl}/api/loan-approval/form?token={token}"
            
            # Prepare email content
            subject = f"New Loan Application - {applicationId}"
            
            # Create HTML email body
            htmlBody = self._create_officer_email_html(
                officerName=officerName,
                applicationData=applicationData,
                approvalFormUrl=approvalFormUrl
            )
            
            # Create email message
            msg = Message(
                subject=subject,
                recipients=[officerEmail],
                html=htmlBody,
                sender=Config.MAIL_DEFAULT_SENDER
            )
            
            # Attach uploaded documents
            icNumber = applicationData['icNumber']
            self._attach_loan_documents(msg, icNumber, applicationId)
            
            # Send email
            self._mail.send(msg)
            
            logger.info(f"Officer notification sent successfully to {officerEmail} for application {applicationId}")
            return True
            
        except Exception as e:
            logger.error(f"Failed to send officer notification: {str(e)}", exc_info=True)
            
            # Queue for retry
            self._queue_failed_email(applicationData)
            
            return False
    
    def _generate_token(self, applicationId: str) -> str:
        """Generate secure token for application ID"""
        return self._serializer.dumps({'applicationId': applicationId}, salt='loan-approval')
    
    def _create_officer_email_html(self, officerName: str, applicationData: Dict, approvalFormUrl: str) -> str:
        """Create HTML email body for officer notification"""
        
        mlStatus = "APPROVED" if applicationData.get('mlApproved') else "REJECTED"
        mlConfidence = applicationData.get('mlConfidence', 0) * 100
        statusColor = "#10B981" if applicationData.get('mlApproved') else "#EF4444"
        
        html = f"""
        <!DOCTYPE html>
        <html>
        <head>
            <meta charset="UTF-8">
            <style>
                body {{
                    font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', Arial, sans-serif;
                    line-height: 1.6;
                    color: #1F2937;
                    background-color: #F3F4F6;
                    margin: 0;
                    padding: 0;
                }}
                .container {{
                    max-width: 600px;
                    margin: 20px auto;
                    background-color: #FFFFFF;
                    border-radius: 8px;
                    overflow: hidden;
                    box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
                }}
                .header {{
                    background: linear-gradient(135deg, #1976D2 0%, #0D47A1 100%);
                    color: #FFFFFF;
                    padding: 30px 20px;
                    text-align: center;
                }}
                .header h1 {{
                    margin: 0;
                    font-size: 24px;
                    font-weight: 600;
                }}
                .content {{
                    padding: 30px 20px;
                }}
                .greeting {{
                    font-size: 16px;
                    margin-bottom: 20px;
                }}
                .ml-status {{
                    background-color: #F9FAFB;
                    border-left: 4px solid {statusColor};
                    padding: 15px;
                    margin: 20px 0;
                    border-radius: 4px;
                }}
                .ml-status h3 {{
                    margin: 0 0 10px 0;
                    color: {statusColor};
                    font-size: 18px;
                }}
                .ml-status p {{
                    margin: 5px 0;
                    font-size: 14px;
                }}
                .details {{
                    background-color: #F9FAFB;
                    padding: 20px;
                    border-radius: 6px;
                    margin: 20px 0;
                }}
                .detail-row {{
                    display: flex;
                    justify-content: space-between;
                    padding: 10px 0;
                    border-bottom: 1px solid #E5E7EB;
                }}
                .detail-row:last-child {{
                    border-bottom: none;
                }}
                .detail-label {{
                    font-weight: 500;
                    color: #6B7280;
                }}
                .detail-value {{
                    font-weight: 600;
                    color: #1F2937;
                }}
                .action-button {{
                    display: inline-block;
                    background-color: #1976D2;
                    color: #FFFFFF;
                    text-decoration: none;
                    padding: 14px 32px;
                    border-radius: 6px;
                    font-weight: 600;
                    text-align: center;
                    margin: 20px 0;
                    font-size: 16px;
                }}
                .action-button:hover {{
                    background-color: #1565C0;
                }}
                .footer {{
                    background-color: #F9FAFB;
                    padding: 20px;
                    text-align: center;
                    font-size: 12px;
                    color: #6B7280;
                    border-top: 1px solid #E5E7EB;
                }}
            </style>
        </head>
        <body>
            <div class="container">
                <div class="header">
                    <h1>New Loan Application</h1>
                </div>
                
                <div class="content">
                    <div class="greeting">
                        <p>Dear {officerName},</p>
                        <p>A new loan application has been submitted and requires your review.</p>
                    </div>
                    
                    <div class="ml-status">
                        <h3>ML Prediction: {mlStatus}</h3>
                        <p><strong>Confidence:</strong> {mlConfidence:.1f}%</p>
                    </div>
                    
                    <div class="details">
                        <div class="detail-row">
                            <span class="detail-label">Application ID:</span>
                            <span class="detail-value">{applicationData['applicationId']}</span>
                        </div>
                        <div class="detail-row">
                            <span class="detail-label">Applicant IC:</span>
                            <span class="detail-value">{applicationData['icNumber']}</span>
                        </div>
                        <div class="detail-row">
                            <span class="detail-label">Loan Type:</span>
                            <span class="detail-value">{applicationData['loanType']}</span>
                        </div>
                        <div class="detail-row">
                            <span class="detail-label">Requested Amount:</span>
                            <span class="detail-value">RM {applicationData['requestedAmount']:,.2f}</span>
                        </div>
                        <div class="detail-row">
                            <span class="detail-label">Tenure:</span>
                            <span class="detail-value">{applicationData['tenure']} months</span>
                        </div>
                        <div class="detail-row">
                            <span class="detail-label">Purpose:</span>
                            <span class="detail-value">{applicationData.get('purposeOfLoan', 'N/A')}</span>
                        </div>
                    </div>
                    
                    {self._create_documents_section(applicationData.get('uploadedDocuments', []))}
                    
                    <div style="text-align: center;">
                        <a href="{approvalFormUrl}" class="action-button">Review Application</a>
                    </div>
                    
                    <p style="font-size: 14px; color: #6B7280; margin-top: 20px;">
                        Please review this application within 7 days. If no action is taken, the application will be automatically rejected.
                    </p>
                </div>
                
                <div class="footer">
                    <p>Auto Loan Management System</p>
                    <p>This is an automated email. Please do not reply.</p>
                </div>
            </div>
        </body>
        </html>
        """
        
        return html
    
    def _create_documents_section(self, documents: list) -> str:
        """Create HTML section for uploaded documents"""
        if not documents or len(documents) == 0:
            return ""
        
        doc_items = ""
        for doc_name in documents:
            formatted_name = doc_name.replace('_', ' ').title()
            doc_items += f"""
                        <div class="document-item">
                            <span>✓ {formatted_name}</span>
                        </div>
            """
        
        return f"""
                    <div class="documents-section">
                        <h3 style="color: #1F2937; font-size: 16px; margin-bottom: 15px;">Uploaded Documents</h3>
                        <div class="documents-list">
                            {doc_items}
                        </div>
                    </div>
                    
                    <style>
                        .documents-section {{
                            background-color: #F0F9FF;
                            border: 1px solid #BFDBFE;
                            border-radius: 6px;
                            padding: 20px;
                            margin: 20px 0;
                        }}
                        .documents-list {{
                            display: flex;
                            flex-direction: column;
                            gap: 8px;
                        }}
                        .document-item {{
                            background-color: #FFFFFF;
                            padding: 10px 15px;
                            border-radius: 4px;
                            font-size: 14px;
                            color: #1976D2;
                            border-left: 3px solid #1976D2;
                        }}
                    </style>
        """
    
    def _attach_loan_documents(self, msg: Message, icNumber: str, applicationId: str) -> None:
        """Fetch and attach loan documents from Firebase Storage to email"""
        try:
            if not self._firebaseService.storage_bucket:
                logger.warning("Storage bucket not initialized, skipping document attachments")
                return
            
            storage_path = f'users/{icNumber}/loan_applications/{applicationId}'
            bucket = self._firebaseService.storage_bucket
            blobs = bucket.list_blobs(prefix=storage_path)
            
            attached_count = 0
            for blob in blobs:
                if blob.name == storage_path or blob.name.endswith('/'):
                    continue
                
                try:
                    file_bytes = blob.download_as_bytes()
                    filename = blob.name.split('/')[-1]
                    
                    content_type = blob.content_type or 'application/octet-stream'
                    
                    msg.attach(
                        filename=filename,
                        content_type=content_type,
                        data=file_bytes
                    )
                    
                    attached_count += 1
                    logger.info(f"Attached document: {filename}")
                    
                except Exception as e:
                    logger.warning(f"Failed to attach document {blob.name}: {str(e)}")
            
            if attached_count == 0:
                logger.warning(f"No documents found at path: {storage_path}")
                    
        except Exception as e:
            logger.error(f"Failed to fetch loan documents from Storage: {str(e)}")
    
    def _queue_failed_email(self, emailData: Dict) -> None:
        """Queue failed email for retry"""
        try:
            queueData = {
                'emailData': emailData,
                'retryCount': 0,
                'maxRetries': 3,
                'createdAt': datetime.now(),
                'lastAttempt': datetime.now(),
                'status': 'pending'
            }
            
            self._firebaseService.db.collection('email_queue').add(queueData)
            logger.info(f"Email queued for retry: {emailData.get('applicationId')}")
            
        except Exception as e:
            logger.error(f"Failed to queue email for retry: {str(e)}")
    
    def retry_failed_emails(self) -> int:
        """
        Retry sending failed emails from the queue
        
        Returns:
            int: Number of emails successfully sent
        """
        successCount = 0
        
        try:
            # Get pending emails from queue
            query = self._firebaseService.db.collection('email_queue')\
                .where('status', '==', 'pending')\
                .where('retryCount', '<', 3)\
                .limit(10)\
                .stream()
            
            for doc in query:
                queueItem = doc.to_dict()
                emailData = queueItem.get('emailData')
                retryCount = queueItem.get('retryCount', 0)
                
                # Attempt to send
                if self.send_officer_notification(emailData):
                    # Mark as sent
                    self._firebaseService.db.collection('email_queue').document(doc.id).update({
                        'status': 'sent',
                        'sentAt': datetime.now()
                    })
                    successCount += 1
                else:
                    # Increment retry count
                    newRetryCount = retryCount + 1
                    updateData = {
                        'retryCount': newRetryCount,
                        'lastAttempt': datetime.now()
                    }
                    
                    # Mark as failed if max retries reached
                    if newRetryCount >= 3:
                        updateData['status'] = 'failed'
                    
                    self._firebaseService.db.collection('email_queue').document(doc.id).update(updateData)
            
            if successCount > 0:
                logger.info(f"Successfully sent {successCount} queued emails")
            
        except Exception as e:
            logger.error(f"Error retrying failed emails: {str(e)}", exc_info=True)
        
        return successCount
