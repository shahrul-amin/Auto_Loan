import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_primary_button.dart';
import '../../../core/widgets/app_secondary_button.dart';
import '../../banking/models/bank_model.dart';
import '../../auth/providers/auth_providers.dart';
import '../../auth/viewmodels/auth_viewmodel.dart';
import 'profile_setup_view.dart';

class DataConsentView extends ConsumerStatefulWidget {
  final Bank bank;
  final String username;

  const DataConsentView({
    super.key,
    required this.bank,
    required this.username,
  });

  @override
  ConsumerState<DataConsentView> createState() => _DataConsentViewState();
}

class _DataConsentViewState extends ConsumerState<DataConsentView> {
  bool _isLoading = false;

  Future<void> _handleConsent(bool consent) async {
    if (!consent) {
      Navigator.of(context).popUntil((route) => route.isFirst);
      return;
    }

    setState(() => _isLoading = true);

    try {
      final authRepo = ref.read(authRepositoryProvider);

      final bankUser =
          await authRepo.getBankUser(widget.bank.id, widget.username);
      if (bankUser == null) {
        throw Exception('Bank user not found');
      }

      final user = await authRepo.getUser(bankUser.icNumber);
      if (user == null) {
        throw Exception('User not found');
      }

      final updatedUser = user.copyWith(
        dataConsentGiven: true,
        dataConsentDate: DateTime.now(),
      );
      await authRepo.updateUser(updatedUser);

      await ref
          .read(authViewModelProvider.notifier)
          .completeAuthentication(widget.bank.id, widget.username);

      if (!mounted) return;

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => ProfileSetupView(userId: user.icNumber),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to load profile: $e'),
          backgroundColor: AppColors.error,
        ),
      );

      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildHeader(),
                        const SizedBox(height: AppSpacing.xl),
                        _buildConsentCard(),
                        const SizedBox(height: AppSpacing.lg),
                        _buildDataUsageSection(),
                        const SizedBox(height: AppSpacing.lg),
                        _buildSecurityNote(),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                _buildActionButtons(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: widget.bank.brandColor,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
        onPressed: () => _handleConsent(false),
      ),
      title: Text(
        'Data Consent',
        style: AppTextStyles.headingSmall.copyWith(
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: const BoxDecoration(
            color: AppColors.surface,
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.verified_user_outlined,
            size: 40,
            color: widget.bank.brandColor,
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        Text(
          'Data Access Request',
          style: AppTextStyles.headingLarge.copyWith(
            color: AppColors.textPrimary,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          'Auto Loan requests your permission to access financial data from ${widget.bank.name}',
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildConsentCard() {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'We will access:',
            style: AppTextStyles.bodyLarge.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          _buildDataItem(Icons.person_outline, 'Personal Information',
              'Name, IC, contact details'),
          _buildDataItem(Icons.work_outline, 'Employment Details',
              'Employer, income, position'),
          _buildDataItem(Icons.account_balance_wallet_outlined,
              'Banking Information', 'Account balances, credit cards'),
          _buildDataItem(Icons.credit_score_outlined, 'Credit Profile',
              'Credit score, existing loans'),
          _buildDataItem(Icons.history, 'Loan History',
              'Past and current loan applications'),
        ],
      ),
    );
  }

  Widget _buildDataItem(IconData icon, String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: AppColors.primaryBlue, size: 20),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  subtitle,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textTertiary,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.check_circle, color: AppColors.success, size: 20),
        ],
      ),
    );
  }

  Widget _buildDataUsageSection() {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.info_outline, color: AppColors.info, size: 20),
              SizedBox(width: AppSpacing.sm),
              Text(
                'How we use your data',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          _buildUsagePoint('Evaluate loan eligibility'),
          _buildUsagePoint('Calculate debt service ratio (DSR)'),
          _buildUsagePoint('Pre-fill loan application forms'),
          _buildUsagePoint('Provide personalized loan recommendations'),
          _buildUsagePoint('Track application status'),
        ],
      ),
    );
  }

  Widget _buildUsagePoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Container(
              width: 6,
              height: 6,
              decoration: const BoxDecoration(
                color: AppColors.primaryBlue,
                shape: BoxShape.circle,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSecurityNote() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.success.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.lock_outline, color: AppColors.success, size: 20),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Your data is secure',
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'We use bank-level encryption. Data is only used for loan processing. You can revoke access anytime.',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppPrimaryButton(
          label: 'Allow Access',
          onPressed: _isLoading ? null : () => _handleConsent(true),
          isLoading: _isLoading,
        ),
        const SizedBox(height: AppSpacing.md),
        AppSecondaryButton(
          label: 'Decline',
          onPressed: _isLoading ? null : () => _handleConsent(false),
        ),
      ],
    );
  }
}
