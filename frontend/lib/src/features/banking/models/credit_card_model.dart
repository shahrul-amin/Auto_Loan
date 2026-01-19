import 'package:freezed_annotation/freezed_annotation.dart';

part 'credit_card_model.freezed.dart';
part 'credit_card_model.g.dart';

@freezed
class CreditCard with _$CreditCard {
  const factory CreditCard({
    required String creditCardId,
    required String icNumber,
    required String bankId,
    required String accountReference,
    required String cardType,
    required double creditLimit,
    required double currentBalance,
    required double availableCredit,
    required DateTime issuedDate,
    required DateTime lastSyncedAt,
    @Default('Active') String status,
  }) = _CreditCard;

  factory CreditCard.fromJson(Map<String, dynamic> json) =>
      _$CreditCardFromJson(json);
}
