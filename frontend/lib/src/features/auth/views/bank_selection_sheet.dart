import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../banking/models/bank_model.dart';
import '../providers/bank_providers.dart';
import '../viewmodels/auth_viewmodel.dart';
import 'bank_auth_view.dart';
import '../../../core/widgets/widgets.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';

class BankSelectionSheet extends ConsumerWidget {
  const BankSelectionSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final banksAsync = ref.watch(availableBanksProvider);

    return SafeArea(
      child: DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (context, scrollController) {
          return Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
            ),
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.xl,
              AppSpacing.xl,
              AppSpacing.xl,
              AppSpacing.xl,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                AppSpacing.verticalSpaceLG,
                const Text(
                  'Select Your Bank',
                  style: AppTextStyles.headingLarge,
                  textAlign: TextAlign.center,
                ),
                AppSpacing.verticalSpaceSM,
                Text(
                  'Choose your bank to continue with login',
                  style: AppTextStyles.bodyMedium.copyWith(color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
                AppSpacing.verticalSpaceXL,
                Expanded(
                  child: banksAsync.when(
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    error: (error, stack) => Center(
                      child: Text('Error loading banks: $error'),
                    ),
                    data: (banks) => ListView(
                      controller: scrollController,
                      children: banks
                          .map((bank) => _buildBankTile(context, ref, bank))
                          .toList(),
                    ),
                  ),
                ),
                AppSpacing.verticalSpaceLG,
                AppPrimaryButton(
                    label: 'Cancel',
                    onPressed: () => Navigator.pop(context),
                    isFullWidth: true),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildBankTile(BuildContext context, WidgetRef ref, Bank bank) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.asset(
            bank.logoAsset,
            width: 48,
            height: 48,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                width: 48,
                height: 48,
                color: bank.brandColor.withOpacity(0.2),
                child: Icon(
                  Icons.account_balance,
                  color: bank.brandColor,
                ),
              );
            },
          ),
        ),
        title: Text(
          bank.name,
          style: AppTextStyles.bodyLarge.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(bank.code),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        enabled: bank.isAvailable,
        onTap: bank.isAvailable
            ? () => _handleBankSelection(context, ref, bank)
            : null,
      ),
    );
  }

  void _handleBankSelection(BuildContext context, WidgetRef ref, Bank bank) {
    // Update auth state
    ref.read(authViewModelProvider.notifier).initiateBankLogin(bank);

    // Close bottom sheet
    Navigator.pop(context);

    // Navigate to generic bank auth page with bank object
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BankAuthView(bank: bank),
      ),
    );
  }
}
