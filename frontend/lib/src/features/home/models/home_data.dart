import 'package:freezed_annotation/freezed_annotation.dart';

part 'home_data.freezed.dart';
part 'home_data.g.dart';

@freezed
class HomeData with _$HomeData {
  const factory HomeData({
    required String userFirstName,
    required DateTime registrationDate,
    required int currentCreditScore,
    required List<CreditScoreUpdate> creditScoreHistory,
    required List<ExistingLoanSummary> existingLoans,
    required FinancialMetrics financialMetrics,
    required int activeLoansCount,
    required int totalApplicationsCount,
    required int approvedApplicationsCount,
  }) = _HomeData;

  factory HomeData.fromJson(Map<String, dynamic> json) =>
      _$HomeDataFromJson(json);
}

@freezed
class CreditScoreUpdate with _$CreditScoreUpdate {
  const factory CreditScoreUpdate({
    required DateTime date,
    required int score,
  }) = _CreditScoreUpdate;

  factory CreditScoreUpdate.fromJson(Map<String, dynamic> json) =>
      _$CreditScoreUpdateFromJson(json);
}

@freezed
class ExistingLoanSummary with _$ExistingLoanSummary {
  const factory ExistingLoanSummary({
    required String loanId,
    required String loanType,
    required double loanAmount,
    required double outstandingBalance,
    required double monthlyInstallment,
    required int remainingTenure,
    required DateTime startDate,
    required DateTime? nextPaymentDate,
  }) = _ExistingLoanSummary;

  factory ExistingLoanSummary.fromJson(Map<String, dynamic> json) =>
      _$ExistingLoanSummaryFromJson(json);
}

@freezed
class FinancialMetrics with _$FinancialMetrics {
  const factory FinancialMetrics({
    required double dsrPercentage,
    required bool ccrisGood,
    required double totalExistingCommitments,
    required Map<String, double>? dsrBreakdown,
    required String? ccrisDetails,
    required Map<String, double>? commitmentsBreakdown,
  }) = _FinancialMetrics;

  factory FinancialMetrics.fromJson(Map<String, dynamic> json) =>
      _$FinancialMetricsFromJson(json);
}
