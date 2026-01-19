# AutoLoan - Automated Loan Application System

**Final Year Project (FYP) - Semester 7**

AutoLoan is an intelligent mobile application with Flask backend API that automates loan application processing using Machine Learning models for credit scoring and loan approval prediction, with Explainable AI (XAI) providing counterfactual explanations for rejected applications.

## 🚀 Features

- **Multi-Factor Authentication (MFA)** - Username, password, and OTP verification
- **Automated Loan Processing** - ML-powered loan approval prediction
- **Credit Score Management** - Monthly credit score calculation and tracking
- **Explainable AI** - Counterfactual explanations for rejected applications
- **Real-time Dashboard** - DSR, CCRIS status, active loans, and financial metrics
- **Officer Validation** - Human-in-the-loop decision making with secure token-based forms
- **Document Management** - Upload and manage loan documents (IC, payslips, bank statements)

## 📋 Technology Stack

### Frontend
- **Flutter** 3.0+ - Cross-platform mobile development
- **Dart** 2.17+ - Programming language
- **Firebase Auth** - Authentication
- **Firebase Firestore** - Database
- **Firebase Storage** - Document storage

### Backend
- **Python** 3.9+ - Backend programming language
- **Flask** 2.0+ - Web framework
- **Firebase Admin SDK** - Backend Firebase integration
- **scikit-learn** - Machine Learning models
- **DiCE** - Counterfactual explanations (XAI)
- **Twilio Verify API** - OTP service
- **MailerSend** - Email notifications

### ML Models
- **Gradient Boosting Regressor** - Credit score prediction
- **Gradient Boosting Classifier** - Loan approval prediction
- **DiCE (Diverse Counterfactual Explanations)** - Explainable AI

## 📁 Project Structure

```
auto_loan/
├── backend/                    # Flask backend API
│   ├── routes/                # API route handlers
│   ├── services/              # Business logic services
│   ├── ml_models/             # Machine Learning models
│   ├── models/                # Data models
│   ├── utils/                 # Utility functions
│   ├── tests/                 # Unit tests
│   ├── app.py                 # Main Flask application
│   └── config.py              # Configuration
├── frontend/                   # Flutter mobile app
│   ├── lib/                   # Dart source code
│   ├── test/                  # Flutter tests
│   ├── assets/                # Images, fonts, etc.
│   └── pubspec.yaml           # Flutter dependencies
├── TEST_DESIGN_SPECIFICATION.md  # Comprehensive testing documentation
└── README.md                  # This file
```

## 🛠️ Installation & Setup

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

## 🧪 Testing

### Backend Testing

The project includes comprehensive unit tests for all backend components.

#### Run All Tests
```powershell
cd backend

# Using pytest
python -m pytest tests/ -v

# Using unittest
python tests/run_tests.py
```

#### Run Specific Tests
```powershell
# Authentication tests
python -m pytest tests/test_auth_routes.py -v

# Loan application tests
python -m pytest tests/test_loan_application_routes.py -v

# ML model tests
python -m pytest tests/test_ml_models.py -v
```

#### Run with Coverage
```powershell
python -m pytest tests/ --cov=routes --cov=services --cov=ml_models --cov-report=html
```

### Frontend Testing

```powershell
cd frontend

# Run unit tests
flutter test test/unit_test.dart

# Run widget tests
flutter test test/widget_test.dart
```

### Test Documentation

For comprehensive test documentation including test cases, test design, and test execution plans, see:
- **[TEST_DESIGN_SPECIFICATION.md](TEST_DESIGN_SPECIFICATION.md)** - Complete test design specification
- **[backend/tests/README.md](backend/tests/README.md)** - Backend testing guide

#### Test Coverage

- **Backend Unit Tests**: 95%+ coverage
  - Authentication routes
  - Loan application routes
  - Credit score routes
  - Dashboard routes
  - Service layer (Firebase, Email, Twilio)
  - ML models (accuracy, predictions, counterfactuals)

- **Frontend Unit Tests**: 90%+ coverage
  - Input validation (IC, phone, email, OTP)
  - Business logic (DSR, credit score categorization)
  - Utility functions

## 📚 Documentation

- **[projectdetail.txt](projectdetail.txt)** - Detailed project documentation (Chapters 4 & 5)
- **[TEST_DESIGN_SPECIFICATION.md](TEST_DESIGN_SPECIFICATION.md)** - Comprehensive test specification
- **[backend/tests/README.md](backend/tests/README.md)** - Backend testing guide

## 🔐 Security Features

- Multi-factor authentication (Username, Password, OTP)
- Token-based authorization with 7-day expiry
- HTTPS encryption for all API communications
- Firebase security rules
- Password hashing
- Input validation and sanitization

## 📊 System Requirements (Non-Functional)

- **Accuracy**: ML models maintain ≥90% accuracy
- **Performance**: Loan processing completes within 10 seconds
- **Security**: MFA, token-based auth, HTTPS encryption
- **Usability**: Intuitive UI/UX with clear explanations

## 🎯 Use Cases

1. **User Authentication (UC-1)** - Multi-factor authentication with bank credentials
2. **Apply for Loan (UC-2)** - Submit loan application with ML-based prediction
3. **Validate Loan Application (UC-3)** - Officer review and decision
4. **View Credit Score (UC-4)** - Monthly credit score and credit card info
5. **View Dashboard Analytics (UC-5)** - Financial health dashboard
6. **Profile Management (UC-6)** - Logout and data consent
7. **Provide Counterfactual Explanations (UC-7)** - XAI for rejected applications

## 🤖 Machine Learning Models

### Credit Score Model
- **Algorithm**: Gradient Boosting Regressor
- **Accuracy**: R² ≥ 0.85
- **Range**: 300-850
- **Categories**: Poor, Fair, Good, Very Good, Excellent

### Loan Approval Model
- **Algorithm**: Gradient Boosting Classifier
- **Accuracy**: ≥90%
- **Output**: Approved (1) or Rejected (0)
- **Features**: Income, DSR, Credit Score, CCRIS, Employment Status, etc.

### Explainable AI (XAI)
- **Library**: DiCE (Diverse Counterfactual Explanations)
- **Purpose**: Actionable feedback for rejected applications
- **Limit**: ≤5 feature changes suggested

## 🚦 Getting Started

1. Clone the repository
2. Set up backend (Python, Flask, Firebase)
3. Train ML models
4. Set up frontend (Flutter)
5. Run tests to verify installation
6. Start developing!

## 📝 License

This project is developed as part of an academic Final Year Project (FYP).

## 👥 Contributors

- **Project Team** - FYP Semester 7

## 🙏 Acknowledgments

- Supervisor and academic advisors
- Firebase, Flutter, and scikit-learn communities
- Twilio and MailerSend for API services

---

**For detailed system design, architecture, and implementation details, refer to [projectdetail.txt](projectdetail.txt).**
