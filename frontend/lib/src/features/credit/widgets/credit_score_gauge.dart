import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import '../models/credit_score_model.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';

class _ScoreRange {
  final String label;
  final int minScore;
  final int maxScore;
  final Color color;

  const _ScoreRange({
    required this.label,
    required this.minScore,
    required this.maxScore,
    required this.color,
  });

  bool containsScore(int score) => score >= minScore && score <= maxScore;
}

class CreditScoreGauge extends StatelessWidget {
  const CreditScoreGauge({
    required this.creditScore,
    super.key,
  });

  final CreditScoreModel creditScore;

  static const List<_ScoreRange> _scoreRanges = [
    _ScoreRange(
      label: 'Poor',
      minScore: 0,
      maxScore: 579,
      color: AppColors.error,
    ),
    _ScoreRange(
      label: 'Fair',
      minScore: 580,
      maxScore: 669,
      color: AppColors.warning,
    ),
    _ScoreRange(
      label: 'Good',
      minScore: 670,
      maxScore: 739,
      color: AppColors.info,
    ),
    _ScoreRange(
      label: 'Very Good',
      minScore: 740,
      maxScore: 799,
      color: AppColors.success,
    ),
    _ScoreRange(
      label: 'Excellent',
      minScore: 800,
      maxScore: 850,
      color: AppColors.success,
    ),
  ];

  _ScoreRange get _currentRange => _scoreRanges
      .firstWhere((range) => range.containsScore(creditScore.score));

  Color get _categoryColor => _currentRange.color;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: _categoryColor.withOpacity(0.15),
                blurRadius: 20,
                spreadRadius: 3,
              ),
            ],
          ),
          child: SizedBox(
            height: 300,
            child: SfRadialGauge(
              axes: <RadialAxis>[
                RadialAxis(
                  minimum: 0,
                  maximum: 850,
                  startAngle: 135,
                  endAngle: 45,
                  showLabels: false,
                  showTicks: false,
                  axisLineStyle: const AxisLineStyle(
                    thickness: 0.15,
                    cornerStyle: CornerStyle.bothCurve,
                    thicknessUnit: GaugeSizeUnit.factor,
                  ),
                  pointers: <GaugePointer>[
                    RangePointer(
                      value: creditScore.score.toDouble(),
                      width: 0.15,
                      sizeUnit: GaugeSizeUnit.factor,
                      cornerStyle: CornerStyle.bothCurve,
                      gradient: SweepGradient(
                        colors: [
                          _categoryColor.withOpacity(0.6),
                          _categoryColor,
                          _categoryColor,
                        ],
                        stops: const [0.0, 0.5, 1.0],
                      ),
                    ),
                  ],
                  annotations: <GaugeAnnotation>[
                    GaugeAnnotation(
                      widget: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: '${creditScore.score}',
                                  style: const TextStyle(
                                    fontSize: 64,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textPrimary,
                                    fontFamily: 'Inter',
                                  ),
                                ),
                                TextSpan(
                                  text: ' / 850',
                                  style: AppTextStyles.headingMedium.copyWith(
                                    color: AppColors.textSecondary
                                        .withOpacity(0.7),
                                    fontFamily: 'Inter',
                                  ),
                                ),
                              ],
                            ),
                          ),
                          AppSpacing.verticalSpaceMD,
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: _categoryColor.withOpacity(0.25),
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(
                                color: _categoryColor,
                                width: 2,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: _categoryColor.withOpacity(0.12),
                                  blurRadius: 4,
                                  spreadRadius: 1,
                                ),
                              ],
                            ),
                            child: Text(
                              creditScore.category.displayName,
                              style: AppTextStyles.bodyLarge.copyWith(
                                fontWeight: FontWeight.bold,
                                color: _categoryColor,
                                fontFamily: 'Inter',
                              ),
                            ),
                          ),
                        ],
                      ),
                      angle: 90,
                      positionFactor: 0.1,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        AppSpacing.verticalSpaceXL,
        _buildScoreRangeBar(creditScore.score),
        AppSpacing.verticalSpaceLG,
        Text(
          'Last Updated: ${_formatDate(creditScore.lastUpdated)}',
          style: AppTextStyles.labelLarge.copyWith(
            color: AppColors.textSecondary.withOpacity(0.8),
            fontFamily: 'Inter',
          ),
        ),
      ],
    );
  }

  Widget _buildScoreRangeBar(int score) {
    return Column(
      children: [
        Row(
          children: _scoreRanges
              .map((range) => [
                    _buildRangeSegment(
                      range.label,
                      range.minScore,
                      range.maxScore,
                      score,
                      range.color,
                    ),
                    if (range != _scoreRanges.last)
                      AppSpacing.horizontalSpaceXS,
                  ])
              .expand((widgets) => widgets)
              .toList(),
        ),
        AppSpacing.verticalSpaceSM,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [300, 580, 670, 740, 800, 850]
              .map((boundary) => Text(
                    '$boundary',
                    style: AppTextStyles.labelMedium.copyWith(
                      color: AppColors.textSecondary,
                      fontFamily: 'Inter',
                    ),
                  ))
              .toList(),
        ),
      ],
    );
  }

  Widget _buildRangeSegment(
      String label, int min, int max, int score, Color color) {
    final isInRange = score >= min && score <= max;
    return Expanded(
      child: Column(
        children: [
          Container(
            height: 8,
            decoration: BoxDecoration(
              color: isInRange ? color : color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(4),
              border: isInRange ? Border.all(color: color, width: 2) : null,
              boxShadow: isInRange
                  ? [
                      BoxShadow(
                        color: color.withOpacity(0.4),
                        blurRadius: 8,
                        spreadRadius: 1,
                      ),
                    ]
                  : null,
            ),
          ),
          AppSpacing.verticalSpaceXS,
          Text(
            label,
            textAlign: TextAlign.center,
            style: AppTextStyles.labelSmall.copyWith(
              fontWeight: isInRange ? FontWeight.bold : FontWeight.normal,
              color:
                  isInRange ? color : AppColors.textTertiary.withOpacity(0.6),
              fontFamily: 'Inter',
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}
