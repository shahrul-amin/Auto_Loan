import 'package:freezed_annotation/freezed_annotation.dart';

part 'credit_card_model.freezed.dart';
part 'credit_card_model.g.dart';

@freezed
class CreditCardModel with _$CreditCardModel {
  const factory CreditCardModel({
    required String id,
    required String cardNumber,
    required String maskedCardNumber,
    required String bankId,
    required String bankName,
    required String bankLogoUrl,
    required String primaryColor,
    required CreditCardType cardScheme,
    required double currentBalance,
    required double creditLimit,
    required double availableCredit,
  }) = _CreditCardModel;

  factory CreditCardModel.fromJson(Map<String, dynamic> json) =>
      _$CreditCardModelFromJson(json);
}

enum CreditCardType {
  @JsonValue('visa')
  visa,
  @JsonValue('mastercard')
  mastercard,
  @JsonValue('amex')
  amex,
}

extension CreditCardModelExtension on CreditCardModel {
  double get utilizationPercentage {
    if (creditLimit == 0) return 0;
    return (currentBalance / creditLimit) * 100;
  }

  bool get isOverLimit => currentBalance > creditLimit;

  bool get isHighUtilization => utilizationPercentage > 70;
}

extension CreditCardTypeExtension on CreditCardType {
  String get displayName {
    switch (this) {
      case CreditCardType.visa:
        return 'Visa';
      case CreditCardType.mastercard:
        return 'Mastercard';
      case CreditCardType.amex:
        return 'American Express';
    }
  }
}
