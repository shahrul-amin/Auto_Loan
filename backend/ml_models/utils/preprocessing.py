import pandas as pd
import numpy as np
from sklearn.preprocessing import StandardScaler, LabelEncoder, OrdinalEncoder
from sklearn.model_selection import train_test_split
import pickle
import os

class CreditScorePreprocessor:
    def __init__(self):
        self.scalers = {}
        self.encoders = {}
        self.feature_names = None
        self.categorical_features = [
            'EmploymentStatus', 'EmploymentSector', 'EducationLevel',
            'MaritalStatus', 'HomeOwnership'
        ]
        self.numerical_features = [
            'Age', 'MonthlyIncome', 'AnnualIncome', 'WorkExperience',
            'EPFMonthlyContribution', 'EPFBalance', 'CreditScore',
            'NumCreditFacilities', 'OutstandingFacilities', 'CreditCardLimit',
            'CreditCardBalance', 'CreditUtilization', 'ExistingLoanCommitments',
            'PaymentHistoryScore', 'CreditHistoryLength', 'BankingRelationship',
            'NumDependents', 'SavingsBalance', 'OwnsProperty'
        ]
        self.target_encoder = None
        
    def fit(self, df):
        X = df.copy()
        
        for feature in self.categorical_features:
            if feature in X.columns:
                le = LabelEncoder()
                le.fit(X[feature].astype(str))
                self.encoders[feature] = le
        
        for feature in self.numerical_features:
            if feature in X.columns:
                scaler = StandardScaler()
                scaler.fit(X[[feature]])
                self.scalers[feature] = scaler
        
        if 'CreditScoreCategory' in df.columns:
            category_order = ['Poor', 'Fair', 'Good', 'Very Good', 'Excellent']
            self.target_encoder = LabelEncoder()
            self.target_encoder.fit(category_order)
        
        return self
    
    def transform(self, df):
        X = df.copy()
        
        for feature in self.categorical_features:
            if feature in X.columns and feature in self.encoders:
                X[feature] = self.encoders[feature].transform(X[feature].astype(str))
        
        for feature in self.numerical_features:
            if feature in X.columns and feature in self.scalers:
                X[feature] = self.scalers[feature].transform(X[[feature]]).flatten()
        
        # Ensure column order matches training data
        if hasattr(self, 'feature_names') and self.feature_names:
            X = X[self.feature_names]
        
        return X
    
    def fit_transform(self, df):
        self.fit(df)
        transformed = self.transform(df)
        self.feature_names = list(transformed.columns)
        return transformed
    
    def encode_target(self, y):
        if self.target_encoder is None:
            raise ValueError("Target encoder not fitted")
        return self.target_encoder.transform(y)
    
    def decode_target(self, y):
        if self.target_encoder is None:
            raise ValueError("Target encoder not fitted")
        return self.target_encoder.inverse_transform(y)
    
    def save(self, filepath):
        with open(filepath, 'wb') as f:
            pickle.dump(self, f)
    
    @staticmethod
    def load(filepath):
        with open(filepath, 'rb') as f:
            return pickle.load(f)


class LoanApprovalPreprocessor:
    def __init__(self):
        self.scalers = {}
        self.encoders = {}
        self.feature_names = None
        self.categorical_features = [
            'EmploymentStatus', 'EmploymentSector', 'EducationLevel',
            'LoanType', 'MaritalStatus', 'HomeOwnership'
        ]
        self.numerical_features = [
            'Age', 'MonthlyIncome', 'AnnualIncome', 'WorkExperience',
            'EPFMonthlyContribution', 'EPFBalance', 'CreditScore',
            'ExistingLoanCommitments', 'BankingRelationship', 'LoanAmount', 
            'LoanDuration', 'InterestRate', 'MonthlyLoanPayment', 'DSR', 
            'NetMonthlyIncome', 'LoanToIncomeRatio', 'NumDependents', 
            'SavingsBalance', 'OwnsProperty', 'GuarantorAvailable'
        ]
        
    def fit(self, df):
        X = df.copy()

        for feature in self.categorical_features:
            if feature in X.columns:
                le = LabelEncoder()
                le.fit(X[feature].astype(str))
                self.encoders[feature] = le
        
        return self
    
    def transform(self, df):
        X = df.copy()
        
        columns_to_drop = ['ApplicationDate', 'CreditScoreCategory', 'CCRISStatus', 'LoanApproved']
        for col in columns_to_drop:
            if col in X.columns:
                X = X.drop(columns=[col])
        
        if 'LoanType' in X.columns:
            loan_type_mapping = {
                'IslamicPersonal': 'Islamic-Personal',
                'IslamicHousing': 'Islamic-Housing',
                'Islamic Personal': 'Islamic-Personal',
                'Islamic Housing': 'Islamic-Housing',
            }
            X['LoanType'] = X['LoanType'].replace(loan_type_mapping)
        
        # Only encode categorical features - no scaling
        for feature in self.categorical_features:
            if feature in X.columns and feature in self.encoders:
                X[feature] = self.encoders[feature].transform(X[feature].astype(str))
        
        # No StandardScaler applied - numerical features stay in original scale
        
        # Ensure column order matches training data
        if hasattr(self, 'feature_names') and self.feature_names:
            X = X[self.feature_names]
        
        return X
    
    def fit_transform(self, df):
        self.fit(df)
        transformed = self.transform(df)
        self.feature_names = list(transformed.columns)
        return transformed
    
    def save(self, filepath):
        with open(filepath, 'wb') as f:
            pickle.dump(self, f)
    
    @staticmethod
    def load(filepath):
        with open(filepath, 'rb') as f:
            return pickle.load(f)


def prepare_credit_score_data(data_path, test_size=0.2, random_state=42):
    df = pd.read_csv(data_path)
    
    df = df.drop(['ApplicationDate'], axis=1)
    
    y = df['CreditScoreCategory']
    X = df.drop(['CreditScoreCategory'], axis=1)
    
    X_train, X_test, y_train, y_test = train_test_split(
        X, y, test_size=test_size, random_state=random_state, stratify=y
    )
    
    preprocessor = CreditScorePreprocessor()
    
    category_order = ['Poor', 'Fair', 'Good', 'Excellent']
    preprocessor.target_encoder = LabelEncoder()
    preprocessor.target_encoder.fit(category_order)
    
    X_train_processed = preprocessor.fit_transform(X_train)
    X_test_processed = preprocessor.transform(X_test)
    
    y_train_encoded = preprocessor.encode_target(y_train)
    y_test_encoded = preprocessor.encode_target(y_test)
    
    return X_train_processed, X_test_processed, y_train_encoded, y_test_encoded, preprocessor, X.columns.tolist()


def prepare_loan_approval_data(data_path, test_size=0.2, random_state=42):
    df = pd.read_csv(data_path)
    
    df = df.drop(['ApplicationDate', 'CreditScoreCategory'], axis=1)
    
    y = df['LoanApproved']
    X = df.drop(['LoanApproved'], axis=1)
    
    X_train, X_test, y_train, y_test = train_test_split(
        X, y, test_size=test_size, random_state=random_state, stratify=y
    )
    
    preprocessor = LoanApprovalPreprocessor()
    X_train_processed = preprocessor.fit_transform(X_train)
    X_test_processed = preprocessor.transform(X_test)
    
    return X_train_processed, X_test_processed, y_train, y_test, preprocessor, X.columns.tolist()


def save_predictions(df, predictions, output_path):
    df_copy = df.copy()
    df_copy['PredictedCreditScore'] = predictions
    df_copy.to_csv(output_path, index=False)
    print(f"Predictions saved to {output_path}")
