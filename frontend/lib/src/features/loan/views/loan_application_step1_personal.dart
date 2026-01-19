import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_primary_button.dart';
import '../../profile/providers/personal_info_provider.dart';
import 'loan_application_view.dart';

class LoanApplicationStep1Personal extends ConsumerWidget {
  const LoanApplicationStep1Personal({
    required this.icNumber,
    super.key,
  });

  final String icNumber;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final personalInfoAsync = ref.watch(personalInfoProvider(icNumber));

    return personalInfoAsync.when(
      loading: () => const Center(
        child: CircularProgressIndicator(color: AppColors.primaryBlue),
      ),
      error: (error, stack) => Center(
        child: Text(
          'Error loading personal information',
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.error,
          ),
        ),
      ),
      data: (personalInfo) {
        if (personalInfo == null) {
          return Center(
            child: Text(
              'Personal information not found',
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
                        'Personal Information',
                        style: AppTextStyles.headingMedium.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      AppSpacing.verticalSpaceXS,
                      Text(
                        'Please review your details',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textTertiary,
                        ),
                      ),
                      AppSpacing.verticalSpaceXL,
                      _buildFormField('Full Name', personalInfo.fullName),
                      AppSpacing.verticalSpaceMD,
                      _buildFormField('IC Number', personalInfo.icNumber),
                      AppSpacing.verticalSpaceMD,
                      _buildFormField(
                          'Date of Birth',
                          DateFormat('dd MMM yyyy')
                              .format(personalInfo.dateOfBirth)),
                      AppSpacing.verticalSpaceMD,
                      _buildFormField('Email', personalInfo.email),
                      AppSpacing.verticalSpaceMD,
                      _buildFormField('Phone Number', personalInfo.phoneNumber),
                      AppSpacing.verticalSpaceMD,
                      _buildFormField('Nationality', personalInfo.nationality),
                      AppSpacing.verticalSpaceMD,
                      Row(
                        children: [
                          Expanded(
                            child: _buildFormField(
                                'Marital Status', personalInfo.maritalStatus),
                          ),
                          AppSpacing.horizontalSpaceMD,
                          Expanded(
                            child: _buildFormField('Dependents',
                                personalInfo.numberOfDependents.toString()),
                          ),
                        ],
                      ),
                      AppSpacing.verticalSpaceMD,
                      Row(
                        children: [
                          Expanded(
                            child: _buildFormField(
                                'Education', personalInfo.educationLevel),
                          ),
                          AppSpacing.horizontalSpaceMD,
                          Expanded(
                            child: _buildFormField(
                                'Home Ownership', personalInfo.homeOwnership),
                          ),
                        ],
                      ),
                      AppSpacing.verticalSpaceMD,
                      _buildFormField('Property Owner',
                          personalInfo.ownsProperty ? 'Yes' : 'No'),
                      AppSpacing.verticalSpaceMD,
                      _buildFormField('Address', personalInfo.address),
                      AppSpacing.verticalSpaceMD,
                      Row(
                        children: [
                          Expanded(
                            child: _buildFormField('City', personalInfo.city),
                          ),
                          AppSpacing.horizontalSpaceMD,
                          Expanded(
                            child: _buildFormField(
                                'Postcode', personalInfo.postcode),
                          ),
                        ],
                      ),
                      AppSpacing.verticalSpaceMD,
                      _buildFormField('State', personalInfo.state),
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
                    ref.read(loanApplicationStepProvider.notifier).state = 1;
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
