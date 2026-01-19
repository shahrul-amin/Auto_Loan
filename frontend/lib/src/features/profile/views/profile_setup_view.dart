import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'dart:async';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../navigation/main_navigation_view.dart';
import '../../../core/api/api_service.dart';

class ProfileSetupView extends ConsumerStatefulWidget {
  final String userId;

  const ProfileSetupView({
    super.key,
    required this.userId,
  });

  static const routeName = '/profile/setup';

  @override
  ConsumerState<ProfileSetupView> createState() => _ProfileSetupViewState();
}

class _ProfileSetupViewState extends ConsumerState<ProfileSetupView> {
  Timer? _pollTimer;
  int _currentStep = 0;
  final List<String> _setupSteps = [
    'Analyzing your financial profile...',
    'Calculating credit score...',
    'Preparing your dashboard...',
    'Almost ready...',
  ];

  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _startSetupProcess();
  }

  @override
  void dispose() {
    _pollTimer?.cancel();
    super.dispose();
  }

  void _startSetupProcess() {
    Timer.periodic(const Duration(seconds: 2), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }

      setState(() {
        if (_currentStep < _setupSteps.length - 1) {
          _currentStep++;
        }
      });
    });

    _pollCreditScoreStatus();
  }

  Future<void> _pollCreditScoreStatus() async {
    int attemptCount = 0;
    const maxAttempts = 30;
    const pollInterval = Duration(seconds: 2);

    _pollTimer = Timer.periodic(pollInterval, (timer) async {
      if (!mounted) {
        timer.cancel();
        return;
      }

      attemptCount++;

      if (attemptCount > maxAttempts) {
        timer.cancel();
        if (mounted) {
          setState(() {
            _errorMessage =
                'Setup is taking longer than expected. Please try refreshing.';
          });
        }
        return;
      }

      try {
        final apiService = ApiService();
        final response =
            await apiService.get('/dashboard/${widget.userId}/summary');

        if (response['success'] == true && response['data'] != null) {
          final currentCreditScore =
              response['data']['currentCreditScore'] as int?;

          if (currentCreditScore != null && currentCreditScore > 0) {
            timer.cancel();
            if (mounted) {
              setState(() {
                _currentStep = _setupSteps.length - 1;
              });

              await Future.delayed(const Duration(seconds: 1));

              if (mounted) {
                Navigator.of(context).pushReplacementNamed(
                  MainNavigationView.routeName,
                  arguments: {'fromLogin': true},
                );
              }
            }
          }
        }
      } catch (e) {
        if (attemptCount >= 10) {
          timer.cancel();
          if (mounted) {
            setState(() {
              _errorMessage = 'Failed to setup profile. Please try again.';
            });
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(flex: 2),
                if (_errorMessage.isEmpty) ...[
                  _buildAnimatedLogo(),
                  AppSpacing.verticalSpaceXXXL,
                  _buildTitle(),
                  AppSpacing.verticalSpaceXL,
                  _buildStepText(),
                ] else ...[
                  _buildErrorState(),
                ],
                const Spacer(flex: 3),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedLogo() {
    return SizedBox(
      width: 200,
      height: 200,
      child: Lottie.asset(
        'assets/logo/loader.json',
        fit: BoxFit.contain,
      ),
    );
  }

  Widget _buildTitle() {
    return Column(
      children: [
        Text(
          'Setting Up Your Profile',
          style: AppTextStyles.headingLarge.copyWith(
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        AppSpacing.verticalSpaceMD,
        Text(
          'Please wait while we prepare your personalized dashboard',
          style: AppTextStyles.bodyLarge.copyWith(
            color: AppColors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildStepText() {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      child: Text(
        _setupSteps[_currentStep],
        key: ValueKey<int>(_currentStep),
        style: AppTextStyles.bodyLarge.copyWith(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w500,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildErrorState() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: AppColors.error.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.error_outline,
            size: 40,
            color: AppColors.error,
          ),
        ),
        AppSpacing.verticalSpaceXL,
        Text(
          'Setup Failed',
          style: AppTextStyles.headingLarge.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        AppSpacing.verticalSpaceMD,
        Text(
          _errorMessage,
          style: AppTextStyles.bodyLarge.copyWith(
            color: AppColors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
        AppSpacing.verticalSpaceXXXL,
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              Navigator.of(context).pushReplacementNamed(
                MainNavigationView.routeName,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryBlue,
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Go to Dashboard',
              style: AppTextStyles.buttonMedium,
            ),
          ),
        ),
      ],
    );
  }
}
