import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
from sklearn.metrics import (
    accuracy_score, precision_score, recall_score, f1_score,
    confusion_matrix, classification_report, roc_auc_score, roc_curve,
    precision_recall_curve, average_precision_score
)
import json
import os

sns.set_style('darkgrid')
plt.rcParams['figure.figsize'] = (10, 6)


def evaluate_multiclass_model(y_true, y_pred, y_pred_proba, class_names, save_dir=None):
    metrics = {
        'accuracy': float(accuracy_score(y_true, y_pred)),
        'precision_macro': float(precision_score(y_true, y_pred, average='macro')),
        'recall_macro': float(recall_score(y_true, y_pred, average='macro')),
        'f1_macro': float(f1_score(y_true, y_pred, average='macro')),
        'precision_weighted': float(precision_score(y_true, y_pred, average='weighted')),
        'recall_weighted': float(recall_score(y_true, y_pred, average='weighted')),
        'f1_weighted': float(f1_score(y_true, y_pred, average='weighted')),
    }
    
    per_class_metrics = {}
    for i, class_name in enumerate(class_names):
        mask = y_true == i
        if mask.sum() > 0:
            per_class_metrics[class_name] = {
                'precision': float(precision_score(y_true, y_pred, labels=[i], average='macro')),
                'recall': float(recall_score(y_true, y_pred, labels=[i], average='macro')),
                'f1': float(f1_score(y_true, y_pred, labels=[i], average='macro')),
                'support': int(mask.sum())
            }
    
    metrics['per_class'] = per_class_metrics
    
    print("\n" + "=" * 60)
    print("MULTICLASS CLASSIFICATION METRICS")
    print("=" * 60)
    print(f"Accuracy: {metrics['accuracy']:.4f}")
    print(f"Macro F1: {metrics['f1_macro']:.4f}")
    print(f"Weighted F1: {metrics['f1_weighted']:.4f}")
    print("\nPer-Class Metrics:")
    for class_name, class_metrics in per_class_metrics.items():
        print(f"\n{class_name}:")
        print(f"  Precision: {class_metrics['precision']:.4f}")
        print(f"  Recall: {class_metrics['recall']:.4f}")
        print(f"  F1: {class_metrics['f1']:.4f}")
        print(f"  Support: {class_metrics['support']}")
    
    if save_dir:
        os.makedirs(save_dir, exist_ok=True)
        
        with open(os.path.join(save_dir, 'metrics.json'), 'w') as f:
            json.dump(metrics, f, indent=2)
        
        cm = confusion_matrix(y_true, y_pred)
        plt.figure(figsize=(8, 6))
        sns.heatmap(cm, annot=True, fmt='d', cmap='Blues', 
                    xticklabels=class_names, yticklabels=class_names)
        plt.title('Confusion Matrix - Credit Score Prediction')
        plt.ylabel('True Label')
        plt.xlabel('Predicted Label')
        plt.tight_layout()
        plt.savefig(os.path.join(save_dir, 'confusion_matrix.png'), dpi=150)
        plt.close()
        
        print(f"\nMetrics saved to {save_dir}")
    
    return metrics


