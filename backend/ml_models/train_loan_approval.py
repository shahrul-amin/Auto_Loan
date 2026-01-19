import os
import sys
import time
import pickle
import pandas as pd
import numpy as np
import json
import warnings
from sklearn.ensemble import GradientBoostingClassifier
from sklearn.metrics import accuracy_score, roc_auc_score, f1_score

warnings.filterwarnings('ignore', category=pd.errors.PerformanceWarning)
warnings.filterwarnings('ignore', category=UserWarning)

sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from utils.preprocessing import prepare_loan_approval_data, LoanApprovalPreprocessor
from utils.evaluation import (
    evaluate_binary_model,
    plot_feature_importance,
    print_training_summary
)
from utils.dice_config import (
    create_dice_explainer,
    generate_counterfactuals,
    format_counterfactual_explanation,
    print_counterfactual_explanation,
    get_feature_change_summary,
    IMMUTABLE_FEATURES,
    ACTIONABLE_FEATURES
)

print("\n=== Loan Approval Model Training (with DiCE) ===\n")

DATA_PATH = os.path.join('data', 'malaysian_loan_approval_data.csv')
CREDIT_PRED_PATH = os.path.join('data', 'credit_score_predictions.csv')
MODEL_DIR = os.path.join('loan_approval', 'v1.0.0')
os.makedirs(MODEL_DIR, exist_ok=True)

print(f"Loading data: {DATA_PATH}")
df_loan = pd.read_csv(DATA_PATH)

print(f"Loading credit predictions: {CREDIT_PRED_PATH}")
df_credit_pred = pd.read_csv(CREDIT_PRED_PATH)

df_loan['CreditScore'] = df_credit_pred['PredictedCreditScore']

print("\nPreparing training data...")

X_train, X_test, y_train, y_test, preprocessor, feature_names = prepare_loan_approval_data(
    DATA_PATH, test_size=0.2, random_state=42
)

df_loan_processed = df_loan.copy()
df_loan_processed = df_loan_processed.drop(['ApplicationDate'], axis=1)

print(f"Train: {len(X_train):,} | Test: {len(X_test):,} | Features: {len(feature_names)}")
print(f"Approval rate: {y_train.mean():.2%}")

print("\nBuilding Gradient Boosting Classifier...")

model = GradientBoostingClassifier(
    n_estimators=200,
    max_depth=5,
    learning_rate=0.1,
    random_state=42
)

print("\nTraining Gradient Boosting Classifier...")

# Convert to DataFrames with feature names for sklearn compatibility
X_train_df = pd.DataFrame(X_train, columns=feature_names)
X_test_df = pd.DataFrame(X_test, columns=feature_names)

start_time = time.time()

model.fit(X_train_df, y_train)

training_time = time.time() - start_time
print(f"\nTraining completed in {training_time:.2f}s")

print("\nEvaluating model...")

y_pred_proba = model.predict_proba(X_test_df)[:, 1]
y_pred = model.predict(X_test_df)

metrics = evaluate_binary_model(
    y_test, y_pred, y_pred_proba,
    save_dir=MODEL_DIR
)

print("\nGenerating feature importance...")
feature_importance = plot_feature_importance(
    model,
    feature_names,
    save_path=os.path.join(MODEL_DIR, 'feature_importance.png'),
    top_n=20
)

print("\nInitializing DiCE explainer...")

df_train_processed_with_target = X_train_df.copy()
df_train_processed_with_target['LoanApproved'] = y_train.values

# Reset index to ensure clean DataFrame
df_train_processed_with_target = df_train_processed_with_target.reset_index(drop=True)

try:
    dice_exp = create_dice_explainer(
        model=model,
        training_data=df_train_processed_with_target,
        preprocessor=None,
        backend='sklearn',
        method='genetic'
    )
    
    dice_path = os.path.join(MODEL_DIR, 'dice_explainer.pkl')
    with open(dice_path, 'wb') as f:
        pickle.dump(dice_exp, f)
    print("DiCE explainer created and saved")
    
except Exception as e:
    print(f"Error creating DiCE explainer: {e}")
    dice_exp = None

print("\nTesting counterfactual generation...")

if dice_exp is not None:
    rejected_indices = np.where((y_test == 0) & (y_pred == 0))[0]
    
    if len(rejected_indices) > 0:
        print(f"Generating counterfactuals for {min(3, len(rejected_indices))} rejected cases...")
        
        examples_to_test = min(3, len(rejected_indices))
        all_explanations = []
        
        for i in range(examples_to_test):
            test_idx = rejected_indices[i]
            # Use preprocessed test data (X_test is numpy array)
            query_instance = pd.DataFrame(X_test[test_idx:test_idx+1], columns=feature_names)
            
            try:
                features_to_vary = [f for f in ACTIONABLE_FEATURES if f in feature_names]
                
                cf_examples = generate_counterfactuals(
                    dice_exp,
                    query_instance,
                    total_CFs=5,
                    desired_class=1,
                    features_to_vary=features_to_vary,
                    proximity_weight=0.5,
                    diversity_weight=3.0  # Higher value for more diverse features
                )
                
                if cf_examples is not None:
                    explanations = format_counterfactual_explanation(
                        query_instance,
                        cf_examples,
                        feature_names
                    )
                    
                    if explanations:
                        all_explanations.append({
                            'example': i + 1,
                            'original': query_instance.to_dict('records')[0],
                            'counterfactuals': explanations
                        })
                    
            except Exception as e:
                print(f"Error generating counterfactuals for example {i+1}: {e}")
        
        if all_explanations:
            examples_path = os.path.join(MODEL_DIR, 'example_explanations.json')
            with open(examples_path, 'w') as f:
                json.dump(all_explanations, f, indent=2, default=str)
            print(f"Counterfactual examples saved: {examples_path}")

print("\nSaving model artifacts...")

model_path = os.path.join(MODEL_DIR, 'model.pkl')
with open(model_path, 'wb') as f:
    pickle.dump(model, f)
print(f"sklearn model saved: {model_path}")

preprocessor_path = os.path.join(MODEL_DIR, 'preprocessor.pkl')
preprocessor.save(preprocessor_path)

with open(os.path.join('loan_approval', 'active_version.txt'), 'w') as f:
    f.write('v1.0.0')

print(f"Model saved: {MODEL_DIR}")

print(f"\nLoan Approval Model Training Complete")
print(f"  Accuracy: {metrics['accuracy']:.4f}")
print(f"  ROC-AUC: {metrics['roc_auc']:.4f}")
print(f"  F1 Score: {metrics['f1']:.4f}\n")
