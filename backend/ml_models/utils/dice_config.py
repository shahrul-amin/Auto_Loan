import dice_ml
import pandas as pd
import numpy as np


IMMUTABLE_FEATURES = [
    'Age',
    'EducationLevel',
    'WorkExperience',
    'BankingRelationship',
    'OwnsProperty',
    'MaritalStatus',
    'NumDependents',
    'HomeOwnership',
    'EmploymentSector',
    'EmploymentStatus',
    'LoanType',
    'LoanDuration',
    'InterestRate',
]

ACTIONABLE_FEATURES = [
    'DSR',
    'LoanAmount',
    'CreditScore',
    'SavingsBalance',
    'EPFBalance',
    'ExistingLoanCommitments',
    'MonthlyIncome',
    'GuarantorAvailable',
]

FEATURE_RANGES = {
    'MonthlyIncome': [1800, 35000],
    'AnnualIncome': [21600, 420000],
    'EPFMonthlyContribution': [0, 3850],
    'EPFBalance': [0, 500000],
    'ExistingLoanCommitments': [0, 15000],
    'SavingsBalance': [500, 500000],
    'DSR': [0.0, 0.70],
    'LoanAmount': [5000, 800000],
    'LoanDuration': [12, 420],
    'InterestRate': [0.025, 0.12],
    'MonthlyLoanPayment': [100, 10000],
    'NetMonthlyIncome': [0, 35000],
    'LoanToIncomeRatio': [0.1, 15.0],
    'NumDependents': [0, 5],
    'GuarantorAvailable': [0, 1],
    'OwnsProperty': [0, 1],
}

CATEGORICAL_FEATURES = [
    'EmploymentStatus',
    'EmploymentSector',
    'EducationLevel',
    'LoanType',
    'MaritalStatus',
    'HomeOwnership',
    'CreditScoreCategory'
]

CONTINUOUS_FEATURES = [
    'Age',
    'MonthlyIncome',
    'AnnualIncome',
    'WorkExperience',
    'EPFMonthlyContribution',
    'EPFBalance',
    'ExistingLoanCommitments',
    'BankingRelationship',
    'LoanAmount',
    'LoanDuration',
    'InterestRate',
    'MonthlyLoanPayment',
    'DSR',
    'NetMonthlyIncome',
    'LoanToIncomeRatio',
    'NumDependents',
    'SavingsBalance',
    'OwnsProperty',
    'GuarantorAvailable'
]


def get_permitted_range(feature_name, current_value, direction='both'):
    if feature_name in FEATURE_RANGES:
        min_val, max_val = FEATURE_RANGES[feature_name]
        
        if direction == 'increase':
            return [current_value, max_val]
        elif direction == 'decrease':
            return [min_val, current_value]
        else:
            return [min_val, max_val]
    
    return None


def get_dice_constraints():
    """
    Define realistic constraints for counterfactual generation
    Only truly actionable features that users can control
    """
    constraints = {}
    
    # Debt reduction - can only decrease
    constraints['ExistingLoanCommitments'] = 'decrease'
    
    # Savings/assets - can only increase
    constraints['SavingsBalance'] = 'increase'
    constraints['EPFBalance'] = 'increase'
    
    # Income - can increase (promotion, side income)
    constraints['MonthlyIncome'] = 'increase'
    constraints['AnnualIncome'] = 'increase'
    
    # Loan adjustments - can negotiate
    constraints['LoanAmount'] = 'decrease'
    constraints['InterestRate'] = 'decrease'
    
    # Can add guarantor (0 -> 1)
    constraints['GuarantorAvailable'] = 'increase'
    
    
    return constraints


def create_dice_explainer(model, training_data, preprocessor=None, backend='sklearn', method='random'):
    """
    Create DiCE explainer
    
    Args:
        model: Trained sklearn model (no wrapper needed)
        training_data: Training data (already preprocessed)
        preprocessor: Not used for sklearn models
        backend: 'sklearn' (TF2 removed)
        method: 'random', 'genetic', or 'kdtree'
    """
    
    # Determine continuous features from training data
    numeric_cols = training_data.select_dtypes(include=[np.number]).columns.tolist()
    if 'LoanApproved' in numeric_cols:
        numeric_cols.remove('LoanApproved')
    
    d = dice_ml.Data(
        dataframe=training_data,
        continuous_features=numeric_cols,
        outcome_name='LoanApproved'
    )
    
    # sklearn models work directly with DiCE
    m = dice_ml.Model(model=model, backend=backend)
    
    exp = dice_ml.Dice(d, m, method=method)
    
    return exp


def generate_counterfactuals(dice_exp, query_instance, total_CFs=5, desired_class=1,
                            features_to_vary='all', proximity_weight=0.5, diversity_weight=2.0):
    try:
        # Build kwargs based on method compatibility
        kwargs = {
            'total_CFs': total_CFs,
            'desired_class': desired_class,
            'features_to_vary': features_to_vary,
            'proximity_weight': proximity_weight,
            'diversity_weight': diversity_weight
        }
        
        cf_examples = dice_exp.generate_counterfactuals(query_instance, **kwargs)
        
        return cf_examples
    
    except Exception as e:
        print(f"Error generating counterfactuals: {e}")
        return None


