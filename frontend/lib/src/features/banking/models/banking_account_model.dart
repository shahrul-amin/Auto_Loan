import 'package:freezed_annotation/freezed_annotation.dart';

part 'banking_account_model.freezed.dart';
part 'banking_account_model.g.dart';

@freezed
class BankingAccount with _$BankingAccount {
  const factory BankingAccount({
    required String icNumber,
    required String bankId,
    required String accountNumber,
    required String accountType,
    required String registeredPhone,
    required String registeredEmail,
    required double currentAccountBalance,
    required double savingsAccountBalance,
    @Default(0.0) double fixedDepositBalance,
    @Default(0.0) double investmentBalance,
    required double averageMonthlyBalance,
    required DateTime lastSyncedAt,
    required DateTime createdAt,
  }) = _BankingAccount;

  factory BankingAccount.fromJson(Map<String, dynamic> json) =>
      _$BankingAccountFromJson(json);
}
