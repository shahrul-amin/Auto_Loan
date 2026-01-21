import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import '../models/home_data.dart';
import '../viewmodels/home_viewmodel.dart';
import '../../auth/viewmodels/auth_viewmodel.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/custom_refresh_indicator.dart';

class HomeView extends ConsumerWidget {
  const HomeView({super.key});

  static const routeName = '/home';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.read(authViewModelProvider.notifier).currentUser;

    if (user == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final homeDataAsync = ref.watch(homeViewModelProvider(user.icNumber));

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: homeDataAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error loading home data: $error'),
                  AppSpacing.verticalSpaceLG,
                  ElevatedButton(
                    onPressed: () =>
                        ref.refresh(homeViewModelProvider(user.icNumber)),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
            data: (homeData) => SlidingUpPanel(
              minHeight: MediaQuery.of(context).size.height * 0.35,
              maxHeight: MediaQuery.of(context).size.height * 0.8,
              backdropEnabled: true,
              backdropOpacity: 0.5,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(24),
              ),
              parallaxEnabled: true,
              parallaxOffset: 0.5,
              panel: _buildBottomPanel(context, homeData, ref, user.icNumber),
              body: _buildTopSection(context, homeData, ref, user.icNumber),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopSection(
      BuildContext context, HomeData homeData, WidgetRef ref, String userId) {
    return CustomRefreshIndicator(
      onRefresh: () async {
        ref.invalidate(homeViewModelProvider(userId));
        await Future.delayed(const Duration(milliseconds: 500));
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: AppSpacing.cardPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppSpacing.verticalSpaceLG,
            _buildFinancialHealthMetrics(context, homeData),
            AppSpacing.verticalSpaceXL,
            _buildExistingLoans(context, homeData),
            SizedBox(height: MediaQuery.of(context).size.height * 0.4),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomPanel(
      BuildContext context, HomeData homeData, WidgetRef ref, String userId) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/background.png'),
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: AppSpacing.cardPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: AppSpacing.lg),
                    decoration: BoxDecoration(
                      color: AppColors.textPrimary.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const Text(
                  'Reports',
                  style: AppTextStyles.headingLarge,
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildQuickStatsRow(context, homeData, ref, userId),
                  AppSpacing.verticalSpaceXL,
                  _buildCreditScoreChart(context, homeData, ref),
                  AppSpacing.verticalSpaceXL,
                  _buildPersonalizedInsight(homeData, ref, userId),
                  AppSpacing.verticalSpaceXL,
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStatsRow(
      BuildContext context, HomeData homeData, WidgetRef ref, String userId) {
    final successRate = ref
        .read(homeViewModelProvider(userId).notifier)
        .getLoanSuccessRate(homeData.totalApplicationsCount,
            homeData.approvedApplicationsCount);

    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            'Credit Score',
            homeData.currentCreditScore.toString(),
            Icons.credit_score,
          ),
        ),
        AppSpacing.horizontalSpaceMD,
        Expanded(
          child: _buildStatCard(
            'Active Loans',
            homeData.activeLoansCount.toString(),
            Icons.account_balance_wallet,
          ),
        ),
        AppSpacing.horizontalSpaceMD,
        Expanded(
          child: _buildStatCard(
            'Success Rate',
            '${successRate.toStringAsFixed(0)}%',
            Icons.trending_up,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon) {
    return GlassCard(
      child: Column(
        children: [
          Icon(icon, color: AppColors.textPrimary, size: 28),
          AppSpacing.verticalSpaceSM,
          Text(
            value,
            style: AppTextStyles.headingMedium,
          ),
          AppSpacing.verticalSpaceXS,
          Text(
            label,
            textAlign: TextAlign.center,
            style: AppTextStyles.labelMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildCreditScoreChart(
      BuildContext context, HomeData homeData, WidgetRef ref) {
    return GlassCard(
      padding: AppSpacing.screenPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Credit Score Progress',
                style: AppTextStyles.headingSmall,
              ),
            ],
          ),
          AppSpacing.verticalSpaceXL,
          SizedBox(
            height: 200,
            child: LineChart(
              _buildChartData(homeData.creditScoreHistory),
            ),
          ),
        ],
      ),
    );
  }

  LineChartData _buildChartData(List<CreditScoreUpdate> history) {
    if (history.isEmpty) {
      return LineChartData();
    }

    final spots = history.asMap().entries.map((entry) {
      return FlSpot(entry.key.toDouble(), entry.value.score.toDouble());
    }).toList();

    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        horizontalInterval: 100,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: AppColors.textPrimary.withOpacity(0.1),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles:
            const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval:
                history.length > 6 ? (history.length / 6).ceilToDouble() : 1,
            getTitlesWidget: (value, meta) {
              if (value.toInt() >= history.length) {
                return const SizedBox.shrink();
              }
              final date = history[value.toInt()].date;
              return Padding(
                padding: const EdgeInsets.only(top: AppSpacing.sm),
                child: Text(
                  DateFormat('MMM').format(date),
                  style: AppTextStyles.labelSmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              );
            },
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 100,
            reservedSize: 40,
            getTitlesWidget: (value, meta) {
              return Text(
                value.toInt().toString(),
                style: AppTextStyles.labelSmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              );
            },
          ),
        ),
      ),
      borderData: FlBorderData(show: false),
      minX: 0,
      maxX: (history.length - 1).toDouble(),
      minY: 300,
      maxY: 850,
      lineBarsData: [
        LineChartBarData(
          spots: spots,
          isCurved: true,
          color: AppColors.primaryBlueLight,
          barWidth: 3,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: true,
            getDotPainter: (spot, percent, barData, index) {
              return FlDotCirclePainter(
                radius: 4,
                color: AppColors.primaryBlueLight,
                strokeWidth: 2,
                strokeColor: AppColors.textPrimary,
              );
            },
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: [
                AppColors.primaryBlueLight.withOpacity(0.3),
                AppColors.primaryBlueLight.withOpacity(0.0),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPersonalizedInsight(
      HomeData homeData, WidgetRef ref, String userId) {
    final insight = ref
        .read(homeViewModelProvider(userId).notifier)
        .getPersonalizedInsight(homeData.creditScoreHistory);

    return GlassCard(
      padding: AppSpacing.screenPadding,
      child: Row(
        children: [
          const Icon(Icons.lightbulb, color: AppColors.textPrimary, size: 32),
          AppSpacing.horizontalSpaceLG,
          Expanded(
            child: Text(
              insight,
              style: AppTextStyles.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExistingLoans(BuildContext context, HomeData homeData) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Active Loans',
          style: AppTextStyles.headingMedium,
        ),
        AppSpacing.verticalSpaceLG,
        if (homeData.existingLoans.isEmpty)
          GlassCard(
            padding: const EdgeInsets.all(AppSpacing.xxl),
            child: Center(
              child: Column(
                children: [
                  const Icon(
                    Icons.account_balance_wallet,
                    size: 48,
                    color: AppColors.textPrimary,
                  ),
                  AppSpacing.verticalSpaceLG,
                  Text(
                    'No active loans',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          )
        else
          SizedBox(
            height: 200,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: homeData.existingLoans.length,
              itemBuilder: (context, index) {
                final loan = homeData.existingLoans[index];
                return Container(
                  width: 280,
                  margin: EdgeInsets.only(
                    right: index < homeData.existingLoans.length - 1
                        ? AppSpacing.md
                        : 0,
                  ),
                  child: _buildExistingLoanCard(context, loan),
                );
              },
            ),
          ),
      ],
    );
  }

  Widget _buildExistingLoanCard(
      BuildContext context, ExistingLoanSummary loan) {
    final remainingPercentage = loan.outstandingBalance / loan.loanAmount;

    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            loan.loanType,
            style: AppTextStyles.bodyLarge.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          AppSpacing.verticalSpaceSM,
          Text(
            'RM ${NumberFormat('#,##0.00').format(loan.outstandingBalance)}',
            style: AppTextStyles.headingMedium.copyWith(
              color: AppColors.primaryBlueLight,
            ),
          ),
          AppSpacing.verticalSpaceXS,
          Text(
            'of RM ${NumberFormat('#,##0.00').format(loan.loanAmount)}',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          AppSpacing.verticalSpaceMD,
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: 1 - remainingPercentage,
              backgroundColor: AppColors.textPrimary.withOpacity(0.1),
              valueColor: AlwaysStoppedAnimation<Color>(
                remainingPercentage > 0.5
                    ? AppColors.warning
                    : AppColors.success,
              ),
              minHeight: 8,
            ),
          ),
          AppSpacing.verticalSpaceMD,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Monthly',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textTertiary,
                    ),
                  ),
                  Text(
                    'RM ${NumberFormat('#,##0').format(loan.monthlyInstallment)}',
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Remaining',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textTertiary,
                    ),
                  ),
                  Text(
                    '${loan.remainingTenure} months',
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFinancialHealthMetrics(BuildContext context, HomeData homeData) {
    final metrics = homeData.financialMetrics;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Financial Health Metrics',
          style: AppTextStyles.headingMedium,
        ),
        AppSpacing.verticalSpaceLG,
        Row(
          children: [
            Expanded(
              child: _buildMetricCard(
                context,
                'DSR',
                '${metrics.dsrPercentage.toStringAsFixed(1)}%',
                () => _showDsrModal(context, metrics),
              ),
            ),
            AppSpacing.horizontalSpaceMD,
            Expanded(
              child: _buildMetricCard(
                context,
                'CCRIS',
                metrics.ccrisGood ? 'Good' : 'Bad',
                () => _showCcrisModal(context, metrics),
              ),
            ),
            AppSpacing.horizontalSpaceMD,
            Expanded(
              child: _buildMetricCard(
                context,
                'Commitment',
                'RM ${NumberFormat('#,##0').format(metrics.totalExistingCommitments)}',
                () => _showCommitmentsModal(context, metrics),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMetricCard(
    BuildContext context,
    String label,
    String value,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: GlassCard(
        child: Column(
          children: [
            Text(
              label,
              textAlign: TextAlign.center,
              style: AppTextStyles.labelMedium.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            AppSpacing.verticalSpaceSM,
            Text(
              value,
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyLarge.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDsrModal(BuildContext context, FinancialMetrics metrics) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Debt Service Ratio (DSR)',
              style: AppTextStyles.headingMedium,
            ),
            AppSpacing.verticalSpaceLG,
            if (metrics.dsrBreakdown != null)
              ...metrics.dsrBreakdown!.entries.map((entry) => Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: AppSpacing.xs),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          entry.key,
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                        Text(
                          entry.key.toLowerCase().contains('dsr') ||
                                  entry.key.toLowerCase().contains('percentage')
                              ? '${entry.value.toStringAsFixed(1)}%'
                              : 'RM ${NumberFormat('#,##0.00').format(entry.value)}',
                          style: AppTextStyles.bodyMedium.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  )),
            AppSpacing.verticalSpaceLG,
            Text(
              'Your DSR is ${metrics.dsrPercentage.toStringAsFixed(1)}%. '
              '${metrics.dsrPercentage <= 40 ? 'Good! You have healthy debt levels.' : metrics.dsrPercentage <= 60 ? 'Moderate. Consider reducing commitments.' : 'High risk. Reduce debt urgently.'}',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCcrisModal(BuildContext context, FinancialMetrics metrics) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'CCRIS Status',
              style: AppTextStyles.headingMedium,
            ),
            AppSpacing.verticalSpaceLG,
            Row(
              children: [
                Icon(
                  metrics.ccrisGood ? Icons.check_circle : Icons.cancel,
                  color: AppColors.textPrimary,
                  size: 32,
                ),
                AppSpacing.horizontalSpaceMD,
                Expanded(
                  child: Text(
                    metrics.ccrisGood ? 'Good Standing' : 'Issues Detected',
                    style: AppTextStyles.headingSmall,
                  ),
                ),
              ],
            ),
            AppSpacing.verticalSpaceLG,
            Text(
              metrics.ccrisDetails ?? 'No additional details available.',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCommitmentsModal(BuildContext context, FinancialMetrics metrics) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Total Existing Commitments',
              style: AppTextStyles.headingMedium,
            ),
            AppSpacing.verticalSpaceLG,
            if (metrics.commitmentsBreakdown != null)
              ...metrics.commitmentsBreakdown!.entries.map((entry) => Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: AppSpacing.xs),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          entry.key,
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                        Text(
                          'RM ${NumberFormat('#,##0.00').format(entry.value)}',
                          style: AppTextStyles.bodyMedium.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  )),
            const Divider(height: 24, color: Colors.white24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total',
                  style: AppTextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'RM ${NumberFormat('#,##0.00').format(metrics.totalExistingCommitments)}',
                  style: AppTextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryBlueLight,
                  ),
                ),
              ],
            ),
          ],
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
                AppColors.primaryBlueLight.withOpacity(0.3),
                AppColors.primaryBlueDark.withOpacity(0.3),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppColors.textPrimary.withOpacity(0.2),
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
