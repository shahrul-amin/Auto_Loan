import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_primary_button.dart';
import '../viewmodels/loan_viewmodel.dart';
import '../widgets/loan_history_card.dart';
import '../../auth/viewmodels/auth_viewmodel.dart';
import 'loan_detail_view.dart';
import '../../../core/widgets/custom_refresh_indicator.dart';

class LoanView extends ConsumerWidget {
  const LoanView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authViewModelProvider);

    return authState.maybeWhen(
      authenticated: (user) {
        final loanHistoryAsync =
            ref.watch(loanViewModelProvider(user.icNumber));

        return _buildLoanContent(context, ref, loanHistoryAsync, user.icNumber);
      },
      orElse: () => const Scaffold(
        body: Center(
          child: CircularProgressIndicator(color: AppColors.primaryBlue),
        ),
      ),
    );
  }

  Widget _buildLoanContent(
    BuildContext context,
    WidgetRef ref,
    AsyncValue loanHistoryAsync,
    String userId,
  ) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: loanHistoryAsync.when(
            loading: () => Column(
              children: [
                _buildHeader(context, ref, hasLoans: false),
                Expanded(child: _buildLoadingState()),
              ],
            ),
            error: (error, stack) => Column(
              children: [
                _buildHeader(context, ref, hasLoans: false),
                Expanded(child: _buildErrorState(context, ref, userId)),
              ],
            ),
            data: (loans) => Column(
              children: [
                _buildHeader(context, ref, hasLoans: loans.isNotEmpty),
                Expanded(
                  child: loans.isEmpty
                      ? _buildEmptyState(context)
                      : CustomRefreshIndicator(
                          onRefresh: () async {
                            ref.invalidate(loanViewModelProvider(userId));
                            await Future.delayed(
                                const Duration(milliseconds: 500));
                          },
                          child: _buildLoanList(loans, context),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, WidgetRef ref,
      {required bool hasLoans}) {
    return Container(
      padding: AppSpacing.screenPadding,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'My Loans',
                  style: AppTextStyles.displayMedium.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                AppSpacing.verticalSpaceXS,
                Text(
                  'Track your loan applications',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          if (hasLoans) ...[
            AppSpacing.horizontalSpaceMD,
            IconButton(
              onPressed: () => _handleApplyLoan(context),
              icon: const Icon(
                Icons.add_circle,
                color: AppColors.primaryBlue,
                size: 32,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildLoanList(List loans, BuildContext context) {
    return ListView.separated(
      padding: AppSpacing.screenPadding,
      itemCount: loans.length,
      separatorBuilder: (context, index) => AppSpacing.verticalSpaceMD,
      itemBuilder: (context, index) {
        final application = loans[index];
        return LoanHistoryCard(
          application: application,
          onTap: () => _handleLoanTap(context, application),
        );
      },
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: AppSpacing.screenPadding,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.surface.withOpacity(0.5),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.description_outlined,
                size: 64,
                color: AppColors.textTertiary,
              ),
            ),
            AppSpacing.verticalSpaceXL,
            Text(
              'No loan applications yet',
              style: AppTextStyles.headingMedium.copyWith(
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            AppSpacing.verticalSpaceSM,
            Text(
              'Apply for your first loan to get started',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            AppSpacing.verticalSpaceXXL,
            AppPrimaryButton(
              onPressed: () => _handleApplyLoan(context),
              label: 'Apply for Loan',
              icon: Icons.add_rounded,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return const SizedBox.shrink();
  }

  Widget _buildErrorState(BuildContext context, WidgetRef ref, String userId) {
    return Center(
      child: Padding(
        padding: AppSpacing.screenPadding,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline_rounded,
              size: 64,
              color: AppColors.error,
            ),
            AppSpacing.verticalSpaceLG,
            Text(
              'Failed to load loans',
              style: AppTextStyles.headingMedium.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            AppSpacing.verticalSpaceSM,
            Text(
              'Please try again',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            AppSpacing.verticalSpaceXL,
            AppPrimaryButton(
              onPressed: () => ref.refresh(loanViewModelProvider(userId)),
              label: 'Retry',
            ),
          ],
        ),
      ),
    );
  }

  void _handleApplyLoan(BuildContext context) {
    Navigator.of(context).pushNamed('/loan/apply');
  }

  void _handleLoanTap(BuildContext context, dynamic application) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => LoanDetailView(application: application),
      ),
    );
  }
}
