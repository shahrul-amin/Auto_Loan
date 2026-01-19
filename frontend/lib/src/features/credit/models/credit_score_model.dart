import 'package:freezed_annotation/freezed_annotation.dart';

part 'credit_score_model.freezed.dart';
part 'credit_score_model.g.dart';

@freezed
class CreditScoreModel with _$CreditScoreModel {
  const factory CreditScoreModel({
    required int score,
    required CreditScoreCategory category,
    required DateTime lastUpdated,
  }) = _CreditScoreModel;

  factory CreditScoreModel.fromJson(Map<String, dynamic> json) =>
      _$CreditScoreModelFromJson(json);
}

enum CreditScoreCategory {
  @JsonValue('Poor')
  poor,
  @JsonValue('Fair')
  fair,
  @JsonValue('Good')
  good,
  @JsonValue('Very Good')
  veryGood,
  @JsonValue('Excellent')
  excellent,
}

extension CreditScoreCategoryExtension on CreditScoreCategory {
  String get displayName {
    switch (this) {
      case CreditScoreCategory.poor:
        return 'Poor';
      case CreditScoreCategory.fair:
        return 'Fair';
      case CreditScoreCategory.good:
        return 'Good';
      case CreditScoreCategory.veryGood:
        return 'Very Good';
      case CreditScoreCategory.excellent:
        return 'Excellent';
    }
  }

  int get minScore {
    switch (this) {
      case CreditScoreCategory.poor:
        return 0;
      case CreditScoreCategory.fair:
        return 580;
      case CreditScoreCategory.good:
        return 670;
      case CreditScoreCategory.veryGood:
        return 740;
      case CreditScoreCategory.excellent:
        return 800;
    }
  }

  int get maxScore {
    switch (this) {
      case CreditScoreCategory.poor:
        return 579;
      case CreditScoreCategory.fair:
        return 669;
      case CreditScoreCategory.good:
        return 739;
      case CreditScoreCategory.veryGood:
        return 799;
      case CreditScoreCategory.excellent:
        return 850;
    }
  }

  static CreditScoreCategory fromScore(int score) {
    if (score >= 800) return CreditScoreCategory.excellent;
    if (score >= 740) return CreditScoreCategory.veryGood;
    if (score >= 670) return CreditScoreCategory.good;
    if (score >= 580) return CreditScoreCategory.fair;
    return CreditScoreCategory.poor;
  }
}
