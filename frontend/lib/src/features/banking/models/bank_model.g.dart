// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bank_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BankImpl _$$BankImplFromJson(Map<String, dynamic> json) => _$BankImpl(
      bankId: json['bankId'] as String,
      bankName: json['bankName'] as String,
      code: json['code'] as String,
      bankLogoUrl: json['bankLogoUrl'] as String,
      primaryColor: json['primaryColor'] as String,
      secondaryColor: json['secondaryColor'] as String,
      onlineBankingName: json['onlineBankingName'] as String,
      websiteUrl: json['websiteUrl'] as String,
      isActive: json['isActive'] as bool? ?? true,
    );

Map<String, dynamic> _$$BankImplToJson(_$BankImpl instance) =>
    <String, dynamic>{
      'bankId': instance.bankId,
      'bankName': instance.bankName,
      'code': instance.code,
      'bankLogoUrl': instance.bankLogoUrl,
      'primaryColor': instance.primaryColor,
      'secondaryColor': instance.secondaryColor,
      'onlineBankingName': instance.onlineBankingName,
      'websiteUrl': instance.websiteUrl,
      'isActive': instance.isActive,
    };
