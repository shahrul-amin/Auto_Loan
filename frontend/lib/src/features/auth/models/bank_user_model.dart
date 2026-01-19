import 'package:freezed_annotation/freezed_annotation.dart';

part 'bank_user_model.freezed.dart';
part 'bank_user_model.g.dart';

@freezed
class BankUser with _$BankUser {
  const factory BankUser({
    required String bankId,
    required String username,
    required String passwordHash,
    required String icNumber,
    required String accountNumber,
    @Default(true) bool isActive,
    DateTime? lastLoginAt,
    required DateTime createdAt,
  }) = _BankUser;

  factory BankUser.fromJson(Map<String, dynamic> json) =>
      _$BankUserFromJson(json);
}
