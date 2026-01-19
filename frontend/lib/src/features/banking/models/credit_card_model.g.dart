// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'credit_card_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CreditCardImpl _$$CreditCardImplFromJson(Map<String, dynamic> json) =>
    _$CreditCardImpl(
      creditCardId: json['creditCardId'] as String,
      icNumber: json['icNumber'] as String,
      bankId: json['bankId'] as String,
      accountReference: json['accountReference'] as String,
      cardType: json['cardType'] as String,
      creditLimit: (json['creditLimit'] as num).toDouble(),
      currentBalance: (json['currentBalance'] as num).toDouble(),
      availableCredit: (json['availableCredit'] as num).toDouble(),
      issuedDate: DateTime.parse(json['issuedDate'] as String),
      lastSyncedAt: DateTime.parse(json['lastSyncedAt'] as String),
      status: json['status'] as String? ?? 'Active',
    );

Map<String, dynamic> _$$CreditCardImplToJson(_$CreditCardImpl instance) =>
    <String, dynamic>{
      'creditCardId': instance.creditCardId,
      'icNumber': instance.icNumber,
      'bankId': instance.bankId,
      'accountReference': instance.accountReference,
      'cardType': instance.cardType,
      'creditLimit': instance.creditLimit,
      'currentBalance': instance.currentBalance,
      'availableCredit': instance.availableCredit,
      'issuedDate': instance.issuedDate.toIso8601String(),
      'lastSyncedAt': instance.lastSyncedAt.toIso8601String(),
      'status': instance.status,
    };
