// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'credit_card_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CreditCardModelImpl _$$CreditCardModelImplFromJson(
        Map<String, dynamic> json) =>
    _$CreditCardModelImpl(
      id: json['id'] as String,
      cardNumber: json['cardNumber'] as String,
      maskedCardNumber: json['maskedCardNumber'] as String,
      bankId: json['bankId'] as String,
      bankName: json['bankName'] as String,
      bankLogoUrl: json['bankLogoUrl'] as String,
      primaryColor: json['primaryColor'] as String,
      cardScheme: $enumDecode(_$CreditCardTypeEnumMap, json['cardScheme']),
      currentBalance: (json['currentBalance'] as num).toDouble(),
      creditLimit: (json['creditLimit'] as num).toDouble(),
      availableCredit: (json['availableCredit'] as num).toDouble(),
    );

Map<String, dynamic> _$$CreditCardModelImplToJson(
        _$CreditCardModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'cardNumber': instance.cardNumber,
      'maskedCardNumber': instance.maskedCardNumber,
      'bankId': instance.bankId,
      'bankName': instance.bankName,
      'bankLogoUrl': instance.bankLogoUrl,
      'primaryColor': instance.primaryColor,
      'cardScheme': _$CreditCardTypeEnumMap[instance.cardScheme]!,
      'currentBalance': instance.currentBalance,
      'creditLimit': instance.creditLimit,
      'availableCredit': instance.availableCredit,
    };

const _$CreditCardTypeEnumMap = {
  CreditCardType.visa: 'visa',
  CreditCardType.mastercard: 'mastercard',
  CreditCardType.amex: 'amex',
};
