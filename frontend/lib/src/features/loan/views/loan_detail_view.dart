import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_badge.dart';
import '../models/loan_application.dart';
import '../models/loan_status.dart';

class LoanDetailView extends ConsumerWidget {
  final LoanApplication application;

  const LoanDetailView({
    required this.application,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
        ),
        title: const Text(
          'Loan Application Details',
          style: TextStyle(color: AppColors.textPrimary),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: AppSpacing.screenPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                AppSpacing.verticalSpaceXL,
                _buildAmountCard(),
                AppSpacing.verticalSpaceXL,
                _buildDetailsSection(),
                AppSpacing.verticalSpaceXL,
                if (application.status == LoanStatus.rejected &&
                    application.rejectionReason != null &&
                    application.rejectionReason!.isNotEmpty) ...[
                  _buildRejectionSection(),
                  AppSpacing.verticalSpaceXL,
                ],
                if (application.officerRemarks != null &&
                    application.officerRemarks != 'None' &&
                    application.officerRemarks!.isNotEmpty) ...[
                  _buildRemarksSection(),
                  AppSpacing.verticalSpaceXL,
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: AppSpacing.cardPadding,
      decoration: BoxDecoration(
        color: AppColors.surface.withOpacity(0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.textPrimary.withOpacity(0.2),
        ),
      ),
      child: Row(
        children: [
          _buildLoanTypeIcon(),
          AppSpacing.horizontalSpaceMD,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _getLoanTypeLabel(),
                  style: AppTextStyles.headingMedium.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
                AppSpacing.verticalSpaceXS,
                Text(
                  'Application ID: ${application.applicationId}',
                  style: AppTextStyles.labelSmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          AppSpacing.horizontalSpaceSM,
          _buildStatusBadge(),
        ],
      ),
    );
  }

  Widget _buildLoanTypeIcon() {
    IconData iconData;
    Color iconColor;
    final loanType = application.loanType.toLowerCase();

    if (loanType.contains('vehicle') || loanType.contains('auto')) {
      iconData = Icons.directions_car_rounded;
      iconColor = AppColors.primaryBlue;
    } else if (loanType.contains('personal')) {
      iconData = Icons.account_balance_wallet_rounded;
      iconColor = AppColors.info;
    } else if (loanType.contains('housing') || loanType.contains('home')) {
      iconData = Icons.home_rounded;
      iconColor = AppColors.success;
    } else {
      iconData = Icons.account_balance_wallet_rounded;
      iconColor = AppColors.info;
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: iconColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        iconData,
        color: iconColor,
        size: 32,
      ),
    );
  }

  Widget _buildStatusBadge() {
    final status = application.status;

    return AppBadge(
      label: status.label,
      type: status.badgeType,
    );
  }

  Widget _buildAmountCard() {
    final formatter = NumberFormat.currency(symbol: 'RM ', decimalDigits: 2);
    final bool showApprovedAmount =
        (application.status == LoanStatus.approved ||
                application.status == LoanStatus.credited) &&
            application.approvedAmount != null;
    final amount = showApprovedAmount
        ? application.approvedAmount!
        : application.requestedAmount;
    final isApproved = showApprovedAmount;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primaryBlue.withOpacity(0.2),
            AppColors.primaryBlueDark.withOpacity(0.3),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.primaryBlue.withOpacity(0.3),
        ),
      ),
      child: Column(
        children: [
          Text(
            isApproved ? 'Approved Amount' : 'Requested Amount',
            style: AppTextStyles.labelMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          AppSpacing.verticalSpaceSM,
          Text(
            formatter.format(amount),
            style: AppTextStyles.displayLarge.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (isApproved &&
              application.approvedAmount != application.requestedAmount) ...[
            AppSpacing.verticalSpaceSM,
            Text(
              'Requested: ${formatter.format(application.requestedAmount)}',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDetailsSection() {
    return Container(
      padding: AppSpacing.cardPadding,
      decoration: BoxDecoration(
        color: AppColors.surface.withOpacity(0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.textPrimary.withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Loan Details',
            style: AppTextStyles.headingSmall.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          AppSpacing.verticalSpaceLG,
          _buildDetailRow('Purpose', application.purposeOfLoan),
          _buildDetailRow('Tenure',
              '${application.tenure} ${application.tenure == 1 ? 'year' : 'years'}'),
          if (application.status == LoanStatus.credited &&
              application.interestRate != null)
            _buildDetailRow(
              'Interest Rate',
              '${application.interestRate!.toStringAsFixed(2)}% p.a.',
            ),
          _buildDetailRow(
            'Guarantor',
            application.guarantorAvailable ? 'Available' : 'Not available',
          ),
          _buildDetailRow(
              'Application Date', _formatDate(application.applicationDate)),
          _buildDetailRow('Last Updated', _formatDate(application.lastUpdated)),
          if (application.assignedOfficer != null)
            _buildDetailRow('Assigned Officer', application.assignedOfficer!),
          if (application.mlConfidence != null &&
              (application.status == LoanStatus.approved ||
                  application.status == LoanStatus.credited))
            _buildDetailRow(
              'ML Confidence',
              '${(application.mlConfidence! * 100).toStringAsFixed(2)}%',
            ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              label,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textTertiary,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRejectionSection() {
    return Container(
      padding: AppSpacing.cardPadding,
      decoration: BoxDecoration(
        color: AppColors.error.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.error.withOpacity(0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.cancel_outlined,
                color: AppColors.error,
                size: 24,
              ),
              AppSpacing.horizontalSpaceSM,
              Text(
                'Rejection Reason',
                style: AppTextStyles.headingSmall.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          AppSpacing.verticalSpaceMD,
          Text(
            application.rejectionReason ?? '',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRemarksSection() {
    return Container(
      padding: AppSpacing.cardPadding,
      decoration: BoxDecoration(
        color: AppColors.warning.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.warning.withOpacity(0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.info_outline,
                color: AppColors.warning,
                size: 24,
              ),
              AppSpacing.horizontalSpaceSM,
              Text(
                'Officer Remarks',
                style: AppTextStyles.headingSmall.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          AppSpacing.verticalSpaceMD,
          Text(
            application.officerRemarks ?? '',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  String _getLoanTypeLabel() {
    final loanType = application.loanType.toLowerCase();

    if (loanType.contains('vehicle') || loanType.contains('auto')) {
      return 'Vehicle Loan';
    } else if (loanType.contains('personal')) {
      if (loanType.contains('islamic')) {
        return 'Islamic Personal Loan';
      }
      return 'Personal Loan';
    } else if (loanType.contains('housing') || loanType.contains('home')) {
      if (loanType.contains('islamic')) {
        return 'Islamic Housing Loan';
      }
      return 'Housing Loan';
    }

    return application.loanType;
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return DateFormat('dd MMM yyyy, hh:mm a').format(date);
    } catch (e) {
      return dateString;
    }
  }
}