def format_counterfactual_explanation(original_instance, cf_examples, feature_names):
    if cf_examples is None:
        return None
    
    cf_df = cf_examples.cf_examples_list[0].final_cfs_df
    
    explanations = []
    
    for idx, cf_row in cf_df.iterrows():
        changes = []
        
        for feature in ACTIONABLE_FEATURES:
            if feature not in feature_names or feature not in cf_row.index:
                continue
            
            orig_val = original_instance[feature].values[0]
            cf_val = cf_row[feature]
            
            if orig_val == cf_val:
                continue
                
            if isinstance(orig_val, (int, float)) and isinstance(cf_val, (int, float)):
                diff = cf_val - orig_val
                
                if feature in ['MonthlyIncome', 'SavingsBalance', 'EPFBalance']:
                    if cf_val < orig_val:
                        continue
                
                if feature in ['ExistingLoanCommitments', 'LoanAmount', 'DSR']:
                    if cf_val > orig_val:
                        continue
                
                if abs(diff) < 0.01:
                    continue
                
                pct_change = (diff / orig_val * 100) if orig_val != 0 else 0
                
                if feature == 'DSR':
                    current_dsr = orig_val
                    target_dsr = max(cf_val, 0.55)
                    if target_dsr >= current_dsr:
                        continue
                    
                    monthly_income = original_instance['MonthlyIncome'].values[0] if 'MonthlyIncome' in original_instance.columns else 0
                    existing_commitments = original_instance['ExistingLoanCommitments'].values[0] if 'ExistingLoanCommitments' in original_instance.columns else 0
                    current_loan_payment = original_instance['MonthlyLoanPayment'].values[0] if 'MonthlyLoanPayment' in original_instance.columns else 0
                    current_loan_amount = original_instance['LoanAmount'].values[0] if 'LoanAmount' in original_instance.columns else 0
                    
                    total_monthly_debt = existing_commitments + current_loan_payment
                    target_income = total_monthly_debt / target_dsr if target_dsr > 0 else 0
                    
                    target_total_payment = target_dsr * monthly_income
                    target_loan_payment = target_total_payment - existing_commitments
                    
                    if target_loan_payment > 0 and current_loan_payment > 0:
                        reduction_ratio = target_loan_payment / current_loan_payment
                        suggested_loan_amount = current_loan_amount * reduction_ratio
                        
                        changes.append({
                            'feature': feature,
                            'original': f"{current_dsr:.1%}",
                            'suggested': f"{target_dsr:.1%}",
                            'change': f"Option A: Reduce loan to RM {suggested_loan_amount:,.0f} | Option B: Increase income to RM {target_income:,.0f}"
                        })
                    else:
                        changes.append({
                            'feature': feature,
                            'original': f"{current_dsr:.1%}",
                            'suggested': f"{target_dsr:.1%}",
                            'change': f"Increase income to RM {target_income:,.0f} or reduce existing debts"
                        })
                elif feature in ['MonthlyIncome', 'LoanAmount', 'SavingsBalance', 'EPFBalance', 'ExistingLoanCommitments']:
                    changes.append({
                        'feature': feature,
                        'original': f"RM {orig_val:,.0f}",
                        'suggested': f"RM {cf_val:,.0f}",
                        'change': f"RM {diff:+,.0f} ({pct_change:+.1f}%)"
                    })
                elif feature == 'CreditScore':
                    changes.append({
                        'feature': feature,
                        'original': f"{orig_val:.0f}",
                        'suggested': f"{cf_val:.0f}",
                        'change': f"{diff:+.0f} points"
                    })
                elif feature == 'GuarantorAvailable':
                    if cf_val == 1 and orig_val == 0:
                        changes.append({
                            'feature': feature,
                            'original': "No",
                            'suggested': "Yes",
                            'change': "Add a guarantor"
                        })
                else:
                    changes.append({
                        'feature': feature,
                        'original': f"{orig_val:.0f}",
                        'suggested': f"{cf_val:.0f}",
                        'change': f"{diff:+.0f} ({pct_change:+.1f}%)"
                    })
        
        if changes:
            explanations.append({
                'scenario': idx + 1,
                'changes': changes
            })
    
    return explanations


def print_counterfactual_explanation(explanations):
    if not explanations:
        print("No counterfactual explanations available")
        return
    
    print("\n" + "=" * 80)
    print("COUNTERFACTUAL EXPLANATIONS - WHY WAS THE LOAN REJECTED?")
    print("=" * 80)
    print("\nHere are alternative scenarios where your loan would be APPROVED:\n")
    
    for exp in explanations:
        print(f"\n{'─' * 80}")
        print(f"SCENARIO {exp['scenario']}: Change the following")
        print(f"{'─' * 80}")
        
        for change in exp['changes']:
            print(f"\n  {change['feature']}:")
            print(f"    Current:  {change['original']}")
            print(f"    Suggested: {change['suggested']}")
            print(f"    Change:   {change['change']}")
        
        print()
    
    print("=" * 80)


def get_feature_change_summary(explanations):
    if not explanations:
        return {}
    
    feature_changes = {}
    
    for exp in explanations:
        for change in exp['changes']:
            feature = change['feature']
            if feature not in feature_changes:
                feature_changes[feature] = {
                    'count': 0,
                    'suggestions': []
                }
            feature_changes[feature]['count'] += 1
            feature_changes[feature]['suggestions'].append({
                'scenario': exp['scenario'],
                'from': change['original'],
                'to': change['suggested'],
                'change': change['change']
            })
    
    sorted_features = sorted(feature_changes.items(), 
                            key=lambda x: x[1]['count'], 
                            reverse=True)
    
    print("\n" + "=" * 80)
    print("FEATURE CHANGE SUMMARY (Most frequently suggested changes)")
    print("=" * 80)
    
    for feature, data in sorted_features[:10]:
        print(f"\n{feature}: Suggested in {data['count']} scenario(s)")
        for sugg in data['suggestions'][:3]:
            print(f"  Scenario {sugg['scenario']}: {sugg['from']} → {sugg['to']} ({sugg['change']})")
    
    print("=" * 80)
    
    return dict(sorted_features)
