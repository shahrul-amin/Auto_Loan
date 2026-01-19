import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'bank_model.freezed.dart';
part 'bank_model.g.dart';

@freezed
class Bank with _$Bank {
  const factory Bank({
    required String bankId,
    required String bankName,
    required String code,
    required String bankLogoUrl,
    required String primaryColor,
    required String secondaryColor,
    required String onlineBankingName,
    required String websiteUrl,
    @Default(true) bool isActive,
  }) = _Bank;

  factory Bank.fromJson(Map<String, dynamic> json) => _$BankFromJson(json);
}

extension BankX on Bank {
  Color get brandColor {
    return Color(int.parse(primaryColor));
  }

  String get logoAsset => bankLogoUrl;
  String get name => bankName;
  String get id => bankId;
  bool get isAvailable => isActive;
}
