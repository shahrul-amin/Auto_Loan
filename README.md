# AutoLoan - Automated Loan Application System

[![Codacy Badge](https://api.codacy.com/project/badge/Grade/0f4b252383654bc58c6cb96707c3a9c9)](https://app.codacy.com/gh/shahrul-amin/Auto_Loan?utm_source=github.com&utm_medium=referral&utm_content=shahrul-amin/Auto_Loan&utm_campaign=Badge_Grade)

AutoLoan is an intelligent mobile application build with Flutter framework and Flask backend API that automates loan application processing. It uses Machine Learning models for credit scoring and loan approval prediction, with Explainable AI (XAI) providing counterfactual explanations for rejected applications.

## Features

- **Multi-Factor Authentication (MFA)** - Username, password, and OTP verification
- **Automated Loan Processing** - ML-powered loan approval prediction
- **Credit Score Management** - Monthly credit score calculation and tracking
- **Explainable AI** - Counterfactual explanations for rejected applications
- **Real-time Dashboard** - DSR, CCRIS status, active loans, and financial metrics
- **Officer Validation** - Human-in-the-loop decision making with secure token-based forms
- **Document Management** - Upload and manage loan documents (IC, payslips, bank statements)

## Technology Stack

### Frontend
- **Flutter** 3.0+
- **Dart** 2.17+

### Backend
- **Flask** 2.0+
- **Python** 3.9+
- **Firebase Admin SDK** - Backend Firebase integration
- **Firebase Auth** - Authentication
- **Firebase Firestore** - Database
- **Firebase Storage** - Document storage
- **scikit-learn** - Machine Learning models
- **DiCE** - Counterfactual explanations (XAI)
- **Twilio Verify API** - OTP service
- **MailerSend** - Email notifications

### ML Models
- **Gradient Boosting Regressor** - Credit score prediction
- **Gradient Boosting Classifier** - Loan approval prediction
- **DiCE (Diverse Counterfactual Explanations)** - Explainable AI


## Installation & Setup

### Prerequisites

- Python 3.9 or higher
- Flutter 3.0 or higher
- Firebase project (Firestore, Auth, Storage)
- Twilio account (for OTP)
- MailerSend account (for emails)

### Backend Setup

1. **Navigate to backend directory**
```powershell
cd backend
```

2. **Create and activate conda environment**
```powershell
conda create -n auto-loan python=3.9
conda activate auto-loan
```

3. **Install dependencies**
```powershell
pip install -r requirements.txt
```

4. **Set up Firebase credentials**
- Place `firebase-credentials.json` in the backend directory
- Configure Firebase project settings

5. **Train ML models (if not already trained)**
```powershell
cd ml_models
python train_credit_score.py
python train_loan_approval.py
```

6. **Run the Flask server**
```powershell
cd ..
python app.py
```

### Frontend Setup

1. **Navigate to frontend directory**
```powershell
cd frontend
```

2. **Install Flutter dependencies**
```powershell
flutter pub get
```

3. **Configure Firebase**
```powershell
# Follow Firebase setup instructions for Flutter
flutterfire configure
```

4. **Run the app**
```powershell
# For Android
flutter run

# For iOS
flutter run -d ios
```

## Use Cases

1. **User Authentication (UC-1)** - Multi-factor authentication with bank credentials
2. **Apply for Loan (UC-2)** - Submit loan application with ML-based prediction
3. **Validate Loan Application (UC-3)** - Officer review and decision
4. **View Credit Score (UC-4)** - Monthly credit score and credit card info
5. **View Dashboard Analytics (UC-5)** - Financial health dashboard
6. **Profile Management (UC-6)** - Logout and data consent
7. **Provide Counterfactual Explanations (UC-7)** - XAI for rejected applications

