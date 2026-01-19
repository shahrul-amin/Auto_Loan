// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$HomeDataImpl _$$HomeDataImplFromJson(Map<String, dynamic> json) =>
    _$HomeDataImpl(
      userFirstName: json['userFirstName'] as String,
      registrationDate: DateTime.parse(json['registrationDate'] as String),
      currentCreditScore: (json['currentCreditScore'] as num).toInt(),
      creditScoreHistory: (json['creditScoreHistory'] as List<dynamic>)
          .map((e) => CreditScoreUpdate.fromJson(e as Map<String, dynamic>))
          .toList(),
      existingLoans: (json['existingLoans'] as List<dynamic>)
          .map((e) => ExistingLoanSummary.fromJson(e as Map<String, dynamic>))
          .toList(),
      financialMetrics: FinancialMetrics.fromJson(
          json['financialMetrics'] as Map<String, dynamic>),
      activeLoansCount: (json['activeLoansCount'] as num).toInt(),
      totalApplicationsCount: (json['totalApplicationsCount'] as num).toInt(),
      approvedApplicationsCount:
          (json['approvedApplicationsCount'] as num).toInt(),
    );

Map<String, dynamic> _$$HomeDataImplToJson(_$HomeDataImpl instance) =>
    <String, dynamic>{
      'userFirstName': instance.userFirstName,
      'registrationDate': instance.registrationDate.toIso8601String(),
      'currentCreditScore': instance.currentCreditScore,
      'creditScoreHistory': instance.creditScoreHistory,
      'existingLoans': instance.existingLoans,
      'financialMetrics': instance.financialMetrics,
      'activeLoansCount': instance.activeLoansCount,
      'totalApplicationsCount': instance.totalApplicationsCount,
      'approvedApplicationsCount': instance.approvedApplicationsCount,
    };

_$CreditScoreUpdateImpl _$$CreditScoreUpdateImplFromJson(
        Map<String, dynamic> json) =>
    _$CreditScoreUpdateImpl(
      date: DateTime.parse(json['date'] as String),
      score: (json['score'] as num).toInt(),
    );

Map<String, dynamic> _$$CreditScoreUpdateImplToJson(
        _$CreditScoreUpdateImpl instance) =>
    <String, dynamic>{
      'date': instance.date.toIso8601String(),
      'score': instance.score,
    };

_$ExistingLoanSummaryImpl _$$ExistingLoanSummaryImplFromJson(
        Map<String, dynamic> json) =>
    _$ExistingLoanSummaryImpl(
      loanId: json['loanId'] as String,
      loanType: json['loanType'] as String,
      loanAmount: (json['loanAmount'] as num).toDouble(),
      outstandingBalance: (json['outstandingBalance'] as num).toDouble(),
      monthlyInstallment: (json['monthlyInstallment'] as num).toDouble(),
      remainingTenure: (json['remainingTenure'] as num).toInt(),
      startDate: DateTime.parse(json['startDate'] as String),
      nextPaymentDate: json['nextPaymentDate'] == null
          ? null
          : DateTime.parse(json['nextPaymentDate'] as String),
    );

Map<String, dynamic> _$$ExistingLoanSummaryImplToJson(
        _$ExistingLoanSummaryImpl instance) =>
    <String, dynamic>{
      'loanId': instance.loanId,
      'loanType': instance.loanType,
      'loanAmount': instance.loanAmount,
      'outstandingBalance': instance.outstandingBalance,
      'monthlyInstallment': instance.monthlyInstallment,
      'remainingTenure': instance.remainingTenure,
      'startDate': instance.startDate.toIso8601String(),
      'nextPaymentDate': instance.nextPaymentDate?.toIso8601String(),
    };

_$FinancialMetricsImpl _$$FinancialMetricsImplFromJson(
        Map<String, dynamic> json) =>
    _$FinancialMetricsImpl(
      dsrPercentage: (json['dsrPercentage'] as num).toDouble(),
      ccrisGood: json['ccrisGood'] as bool,
      totalExistingCommitments:
          (json['totalExistingCommitments'] as num).toDouble(),
      dsrBreakdown: (json['dsrBreakdown'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, (e as num).toDouble()),
      ),
      ccrisDetails: json['ccrisDetails'] as String?,
      commitmentsBreakdown:
          (json['commitmentsBreakdown'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, (e as num).toDouble()),
      ),
    );

Map<String, dynamic> _$$FinancialMetricsImplToJson(
        _$FinancialMetricsImpl instance) =>
    <String, dynamic>{
      'dsrPercentage': instance.dsrPercentage,
      'ccrisGood': instance.ccrisGood,
      'totalExistingCommitments': instance.totalExistingCommitments,
      'dsrBreakdown': instance.dsrBreakdown,
      'ccrisDetails': instance.ccrisDetails,
      'commitmentsBreakdown': instance.commitmentsBreakdown,
    };
