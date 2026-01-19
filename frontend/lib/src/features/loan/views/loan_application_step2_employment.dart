import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_primary_button.dart';
import '../../profile/providers/employment_info_provider.dart';
import 'loan_application_view.dart';

class LoanApplicationStep2Employment extends ConsumerWidget {
  const LoanApplicationStep2Employment({
    required this.icNumber,
    super.key,
  });

  final String icNumber;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final employmentInfoAsync = ref.watch(employmentInfoProvider(icNumber));

    return employmentInfoAsync.when(
      loading: () => const Center(
        child: CircularProgressIndicator(color: AppColors.primaryBlue),
      ),
      error: (error, stack) => Center(
        child: Text(
          'Error loading employment information',
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.error,
          ),
        ),
      ),
      data: (employmentInfo) {
        if (employmentInfo == null) {
          return Center(
            child: Text(
              'Employment information not found',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          );
        }

        return Container(
          decoration: BoxDecoration(
            color: AppColors.surface.withOpacity(0.85),
          ),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: AppSpacing.screenPadding,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Employment Information',
                        style: AppTextStyles.headingMedium.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      AppSpacing.verticalSpaceXS,
                      Text(
                        'Please review your employment details',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textTertiary,
                        ),
                      ),
                      AppSpacing.verticalSpaceXL,
                      _buildFormField(
                          'Employer Name', employmentInfo.employerName),
                      AppSpacing.verticalSpaceMD,
                      _buildFormField('Position', employmentInfo.position),
                      AppSpacing.verticalSpaceMD,
                      Row(
                        children: [
                          Expanded(
                            child: _buildFormField('Employment Type',
                                employmentInfo.employmentType),
                          ),
                          AppSpacing.horizontalSpaceMD,
                          Expanded(
                            child: _buildFormField(
                                'Industry', employmentInfo.industry),
                          ),
                        ],
                      ),
                      AppSpacing.verticalSpaceMD,
                      _buildFormField('Monthly Income',
                          'RM ${NumberFormat('#,##0.00').format(employmentInfo.monthlyIncome)}'),
                      AppSpacing.verticalSpaceMD,
                      _buildFormField(
                          'Employment Start Date',
                          DateFormat('dd MMM yyyy')
                              .format(employmentInfo.employmentStartDate)),
                      AppSpacing.verticalSpaceMD,
                      Row(
                        children: [
                          Expanded(
                            child: _buildFormField('EPF Contribution',
                                'RM ${NumberFormat('#,##0.00').format(employmentInfo.epfMonthlyContribution)}'),
                          ),
                          AppSpacing.horizontalSpaceMD,
                          Expanded(
                            child: _buildFormField('EPF Balance',
                                'RM ${NumberFormat('#,##0.00').format(employmentInfo.epfBalance)}'),
                          ),
                        ],
                      ),
                      if (employmentInfo.employerPhone != null) ...[
                        AppSpacing.verticalSpaceMD,
                        _buildFormField(
                            'Employer Phone', employmentInfo.employerPhone!),
                      ],
                      if (employmentInfo.employerAddress != null) ...[
                        AppSpacing.verticalSpaceMD,
                        _buildFormField('Employer Address',
                            employmentInfo.employerAddress!),
                      ],
                      AppSpacing.verticalSpaceXXL,
                    ],
                  ),
                ),
              ),
              Container(
                padding: AppSpacing.screenPadding,
                decoration: BoxDecoration(
                  color: AppColors.surface.withOpacity(0.95),
                  border: const Border(
                    top: BorderSide(color: AppColors.border, width: 1),
                  ),
                ),
                child: AppPrimaryButton(
                  onPressed: () {
                    ref.read(loanApplicationStepProvider.notifier).state = 2;
                  },
                  label: 'Next',
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFormField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.labelMedium.copyWith(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          decoration: BoxDecoration(
            color: AppColors.surfaceVariant.withOpacity(0.3),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppColors.border,
              width: 1,
            ),
          ),
          child: Text(
            value,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }
}
