import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_badge.dart';
import '../models/loan_application.dart';
import '../models/loan_status.dart';

class LoanHistoryCard extends StatelessWidget {
  const LoanHistoryCard({
    required this.application,
    this.onTap,
    super.key,
  });

  final LoanApplication application;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          AppSpacing.verticalSpaceSM,
          _buildAmount(),
          AppSpacing.verticalSpaceSM,
          _buildDetails(),
          AppSpacing.verticalSpaceMD,
          const Divider(color: AppColors.border, height: 1),
          AppSpacing.verticalSpaceMD,
          _buildFooter(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        _buildLoanTypeIcon(),
        AppSpacing.horizontalSpaceSM,
        Expanded(
          child: Text(
            _getLoanTypeLabel(),
            style: AppTextStyles.headingSmall.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
        ),
        AppSpacing.horizontalSpaceSM,
        _buildStatusBadge(),
      ],
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
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: iconColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(
        iconData,
        color: iconColor,
        size: 24,
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

  Widget _buildAmount() {
    final formatter = NumberFormat.currency(symbol: 'RM ', decimalDigits: 2);
    final amount = application.approvedAmount ?? application.requestedAmount;
    final isApproved = application.approvedAmount != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isApproved ? 'Approved Amount' : 'Requested Amount',
          style: AppTextStyles.labelSmall.copyWith(
            color: AppColors.textTertiary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          formatter.format(amount),
          style: AppTextStyles.displayMedium.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        if (isApproved &&
            application.approvedAmount != application.requestedAmount) ...[
          const SizedBox(height: 4),
          Text(
            'Requested: ${formatter.format(application.requestedAmount)}',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textTertiary,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildDetails() {
    return Row(
      children: [
        Expanded(
          child: _buildDetailItem(
            'Tenure',
            '${application.tenure} ${application.tenure == 1 ? 'year' : 'years'}',
          ),
        ),
        AppSpacing.horizontalSpaceMD,
        Expanded(
          child: _buildDetailItem(
            'Rate',
            application.interestRate != null
                ? '${application.interestRate}%'
                : 'TBD',
          ),
        ),
        AppSpacing.horizontalSpaceMD,
        Expanded(
          child: _buildDetailItem(
            'Guarantor',
            application.guarantorAvailable ? 'Yes' : 'No',
          ),
        ),
      ],
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.labelSmall.copyWith(
            color: AppColors.textTertiary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildFooter() {
    return Row(
      children: [
        const Icon(
          Icons.schedule,
          color: AppColors.textTertiary,
          size: 16,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            'Applied: ${_formatDate(application.applicationDate)}',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ),
        if (onTap != null) ...[
          AppSpacing.horizontalSpaceSM,
          const Icon(
            Icons.arrow_forward_ios_rounded,
            color: AppColors.textTertiary,
            size: 16,
          ),
        ],
      ],
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
      return DateFormat('dd MMM yyyy').format(date);
    } catch (e) {
      return dateString;
    }
  }
}
