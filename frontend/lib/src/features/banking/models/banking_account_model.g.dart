// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'banking_account_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BankingAccountImpl _$$BankingAccountImplFromJson(Map<String, dynamic> json) =>
    _$BankingAccountImpl(
      icNumber: json['icNumber'] as String,
      bankId: json['bankId'] as String,
      accountNumber: json['accountNumber'] as String,
      accountType: json['accountType'] as String,
      registeredPhone: json['registeredPhone'] as String,
      registeredEmail: json['registeredEmail'] as String,
      currentAccountBalance: (json['currentAccountBalance'] as num).toDouble(),
      savingsAccountBalance: (json['savingsAccountBalance'] as num).toDouble(),
      fixedDepositBalance:
          (json['fixedDepositBalance'] as num?)?.toDouble() ?? 0.0,
      investmentBalance: (json['investmentBalance'] as num?)?.toDouble() ?? 0.0,
      averageMonthlyBalance: (json['averageMonthlyBalance'] as num).toDouble(),
      lastSyncedAt: DateTime.parse(json['lastSyncedAt'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$BankingAccountImplToJson(
        _$BankingAccountImpl instance) =>
    <String, dynamic>{
      'icNumber': instance.icNumber,
      'bankId': instance.bankId,
      'accountNumber': instance.accountNumber,
      'accountType': instance.accountType,
      'registeredPhone': instance.registeredPhone,
      'registeredEmail': instance.registeredEmail,
      'currentAccountBalance': instance.currentAccountBalance,
      'savingsAccountBalance': instance.savingsAccountBalance,
      'fixedDepositBalance': instance.fixedDepositBalance,
      'investmentBalance': instance.investmentBalance,
      'averageMonthlyBalance': instance.averageMonthlyBalance,
      'lastSyncedAt': instance.lastSyncedAt.toIso8601String(),
      'createdAt': instance.createdAt.toIso8601String(),
    };