def evaluate_binary_model(y_true, y_pred, y_pred_proba, save_dir=None):
    metrics = {
        'accuracy': float(accuracy_score(y_true, y_pred)),
        'precision': float(precision_score(y_true, y_pred)),
        'recall': float(recall_score(y_true, y_pred)),
        'f1': float(f1_score(y_true, y_pred)),
        'roc_auc': float(roc_auc_score(y_true, y_pred_proba)),
        'average_precision': float(average_precision_score(y_true, y_pred_proba))
    }
    
    print("\n" + "=" * 60)
    print("BINARY CLASSIFICATION METRICS - LOAN APPROVAL")
    print("=" * 60)
    print(f"Accuracy: {metrics['accuracy']:.4f}")
    print(f"Precision: {metrics['precision']:.4f}")
    print(f"Recall: {metrics['recall']:.4f}")
    print(f"F1 Score: {metrics['f1']:.4f}")
    print(f"ROC-AUC: {metrics['roc_auc']:.4f}")
    print(f"Average Precision: {metrics['average_precision']:.4f}")
    
    approval_rate = y_pred.mean()
    actual_approval_rate = y_true.mean()
    print(f"\nApproval Rate (Predicted): {approval_rate:.2%}")
    print(f"Approval Rate (Actual): {actual_approval_rate:.2%}")
    
    print("\nClassification Report:")
    print(classification_report(y_true, y_pred, target_names=['Rejected', 'Approved']))
    
    if save_dir:
        os.makedirs(save_dir, exist_ok=True)
        
        with open(os.path.join(save_dir, 'metrics.json'), 'w') as f:
            json.dump(metrics, f, indent=2)
        
        cm = confusion_matrix(y_true, y_pred)
        plt.figure(figsize=(6, 5))
        sns.heatmap(cm, annot=True, fmt='d', cmap='Blues',
                    xticklabels=['Rejected', 'Approved'],
                    yticklabels=['Rejected', 'Approved'])
        plt.title('Confusion Matrix - Loan Approval')
        plt.ylabel('True Label')
        plt.xlabel('Predicted Label')
        plt.tight_layout()
        plt.savefig(os.path.join(save_dir, 'confusion_matrix.png'), dpi=150)
        plt.close()
        
        fpr, tpr, _ = roc_curve(y_true, y_pred_proba)
        plt.figure(figsize=(8, 6))
        plt.plot(fpr, tpr, label=f'ROC Curve (AUC = {metrics["roc_auc"]:.4f})')
        plt.plot([0, 1], [0, 1], 'k--', label='Random Classifier')
        plt.xlabel('False Positive Rate')
        plt.ylabel('True Positive Rate')
        plt.title('ROC Curve - Loan Approval Model')
        plt.legend()
        plt.grid(True)
        plt.tight_layout()
        plt.savefig(os.path.join(save_dir, 'roc_curve.png'), dpi=150)
        plt.close()
        
        precision_vals, recall_vals, _ = precision_recall_curve(y_true, y_pred_proba)
        plt.figure(figsize=(8, 6))
        plt.plot(recall_vals, precision_vals, 
                label=f'PR Curve (AP = {metrics["average_precision"]:.4f})')
        plt.xlabel('Recall')
        plt.ylabel('Precision')
        plt.title('Precision-Recall Curve - Loan Approval Model')
        plt.legend()
        plt.grid(True)
        plt.tight_layout()
        plt.savefig(os.path.join(save_dir, 'precision_recall_curve.png'), dpi=150)
        plt.close()
        
        print(f"\nMetrics and plots saved to {save_dir}")
    
    return metrics


def plot_feature_importance(model, feature_names, save_path=None, top_n=20):
    if hasattr(model, 'feature_importances_'):
        importances = model.feature_importances_
    elif hasattr(model, 'coef_'):
        importances = np.abs(model.coef_[0])
    else:
        print("Model does not have feature importances")
        return
    
    indices = np.argsort(importances)[::-1][:top_n]
    top_features = [feature_names[i] for i in indices]
    top_importances = importances[indices]
    
    plt.figure(figsize=(10, 8))
    plt.barh(range(len(top_features)), top_importances)
    plt.yticks(range(len(top_features)), top_features)
    plt.xlabel('Feature Importance')
    plt.title(f'Top {top_n} Feature Importances')
    plt.gca().invert_yaxis()
    plt.tight_layout()
    
    if save_path:
        plt.savefig(save_path, dpi=150, bbox_inches='tight')
        print(f"Feature importance plot saved to {save_path}")
    else:
        plt.show()
    
    plt.close()
    
    print(f"\nTop {top_n} Most Important Features:")
    for i, (feat, imp) in enumerate(zip(top_features, top_importances), 1):
        print(f"{i:2d}. {feat:30s}: {imp:.6f}")
    
    return dict(zip(top_features, top_importances.tolist()))


def print_training_summary(model_name, train_time, metrics, n_train, n_test):
    print("\n" + "=" * 60)
    print(f"TRAINING SUMMARY - {model_name}")
    print("=" * 60)
    print(f"Training samples: {n_train:,}")
    print(f"Testing samples: {n_test:,}")
    print(f"Training time: {train_time:.2f} seconds")
    print("=" * 60)
