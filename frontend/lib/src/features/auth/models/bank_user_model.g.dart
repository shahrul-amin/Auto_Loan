// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bank_user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BankUserImpl _$$BankUserImplFromJson(Map<String, dynamic> json) =>
    _$BankUserImpl(
      bankId: json['bankId'] as String,
      username: json['username'] as String,
      passwordHash: json['passwordHash'] as String,
      icNumber: json['icNumber'] as String,
      accountNumber: json['accountNumber'] as String,
      isActive: json['isActive'] as bool? ?? true,
      lastLoginAt: json['lastLoginAt'] == null
          ? null
          : DateTime.parse(json['lastLoginAt'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$BankUserImplToJson(_$BankUserImpl instance) =>
    <String, dynamic>{
      'bankId': instance.bankId,
      'username': instance.username,
      'passwordHash': instance.passwordHash,
      'icNumber': instance.icNumber,
      'accountNumber': instance.accountNumber,
      'isActive': instance.isActive,
      'lastLoginAt': instance.lastLoginAt?.toIso8601String(),
      'createdAt': instance.createdAt.toIso8601String(),
    };
