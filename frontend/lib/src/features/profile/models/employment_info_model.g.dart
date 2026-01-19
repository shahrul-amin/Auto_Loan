// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'employment_info_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$EmploymentInfoImpl _$$EmploymentInfoImplFromJson(Map<String, dynamic> json) =>
    _$EmploymentInfoImpl(
      icNumber: json['icNumber'] as String,
      employerName: json['employerName'] as String,
      position: json['position'] as String,
      employmentType: json['employmentType'] as String,
      monthlyIncome: (json['monthlyIncome'] as num).toDouble(),
      employmentStartDate:
          DateTime.parse(json['employmentStartDate'] as String),
      industry: json['industry'] as String,
      employerPhone: json['employerPhone'] as String?,
      employerAddress: json['employerAddress'] as String?,
      epfMonthlyContribution:
          (json['epfMonthlyContribution'] as num?)?.toDouble() ?? 0.0,
      epfBalance: (json['epfBalance'] as num?)?.toDouble() ?? 0.0,
    );

Map<String, dynamic> _$$EmploymentInfoImplToJson(
        _$EmploymentInfoImpl instance) =>
    <String, dynamic>{
      'icNumber': instance.icNumber,
      'employerName': instance.employerName,
      'position': instance.position,
      'employmentType': instance.employmentType,
      'monthlyIncome': instance.monthlyIncome,
      'employmentStartDate': instance.employmentStartDate.toIso8601String(),
      'industry': instance.industry,
      'employerPhone': instance.employerPhone,
      'employerAddress': instance.employerAddress,
      'epfMonthlyContribution': instance.epfMonthlyContribution,
      'epfBalance': instance.epfBalance,
    };
