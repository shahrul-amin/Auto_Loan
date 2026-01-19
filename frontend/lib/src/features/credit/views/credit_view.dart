import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/credit_score_model.dart';
import '../models/credit_card_model.dart';
import '../providers/credit_providers.dart';
import '../widgets/credit_score_gauge.dart';
import '../widgets/stackable_credit_cards.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../auth/viewmodels/auth_viewmodel.dart';
import '../../../core/widgets/custom_refresh_indicator.dart';

class CreditView extends ConsumerWidget {
  const CreditView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authViewModelProvider);

    return authState.maybeWhen(
      authenticated: (user) {
        final creditOverviewAsync =
            ref.watch(creditOverviewProvider(user.icNumber));

        return Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: const Text(
              'Credit Score',
              style: TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w600,
              ),
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          body: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/background.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: SafeArea(
              child: creditOverviewAsync.when(
                loading: () => const SizedBox.shrink(),
                error: (error, stack) => Center(
                  child: Padding(
                    padding: AppSpacing.screenPadding,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          color: AppColors.error,
                          size: 64,
                        ),
                        AppSpacing.verticalSpaceLG,
                        Text(
                          'Failed to load credit data',
                          style: AppTextStyles.headingSmall.copyWith(
                            color: AppColors.textPrimary,
                          ),
                        ),
                        AppSpacing.verticalSpaceSM,
                        Text(
                          error.toString(),
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.textSecondary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        AppSpacing.verticalSpaceXL,
                        ElevatedButton(
                          onPressed: () {
                            ref.invalidate(
                                creditOverviewProvider(user.icNumber));
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryBlue,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 32,
                              vertical: 16,
                            ),
                          ),
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                ),
                data: (overview) {
                  final creditScore =
                      overview['creditScore'] as CreditScoreModel;
                  final creditCards =
                      overview['creditCards'] as List<CreditCardModel>;

                  return CustomRefreshIndicator(
                    onRefresh: () async {
                      ref.invalidate(creditOverviewProvider(user.icNumber));
                      await Future.delayed(const Duration(milliseconds: 500));
                    },
                    child: ListView(
                      padding: AppSpacing.cardPadding,
                      children: [
                        GlassCard(
                          padding: AppSpacing.screenPadding,
                          child: CreditScoreGauge(creditScore: creditScore),
                        ),
                        AppSpacing.verticalSpaceXL,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Credit Cards',
                              style: AppTextStyles.headingMedium.copyWith(
                                color: Colors.white,
                                fontFamily: 'Inter',
                              ),
                            ),
                            Text(
                              '${creditCards.length} Cards',
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: Colors.white.withOpacity(0.7),
                                fontFamily: 'Inter',
                              ),
                            ),
                          ],
                        ),
                        AppSpacing.verticalSpaceMD,
                        SizedBox(
                          height: 200,
                          child: StackableCreditCards(
                            cards: creditCards,
                            onCardTap: (index) {},
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
      orElse: () => const Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            color: AppColors.primaryBlue,
          ),
        ),
      ),
    );
  }
}

class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;

  const GlassCard({
    super.key,
    required this.child,
    this.padding = AppSpacing.cardPadding,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.background.withOpacity(0.5),
                AppColors.primaryBlueDark,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.white.withOpacity(0.2),
              width: 1,
            ),
          ),
          padding: padding,
          child: child,
        ),
      ),
    );
  }
}
