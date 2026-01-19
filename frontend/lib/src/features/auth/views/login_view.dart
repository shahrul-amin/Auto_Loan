import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../viewmodels/auth_viewmodel.dart';
import 'bank_selection_sheet.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';

/// Initial login screen with bank selection
class LoginView extends ConsumerWidget {
  const LoginView({super.key});

  static const routeName = '/login';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authViewModelProvider);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SvgPicture.asset(
                  'assets/logo/main_logo.svg',
                  height: 200,
                ),
                const Text(
                  'Auto Loan',
                  style: AppTextStyles.displayLarge,
                  textAlign: TextAlign.center,
                ),
                AppSpacing.verticalSpaceMD,
                Text(
                  'Your trusted partner for auto financing',
                  style: AppTextStyles.bodyLarge.copyWith(color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
                AppSpacing.verticalSpaceXL,
                ElevatedButton.icon(
                  onPressed: () => _showBankSelection(context, ref),
                  label: const Text('Login with Bank Account'),
                  style: ElevatedButton.styleFrom(
                    padding:
                        const EdgeInsets.symmetric(vertical: AppSpacing.lg),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                AppSpacing.verticalSpaceLG,
                Text(
                  'Login securely using your bank credentials',
                  style: AppTextStyles.bodyMedium.copyWith(color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
                if (authState.maybeWhen(
                  bankSelectionInProgress: (_) => true,
                  orElse: () => false,
                ))
                  const Padding(
                    padding: EdgeInsets.only(top: AppSpacing.xl),
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showBankSelection(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => const BankSelectionSheet(),
    );
  }
}
