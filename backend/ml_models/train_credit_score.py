import os
import sys
import time
import pickle
import pandas as pd
import numpy as np
from sklearn.ensemble import GradientBoostingRegressor

sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from utils.preprocessing import prepare_credit_score_data, CreditScorePreprocessor
from utils.evaluation import (
    evaluate_multiclass_model,
    plot_feature_importance,
    print_training_summary
)

print("\n=== Credit Score Model Training ===\n")

DATA_PATH = os.path.join('data', 'malaysian_credit_scoring_data.csv')
MODEL_DIR = os.path.join('credit_score', 'v1.0.0')
os.makedirs(MODEL_DIR, exist_ok=True)

print(f"Loading data: {DATA_PATH}")

df = pd.read_csv(DATA_PATH)
X = df.drop(['ApplicationDate', 'CreditScoreCategory', 'CreditScore', 'CCRISStatus'], axis=1)
y = df['CreditScore']

from sklearn.model_selection import train_test_split
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)

preprocessor = CreditScorePreprocessor()
X_train_processed = preprocessor.fit_transform(X_train)
X_test_processed = preprocessor.transform(X_test)
feature_names = list(X_train_processed.columns)

print(f"Train: {len(X_train):,} | Test: {len(X_test):,} | Features: {len(feature_names)}")

print("\nTraining Gradient Boosting Regressor...")

model = GradientBoostingRegressor(
    n_estimators=200,
    max_depth=5,
    learning_rate=0.1,
    random_state=42
)

start_time = time.time()

model.fit(X_train_processed, y_train)

training_time = time.time() - start_time
print(f"Training completed in {training_time:.2f}s | Estimators: {model.n_estimators}")

print("\nEvaluating model...")

y_pred = model.predict(X_test_processed)
y_pred = np.clip(y_pred, 300, 850).astype(int)

from sklearn.metrics import mean_absolute_error, mean_squared_error, r2_score

mae = mean_absolute_error(y_test, y_pred)
rmse = np.sqrt(mean_squared_error(y_test, y_pred))
r2 = r2_score(y_test, y_pred)

print(f"MAE: {mae:.2f} | RMSE: {rmse:.2f} | R2: {r2:.4f}")

def get_credit_category(score):
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

y_test_cat = y_test.apply(get_credit_category)
y_pred_cat = pd.Series(y_pred).apply(get_credit_category)

from sklearn.metrics import accuracy_score, classification_report
cat_accuracy = accuracy_score(y_test_cat, y_pred_cat)
print(f"Category Accuracy: {cat_accuracy:.4f}")
print("\nClassification Report:")
print(classification_report(y_test_cat, y_pred_cat))

print("\nGenerating feature importance...")
feature_importance = plot_feature_importance(
    model,
    feature_names,
    save_path=os.path.join(MODEL_DIR, 'feature_importance.png'),
    top_n=20
)

print("\nSaving model artifacts...")

model_path = os.path.join(MODEL_DIR, 'model.pkl')
with open(model_path, 'wb') as f:
    pickle.dump(model, f)

preprocessor_path = os.path.join(MODEL_DIR, 'preprocessor.pkl')
preprocessor.save(preprocessor_path)

with open(os.path.join('credit_score', 'active_version.txt'), 'w') as f:
    f.write('v1.0.0')

print(f"Model saved: {MODEL_DIR}")

print("\nGenerating predictions for full dataset...")
df_full = pd.read_csv(DATA_PATH)
df_full_no_target = df_full.drop(['ApplicationDate', 'CreditScoreCategory', 'CreditScore', 'CCRISStatus'], axis=1)

X_full_processed = preprocessor.transform(df_full_no_target)
predictions_raw = model.predict(X_full_processed)
predictions = np.clip(predictions_raw, 300, 850).astype(int)
predictions_cat = pd.Series(predictions).apply(get_credit_category)

output_df = df_full.copy()
output_df['PredictedCreditScore'] = predictions
output_df['PredictedCreditScoreCategory'] = predictions_cat

prediction_output_path = os.path.join('data', 'credit_score_predictions.csv')
output_df.to_csv(prediction_output_path, index=False)

print(f"Predictions saved: {prediction_output_path}")
print(f"\nCredit Score Model Training Complete")
print(f"  MAE: {mae:.2f}")
print(f"  RMSE: {rmse:.2f}")
print(f"  R2 Score: {r2:.4f}")
print(f"  Category Accuracy: {cat_accuracy:.4f}\n")
