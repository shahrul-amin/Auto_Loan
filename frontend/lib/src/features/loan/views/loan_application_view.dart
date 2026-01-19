import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../auth/viewmodels/auth_viewmodel.dart';
import '../models/loan_application_form.dart';
import 'loan_application_step1_personal.dart';
import 'loan_application_step2_employment.dart';
import 'loan_application_step3_details.dart';

final loanApplicationStepProvider = StateProvider<int>((ref) => 0);
final loanApplicationFormProvider =
    StateProvider<LoanApplicationForm>((ref) => LoanApplicationForm.empty());

class LoanApplicationView extends ConsumerStatefulWidget {
  const LoanApplicationView({super.key});

  static const routeName = '/loan/apply';

  @override
  ConsumerState<LoanApplicationView> createState() =>
      _LoanApplicationViewState();
}

class _LoanApplicationViewState extends ConsumerState<LoanApplicationView>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();

    // Reset step and form to ensure fresh start every time
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(loanApplicationStepProvider.notifier).state = 0;
      ref.read(loanApplicationFormProvider.notifier).state =
          LoanApplicationForm.empty();
    });

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _colorAnimation = TweenSequence<Color?>([
      TweenSequenceItem(
        tween: ColorTween(
          begin: AppColors.primaryBlueLighter,
          end: AppColors.primaryBlue,
        ),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: ColorTween(
          begin: AppColors.primaryBlue,
          end: AppColors.primaryBlueDark,
        ),
        weight: 1,
      ),
    ]).animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    // Reset step and form so reopening starts at first step with clean state
    ref.read(loanApplicationStepProvider.notifier).state = 0;
    ref.read(loanApplicationFormProvider.notifier).state =
        LoanApplicationForm.empty();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentStep = ref.watch(loanApplicationStepProvider);
    final authState = ref.watch(authViewModelProvider);

    return authState.maybeWhen(
      authenticated: (user) {
        return Scaffold(
          body: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/background.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.surface.withOpacity(0.85),
              ),
              child: SafeArea(
                child: Column(
                  children: [
                    _buildHeader(context, ref, currentStep),
                    _buildProgressIndicator(currentStep),
                    Expanded(
                      child:
                          _buildStep(context, ref, currentStep, user.icNumber),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
      orElse: () => const Scaffold(
        body: Center(
          child: CircularProgressIndicator(color: AppColors.primaryBlue),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, WidgetRef ref, int currentStep) {
    return Container(
      padding: AppSpacing.screenPadding,
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              if (currentStep > 0) {
                ref.read(loanApplicationStepProvider.notifier).state =
                    currentStep - 1;
              } else {
                Navigator.of(context).pop();
              }
            },
            icon: const Icon(
              Icons.arrow_back_ios_rounded,
              color: AppColors.textPrimary,
            ),
          ),
          AppSpacing.horizontalSpaceSM,
          Expanded(
            child: Text(
              'Loan Application',
              style: AppTextStyles.headingLarge.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator(int currentStep) {
    return Padding(
      padding: AppSpacing.screenPadding,
      child: Row(
        children: List.generate(
          3,
          (index) => Expanded(
            child: AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return Container(
                  height: 6,
                  margin: EdgeInsets.only(
                    right: index < 2 ? 8 : 0,
                  ),
                  decoration: BoxDecoration(
                    color: index <= currentStep
                        ? _colorAnimation.value
                        : AppColors.surfaceVariant,
                    borderRadius: BorderRadius.circular(3),
                    boxShadow: index <= currentStep
                        ? [
                            BoxShadow(
                              color: (_colorAnimation.value ??
                                      AppColors.primaryBlue)
                                  .withOpacity(0.5),
                              blurRadius: 8,
                              spreadRadius: 1,
                            ),
                          ]
                        : null,
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStep(
      BuildContext context, WidgetRef ref, int currentStep, String icNumber) {
    switch (currentStep) {
      case 0:
        return LoanApplicationStep1Personal(icNumber: icNumber);
      case 1:
        return LoanApplicationStep2Employment(icNumber: icNumber);
      case 2:
        return LoanApplicationStep3Details(icNumber: icNumber);
      default:
        return const SizedBox();
    }
  }
}
