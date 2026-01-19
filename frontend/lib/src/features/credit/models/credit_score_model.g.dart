// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'credit_score_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CreditScoreModelImpl _$$CreditScoreModelImplFromJson(
        Map<String, dynamic> json) =>
    _$CreditScoreModelImpl(
      score: (json['score'] as num).toInt(),
      category: $enumDecode(_$CreditScoreCategoryEnumMap, json['category']),
      lastUpdated: DateTime.parse(json['lastUpdated'] as String),
    );

Map<String, dynamic> _$$CreditScoreModelImplToJson(
        _$CreditScoreModelImpl instance) =>
    <String, dynamic>{
      'score': instance.score,
      'category': _$CreditScoreCategoryEnumMap[instance.category]!,
      'lastUpdated': instance.lastUpdated.toIso8601String(),
    };

const _$CreditScoreCategoryEnumMap = {
  CreditScoreCategory.poor: 'Poor',
  CreditScoreCategory.fair: 'Fair',
  CreditScoreCategory.good: 'Good',
  CreditScoreCategory.veryGood: 'Very Good',
  CreditScoreCategory.excellent: 'Excellent',
};
