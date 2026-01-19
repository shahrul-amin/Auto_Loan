// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'home_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

HomeData _$HomeDataFromJson(Map<String, dynamic> json) {
  return _HomeData.fromJson(json);
}

/// @nodoc
mixin _$HomeData {
  String get userFirstName => throw _privateConstructorUsedError;
  DateTime get registrationDate => throw _privateConstructorUsedError;
  int get currentCreditScore => throw _privateConstructorUsedError;
  List<CreditScoreUpdate> get creditScoreHistory =>
      throw _privateConstructorUsedError;
  List<ExistingLoanSummary> get existingLoans =>
      throw _privateConstructorUsedError;
  FinancialMetrics get financialMetrics => throw _privateConstructorUsedError;
  int get activeLoansCount => throw _privateConstructorUsedError;
  int get totalApplicationsCount => throw _privateConstructorUsedError;
  int get approvedApplicationsCount => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $HomeDataCopyWith<HomeData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HomeDataCopyWith<$Res> {
  factory $HomeDataCopyWith(HomeData value, $Res Function(HomeData) then) =
      _$HomeDataCopyWithImpl<$Res, HomeData>;
  @useResult
  $Res call(
      {String userFirstName,
      DateTime registrationDate,
      int currentCreditScore,
      List<CreditScoreUpdate> creditScoreHistory,
      List<ExistingLoanSummary> existingLoans,
      FinancialMetrics financialMetrics,
      int activeLoansCount,
      int totalApplicationsCount,
      int approvedApplicationsCount});

  $FinancialMetricsCopyWith<$Res> get financialMetrics;
}

/// @nodoc
class _$HomeDataCopyWithImpl<$Res, $Val extends HomeData>
    implements $HomeDataCopyWith<$Res> {
  _$HomeDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userFirstName = null,
    Object? registrationDate = null,
    Object? currentCreditScore = null,
    Object? creditScoreHistory = null,
    Object? existingLoans = null,
    Object? financialMetrics = null,
    Object? activeLoansCount = null,
    Object? totalApplicationsCount = null,
    Object? approvedApplicationsCount = null,
  }) {
    return _then(_value.copyWith(
      userFirstName: null == userFirstName
          ? _value.userFirstName
          : userFirstName // ignore: cast_nullable_to_non_nullable
              as String,
      registrationDate: null == registrationDate
          ? _value.registrationDate
          : registrationDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      currentCreditScore: null == currentCreditScore
          ? _value.currentCreditScore
          : currentCreditScore // ignore: cast_nullable_to_non_nullable
              as int,
      creditScoreHistory: null == creditScoreHistory
          ? _value.creditScoreHistory
          : creditScoreHistory // ignore: cast_nullable_to_non_nullable
              as List<CreditScoreUpdate>,
      existingLoans: null == existingLoans
          ? _value.existingLoans
          : existingLoans // ignore: cast_nullable_to_non_nullable
              as List<ExistingLoanSummary>,
      financialMetrics: null == financialMetrics
          ? _value.financialMetrics
          : financialMetrics // ignore: cast_nullable_to_non_nullable
              as FinancialMetrics,
      activeLoansCount: null == activeLoansCount
          ? _value.activeLoansCount
          : activeLoansCount // ignore: cast_nullable_to_non_nullable
              as int,
      totalApplicationsCount: null == totalApplicationsCount
          ? _value.totalApplicationsCount
          : totalApplicationsCount // ignore: cast_nullable_to_non_nullable
              as int,
      approvedApplicationsCount: null == approvedApplicationsCount
          ? _value.approvedApplicationsCount
          : approvedApplicationsCount // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $FinancialMetricsCopyWith<$Res> get financialMetrics {
    return $FinancialMetricsCopyWith<$Res>(_value.financialMetrics, (value) {
      return _then(_value.copyWith(financialMetrics: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$HomeDataImplCopyWith<$Res>
    implements $HomeDataCopyWith<$Res> {
  factory _$$HomeDataImplCopyWith(
          _$HomeDataImpl value, $Res Function(_$HomeDataImpl) then) =
      __$$HomeDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String userFirstName,
      DateTime registrationDate,
      int currentCreditScore,
      List<CreditScoreUpdate> creditScoreHistory,
      List<ExistingLoanSummary> existingLoans,
      FinancialMetrics financialMetrics,
      int activeLoansCount,
      int totalApplicationsCount,
      int approvedApplicationsCount});

  @override
  $FinancialMetricsCopyWith<$Res> get financialMetrics;
}

/// @nodoc
class __$$HomeDataImplCopyWithImpl<$Res>
    extends _$HomeDataCopyWithImpl<$Res, _$HomeDataImpl>
    implements _$$HomeDataImplCopyWith<$Res> {
  __$$HomeDataImplCopyWithImpl(
      _$HomeDataImpl _value, $Res Function(_$HomeDataImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userFirstName = null,
    Object? registrationDate = null,
    Object? currentCreditScore = null,
    Object? creditScoreHistory = null,
    Object? existingLoans = null,
    Object? financialMetrics = null,
    Object? activeLoansCount = null,
    Object? totalApplicationsCount = null,
    Object? approvedApplicationsCount = null,
  }) {
    return _then(_$HomeDataImpl(
      userFirstName: null == userFirstName
          ? _value.userFirstName
          : userFirstName // ignore: cast_nullable_to_non_nullable
              as String,
      registrationDate: null == registrationDate
          ? _value.registrationDate
          : registrationDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      currentCreditScore: null == currentCreditScore
          ? _value.currentCreditScore
          : currentCreditScore // ignore: cast_nullable_to_non_nullable
              as int,
      creditScoreHistory: null == creditScoreHistory
          ? _value._creditScoreHistory
          : creditScoreHistory // ignore: cast_nullable_to_non_nullable
              as List<CreditScoreUpdate>,
      existingLoans: null == existingLoans
          ? _value._existingLoans
          : existingLoans // ignore: cast_nullable_to_non_nullable
              as List<ExistingLoanSummary>,
      financialMetrics: null == financialMetrics
          ? _value.financialMetrics
          : financialMetrics // ignore: cast_nullable_to_non_nullable
              as FinancialMetrics,
      activeLoansCount: null == activeLoansCount
          ? _value.activeLoansCount
          : activeLoansCount // ignore: cast_nullable_to_non_nullable
              as int,
      totalApplicationsCount: null == totalApplicationsCount
          ? _value.totalApplicationsCount
          : totalApplicationsCount // ignore: cast_nullable_to_non_nullable
              as int,
      approvedApplicationsCount: null == approvedApplicationsCount
          ? _value.approvedApplicationsCount
          : approvedApplicationsCount // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$HomeDataImpl implements _HomeData {
  const _$HomeDataImpl(
      {required this.userFirstName,
      required this.registrationDate,
      required this.currentCreditScore,
      required final List<CreditScoreUpdate> creditScoreHistory,
      required final List<ExistingLoanSummary> existingLoans,
      required this.financialMetrics,
      required this.activeLoansCount,
      required this.totalApplicationsCount,
      required this.approvedApplicationsCount})
      : _creditScoreHistory = creditScoreHistory,
        _existingLoans = existingLoans;

  factory _$HomeDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$HomeDataImplFromJson(json);

  @override
  final String userFirstName;
  @override
  final DateTime registrationDate;
  @override
  final int currentCreditScore;
  final List<CreditScoreUpdate> _creditScoreHistory;
  @override
  List<CreditScoreUpdate> get creditScoreHistory {
    if (_creditScoreHistory is EqualUnmodifiableListView)
      return _creditScoreHistory;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_creditScoreHistory);
  }

  final List<ExistingLoanSummary> _existingLoans;
  @override
  List<ExistingLoanSummary> get existingLoans {
    if (_existingLoans is EqualUnmodifiableListView) return _existingLoans;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_existingLoans);
  }

  @override
  final FinancialMetrics financialMetrics;
  @override
  final int activeLoansCount;
  @override
  final int totalApplicationsCount;
  @override
  final int approvedApplicationsCount;

  @override
  String toString() {
    return 'HomeData(userFirstName: $userFirstName, registrationDate: $registrationDate, currentCreditScore: $currentCreditScore, creditScoreHistory: $creditScoreHistory, existingLoans: $existingLoans, financialMetrics: $financialMetrics, activeLoansCount: $activeLoansCount, totalApplicationsCount: $totalApplicationsCount, approvedApplicationsCount: $approvedApplicationsCount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HomeDataImpl &&
            (identical(other.userFirstName, userFirstName) ||
                other.userFirstName == userFirstName) &&
            (identical(other.registrationDate, registrationDate) ||
                other.registrationDate == registrationDate) &&
            (identical(other.currentCreditScore, currentCreditScore) ||
                other.currentCreditScore == currentCreditScore) &&
            const DeepCollectionEquality()
                .equals(other._creditScoreHistory, _creditScoreHistory) &&
            const DeepCollectionEquality()
                .equals(other._existingLoans, _existingLoans) &&
            (identical(other.financialMetrics, financialMetrics) ||
                other.financialMetrics == financialMetrics) &&
            (identical(other.activeLoansCount, activeLoansCount) ||
                other.activeLoansCount == activeLoansCount) &&
            (identical(other.totalApplicationsCount, totalApplicationsCount) ||
                other.totalApplicationsCount == totalApplicationsCount) &&
            (identical(other.approvedApplicationsCount,
                    approvedApplicationsCount) ||
                other.approvedApplicationsCount == approvedApplicationsCount));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      userFirstName,
      registrationDate,
      currentCreditScore,
      const DeepCollectionEquality().hash(_creditScoreHistory),
      const DeepCollectionEquality().hash(_existingLoans),
      financialMetrics,
      activeLoansCount,
      totalApplicationsCount,
      approvedApplicationsCount);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$HomeDataImplCopyWith<_$HomeDataImpl> get copyWith =>
      __$$HomeDataImplCopyWithImpl<_$HomeDataImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$HomeDataImplToJson(
      this,
    );
  }
}

abstract class _HomeData implements HomeData {
  const factory _HomeData(
      {required final String userFirstName,
      required final DateTime registrationDate,
      required final int currentCreditScore,
      required final List<CreditScoreUpdate> creditScoreHistory,
      required final List<ExistingLoanSummary> existingLoans,
      required final FinancialMetrics financialMetrics,
      required final int activeLoansCount,
      required final int totalApplicationsCount,
      required final int approvedApplicationsCount}) = _$HomeDataImpl;

  factory _HomeData.fromJson(Map<String, dynamic> json) =
      _$HomeDataImpl.fromJson;

  @override
  String get userFirstName;
  @override
  DateTime get registrationDate;
  @override
  int get currentCreditScore;
  @override
  List<CreditScoreUpdate> get creditScoreHistory;
  @override
  List<ExistingLoanSummary> get existingLoans;
  @override
  FinancialMetrics get financialMetrics;
  @override
  int get activeLoansCount;
  @override
  int get totalApplicationsCount;
  @override
  int get approvedApplicationsCount;
  @override
  @JsonKey(ignore: true)
  _$$HomeDataImplCopyWith<_$HomeDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CreditScoreUpdate _$CreditScoreUpdateFromJson(Map<String, dynamic> json) {
  return _CreditScoreUpdate.fromJson(json);
}

/// @nodoc
mixin _$CreditScoreUpdate {
  DateTime get date => throw _privateConstructorUsedError;
  int get score => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CreditScoreUpdateCopyWith<CreditScoreUpdate> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CreditScoreUpdateCopyWith<$Res> {
  factory $CreditScoreUpdateCopyWith(
          CreditScoreUpdate value, $Res Function(CreditScoreUpdate) then) =
      _$CreditScoreUpdateCopyWithImpl<$Res, CreditScoreUpdate>;
  @useResult
  $Res call({DateTime date, int score});
}

/// @nodoc
class _$CreditScoreUpdateCopyWithImpl<$Res, $Val extends CreditScoreUpdate>
    implements $CreditScoreUpdateCopyWith<$Res> {
  _$CreditScoreUpdateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? score = null,
  }) {
    return _then(_value.copyWith(
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      score: null == score
          ? _value.score
          : score // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CreditScoreUpdateImplCopyWith<$Res>
    implements $CreditScoreUpdateCopyWith<$Res> {
  factory _$$CreditScoreUpdateImplCopyWith(_$CreditScoreUpdateImpl value,
          $Res Function(_$CreditScoreUpdateImpl) then) =
      __$$CreditScoreUpdateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({DateTime date, int score});
}

/// @nodoc
class __$$CreditScoreUpdateImplCopyWithImpl<$Res>
    extends _$CreditScoreUpdateCopyWithImpl<$Res, _$CreditScoreUpdateImpl>
    implements _$$CreditScoreUpdateImplCopyWith<$Res> {
  __$$CreditScoreUpdateImplCopyWithImpl(_$CreditScoreUpdateImpl _value,
      $Res Function(_$CreditScoreUpdateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? score = null,
  }) {
    return _then(_$CreditScoreUpdateImpl(
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      score: null == score
          ? _value.score
          : score // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CreditScoreUpdateImpl implements _CreditScoreUpdate {
  const _$CreditScoreUpdateImpl({required this.date, required this.score});

  factory _$CreditScoreUpdateImpl.fromJson(Map<String, dynamic> json) =>
      _$$CreditScoreUpdateImplFromJson(json);

  @override
  final DateTime date;
  @override
  final int score;

  @override
  String toString() {
    return 'CreditScoreUpdate(date: $date, score: $score)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CreditScoreUpdateImpl &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.score, score) || other.score == score));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, date, score);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CreditScoreUpdateImplCopyWith<_$CreditScoreUpdateImpl> get copyWith =>
      __$$CreditScoreUpdateImplCopyWithImpl<_$CreditScoreUpdateImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CreditScoreUpdateImplToJson(
      this,
    );
  }
}

abstract class _CreditScoreUpdate implements CreditScoreUpdate {
  const factory _CreditScoreUpdate(
      {required final DateTime date,
      required final int score}) = _$CreditScoreUpdateImpl;

  factory _CreditScoreUpdate.fromJson(Map<String, dynamic> json) =
      _$CreditScoreUpdateImpl.fromJson;

  @override
  DateTime get date;
  @override
  int get score;
  @override
  @JsonKey(ignore: true)
  _$$CreditScoreUpdateImplCopyWith<_$CreditScoreUpdateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ExistingLoanSummary _$ExistingLoanSummaryFromJson(Map<String, dynamic> json) {
  return _ExistingLoanSummary.fromJson(json);
}

/// @nodoc
mixin _$ExistingLoanSummary {
  String get loanId => throw _privateConstructorUsedError;
  String get loanType => throw _privateConstructorUsedError;
  double get loanAmount => throw _privateConstructorUsedError;
  double get outstandingBalance => throw _privateConstructorUsedError;
  double get monthlyInstallment => throw _privateConstructorUsedError;
  int get remainingTenure => throw _privateConstructorUsedError;
  DateTime get startDate => throw _privateConstructorUsedError;
  DateTime? get nextPaymentDate => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ExistingLoanSummaryCopyWith<ExistingLoanSummary> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ExistingLoanSummaryCopyWith<$Res> {
  factory $ExistingLoanSummaryCopyWith(
          ExistingLoanSummary value, $Res Function(ExistingLoanSummary) then) =
      _$ExistingLoanSummaryCopyWithImpl<$Res, ExistingLoanSummary>;
  @useResult
  $Res call(
      {String loanId,
      String loanType,
      double loanAmount,
      double outstandingBalance,
      double monthlyInstallment,
      int remainingTenure,
      DateTime startDate,
      DateTime? nextPaymentDate});
}

/// @nodoc
class _$ExistingLoanSummaryCopyWithImpl<$Res, $Val extends ExistingLoanSummary>
    implements $ExistingLoanSummaryCopyWith<$Res> {
  _$ExistingLoanSummaryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? loanId = null,
    Object? loanType = null,
    Object? loanAmount = null,
    Object? outstandingBalance = null,
    Object? monthlyInstallment = null,
    Object? remainingTenure = null,
    Object? startDate = null,
    Object? nextPaymentDate = freezed,
  }) {
    return _then(_value.copyWith(
      loanId: null == loanId
          ? _value.loanId
          : loanId // ignore: cast_nullable_to_non_nullable
              as String,
      loanType: null == loanType
          ? _value.loanType
          : loanType // ignore: cast_nullable_to_non_nullable
              as String,
      loanAmount: null == loanAmount
          ? _value.loanAmount
          : loanAmount // ignore: cast_nullable_to_non_nullable
              as double,
      outstandingBalance: null == outstandingBalance
          ? _value.outstandingBalance
          : outstandingBalance // ignore: cast_nullable_to_non_nullable
              as double,
      monthlyInstallment: null == monthlyInstallment
          ? _value.monthlyInstallment
          : monthlyInstallment // ignore: cast_nullable_to_non_nullable
              as double,
      remainingTenure: null == remainingTenure
          ? _value.remainingTenure
          : remainingTenure // ignore: cast_nullable_to_non_nullable
              as int,
      startDate: null == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      nextPaymentDate: freezed == nextPaymentDate
          ? _value.nextPaymentDate
          : nextPaymentDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ExistingLoanSummaryImplCopyWith<$Res>
    implements $ExistingLoanSummaryCopyWith<$Res> {
  factory _$$ExistingLoanSummaryImplCopyWith(_$ExistingLoanSummaryImpl value,
          $Res Function(_$ExistingLoanSummaryImpl) then) =
      __$$ExistingLoanSummaryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String loanId,
      String loanType,
      double loanAmount,
      double outstandingBalance,
      double monthlyInstallment,
      int remainingTenure,
      DateTime startDate,
      DateTime? nextPaymentDate});
}

/// @nodoc
class __$$ExistingLoanSummaryImplCopyWithImpl<$Res>
    extends _$ExistingLoanSummaryCopyWithImpl<$Res, _$ExistingLoanSummaryImpl>
    implements _$$ExistingLoanSummaryImplCopyWith<$Res> {
  __$$ExistingLoanSummaryImplCopyWithImpl(_$ExistingLoanSummaryImpl _value,
      $Res Function(_$ExistingLoanSummaryImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? loanId = null,
    Object? loanType = null,
    Object? loanAmount = null,
    Object? outstandingBalance = null,
    Object? monthlyInstallment = null,
    Object? remainingTenure = null,
    Object? startDate = null,
    Object? nextPaymentDate = freezed,
  }) {
    return _then(_$ExistingLoanSummaryImpl(
      loanId: null == loanId
          ? _value.loanId
          : loanId // ignore: cast_nullable_to_non_nullable
              as String,
      loanType: null == loanType
          ? _value.loanType
          : loanType // ignore: cast_nullable_to_non_nullable
              as String,
      loanAmount: null == loanAmount
          ? _value.loanAmount
          : loanAmount // ignore: cast_nullable_to_non_nullable
              as double,
      outstandingBalance: null == outstandingBalance
          ? _value.outstandingBalance
          : outstandingBalance // ignore: cast_nullable_to_non_nullable
              as double,
      monthlyInstallment: null == monthlyInstallment
          ? _value.monthlyInstallment
          : monthlyInstallment // ignore: cast_nullable_to_non_nullable
              as double,
      remainingTenure: null == remainingTenure
          ? _value.remainingTenure
          : remainingTenure // ignore: cast_nullable_to_non_nullable
              as int,
      startDate: null == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      nextPaymentDate: freezed == nextPaymentDate
          ? _value.nextPaymentDate
          : nextPaymentDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ExistingLoanSummaryImpl implements _ExistingLoanSummary {
  const _$ExistingLoanSummaryImpl(
      {required this.loanId,
      required this.loanType,
      required this.loanAmount,
      required this.outstandingBalance,
      required this.monthlyInstallment,
      required this.remainingTenure,
      required this.startDate,
      required this.nextPaymentDate});

  factory _$ExistingLoanSummaryImpl.fromJson(Map<String, dynamic> json) =>
      _$$ExistingLoanSummaryImplFromJson(json);

  @override
  final String loanId;
  @override
  final String loanType;
  @override
  final double loanAmount;
  @override
  final double outstandingBalance;
  @override
  final double monthlyInstallment;
  @override
  final int remainingTenure;
  @override
  final DateTime startDate;
  @override
  final DateTime? nextPaymentDate;

  @override
  String toString() {
    return 'ExistingLoanSummary(loanId: $loanId, loanType: $loanType, loanAmount: $loanAmount, outstandingBalance: $outstandingBalance, monthlyInstallment: $monthlyInstallment, remainingTenure: $remainingTenure, startDate: $startDate, nextPaymentDate: $nextPaymentDate)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ExistingLoanSummaryImpl &&
            (identical(other.loanId, loanId) || other.loanId == loanId) &&
            (identical(other.loanType, loanType) ||
                other.loanType == loanType) &&
            (identical(other.loanAmount, loanAmount) ||
                other.loanAmount == loanAmount) &&
            (identical(other.outstandingBalance, outstandingBalance) ||
                other.outstandingBalance == outstandingBalance) &&
            (identical(other.monthlyInstallment, monthlyInstallment) ||
                other.monthlyInstallment == monthlyInstallment) &&
            (identical(other.remainingTenure, remainingTenure) ||
                other.remainingTenure == remainingTenure) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.nextPaymentDate, nextPaymentDate) ||
                other.nextPaymentDate == nextPaymentDate));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      loanId,
      loanType,
      loanAmount,
      outstandingBalance,
      monthlyInstallment,
      remainingTenure,
      startDate,
      nextPaymentDate);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ExistingLoanSummaryImplCopyWith<_$ExistingLoanSummaryImpl> get copyWith =>
      __$$ExistingLoanSummaryImplCopyWithImpl<_$ExistingLoanSummaryImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ExistingLoanSummaryImplToJson(
      this,
    );
  }
}

abstract class _ExistingLoanSummary implements ExistingLoanSummary {
  const factory _ExistingLoanSummary(
      {required final String loanId,
      required final String loanType,
      required final double loanAmount,
      required final double outstandingBalance,
      required final double monthlyInstallment,
      required final int remainingTenure,
      required final DateTime startDate,
      required final DateTime? nextPaymentDate}) = _$ExistingLoanSummaryImpl;

  factory _ExistingLoanSummary.fromJson(Map<String, dynamic> json) =
      _$ExistingLoanSummaryImpl.fromJson;

  @override
  String get loanId;
  @override
  String get loanType;
  @override
  double get loanAmount;
  @override
  double get outstandingBalance;
  @override
  double get monthlyInstallment;
  @override
  int get remainingTenure;
  @override
  DateTime get startDate;
  @override
  DateTime? get nextPaymentDate;
  @override
  @JsonKey(ignore: true)
  _$$ExistingLoanSummaryImplCopyWith<_$ExistingLoanSummaryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

FinancialMetrics _$FinancialMetricsFromJson(Map<String, dynamic> json) {
  return _FinancialMetrics.fromJson(json);
}

/// @nodoc
mixin _$FinancialMetrics {
  double get dsrPercentage => throw _privateConstructorUsedError;
  bool get ccrisGood => throw _privateConstructorUsedError;
  double get totalExistingCommitments => throw _privateConstructorUsedError;
  Map<String, double>? get dsrBreakdown => throw _privateConstructorUsedError;
  String? get ccrisDetails => throw _privateConstructorUsedError;
  Map<String, double>? get commitmentsBreakdown =>
      throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $FinancialMetricsCopyWith<FinancialMetrics> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FinancialMetricsCopyWith<$Res> {
  factory $FinancialMetricsCopyWith(
          FinancialMetrics value, $Res Function(FinancialMetrics) then) =
      _$FinancialMetricsCopyWithImpl<$Res, FinancialMetrics>;
  @useResult
  $Res call(
      {double dsrPercentage,
      bool ccrisGood,
      double totalExistingCommitments,
      Map<String, double>? dsrBreakdown,
      String? ccrisDetails,
      Map<String, double>? commitmentsBreakdown});
}

/// @nodoc
class _$FinancialMetricsCopyWithImpl<$Res, $Val extends FinancialMetrics>
    implements $FinancialMetricsCopyWith<$Res> {
  _$FinancialMetricsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? dsrPercentage = null,
    Object? ccrisGood = null,
    Object? totalExistingCommitments = null,
    Object? dsrBreakdown = freezed,
    Object? ccrisDetails = freezed,
    Object? commitmentsBreakdown = freezed,
  }) {
    return _then(_value.copyWith(
      dsrPercentage: null == dsrPercentage
          ? _value.dsrPercentage
          : dsrPercentage // ignore: cast_nullable_to_non_nullable
              as double,
      ccrisGood: null == ccrisGood
          ? _value.ccrisGood
          : ccrisGood // ignore: cast_nullable_to_non_nullable
              as bool,
      totalExistingCommitments: null == totalExistingCommitments
          ? _value.totalExistingCommitments
          : totalExistingCommitments // ignore: cast_nullable_to_non_nullable
              as double,
      dsrBreakdown: freezed == dsrBreakdown
          ? _value.dsrBreakdown
          : dsrBreakdown // ignore: cast_nullable_to_non_nullable
              as Map<String, double>?,
      ccrisDetails: freezed == ccrisDetails
          ? _value.ccrisDetails
          : ccrisDetails // ignore: cast_nullable_to_non_nullable
              as String?,
      commitmentsBreakdown: freezed == commitmentsBreakdown
          ? _value.commitmentsBreakdown
          : commitmentsBreakdown // ignore: cast_nullable_to_non_nullable
              as Map<String, double>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FinancialMetricsImplCopyWith<$Res>
    implements $FinancialMetricsCopyWith<$Res> {
  factory _$$FinancialMetricsImplCopyWith(_$FinancialMetricsImpl value,
          $Res Function(_$FinancialMetricsImpl) then) =
      __$$FinancialMetricsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {double dsrPercentage,
      bool ccrisGood,
      double totalExistingCommitments,
      Map<String, double>? dsrBreakdown,
      String? ccrisDetails,
      Map<String, double>? commitmentsBreakdown});
}

/// @nodoc
class __$$FinancialMetricsImplCopyWithImpl<$Res>
    extends _$FinancialMetricsCopyWithImpl<$Res, _$FinancialMetricsImpl>
    implements _$$FinancialMetricsImplCopyWith<$Res> {
  __$$FinancialMetricsImplCopyWithImpl(_$FinancialMetricsImpl _value,
      $Res Function(_$FinancialMetricsImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? dsrPercentage = null,
    Object? ccrisGood = null,
    Object? totalExistingCommitments = null,
    Object? dsrBreakdown = freezed,
    Object? ccrisDetails = freezed,
    Object? commitmentsBreakdown = freezed,
  }) {
    return _then(_$FinancialMetricsImpl(
      dsrPercentage: null == dsrPercentage
          ? _value.dsrPercentage
          : dsrPercentage // ignore: cast_nullable_to_non_nullable
              as double,
      ccrisGood: null == ccrisGood
          ? _value.ccrisGood
          : ccrisGood // ignore: cast_nullable_to_non_nullable
              as bool,
      totalExistingCommitments: null == totalExistingCommitments
          ? _value.totalExistingCommitments
          : totalExistingCommitments // ignore: cast_nullable_to_non_nullable
              as double,
      dsrBreakdown: freezed == dsrBreakdown
          ? _value._dsrBreakdown
          : dsrBreakdown // ignore: cast_nullable_to_non_nullable
              as Map<String, double>?,
      ccrisDetails: freezed == ccrisDetails
          ? _value.ccrisDetails
          : ccrisDetails // ignore: cast_nullable_to_non_nullable
              as String?,
      commitmentsBreakdown: freezed == commitmentsBreakdown
          ? _value._commitmentsBreakdown
          : commitmentsBreakdown // ignore: cast_nullable_to_non_nullable
              as Map<String, double>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FinancialMetricsImpl implements _FinancialMetrics {
  const _$FinancialMetricsImpl(
      {required this.dsrPercentage,
      required this.ccrisGood,
      required this.totalExistingCommitments,
      required final Map<String, double>? dsrBreakdown,
      required this.ccrisDetails,
      required final Map<String, double>? commitmentsBreakdown})
      : _dsrBreakdown = dsrBreakdown,
        _commitmentsBreakdown = commitmentsBreakdown;

  factory _$FinancialMetricsImpl.fromJson(Map<String, dynamic> json) =>
      _$$FinancialMetricsImplFromJson(json);

  @override
  final double dsrPercentage;
  @override
  final bool ccrisGood;
  @override
  final double totalExistingCommitments;
  final Map<String, double>? _dsrBreakdown;
  @override
  Map<String, double>? get dsrBreakdown {
    final value = _dsrBreakdown;
    if (value == null) return null;
    if (_dsrBreakdown is EqualUnmodifiableMapView) return _dsrBreakdown;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  final String? ccrisDetails;
  final Map<String, double>? _commitmentsBreakdown;
  @override
  Map<String, double>? get commitmentsBreakdown {
    final value = _commitmentsBreakdown;
    if (value == null) return null;
    if (_commitmentsBreakdown is EqualUnmodifiableMapView)
      return _commitmentsBreakdown;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'FinancialMetrics(dsrPercentage: $dsrPercentage, ccrisGood: $ccrisGood, totalExistingCommitments: $totalExistingCommitments, dsrBreakdown: $dsrBreakdown, ccrisDetails: $ccrisDetails, commitmentsBreakdown: $commitmentsBreakdown)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FinancialMetricsImpl &&
            (identical(other.dsrPercentage, dsrPercentage) ||
                other.dsrPercentage == dsrPercentage) &&
            (identical(other.ccrisGood, ccrisGood) ||
                other.ccrisGood == ccrisGood) &&
            (identical(
                    other.totalExistingCommitments, totalExistingCommitments) ||
                other.totalExistingCommitments == totalExistingCommitments) &&
            const DeepCollectionEquality()
                .equals(other._dsrBreakdown, _dsrBreakdown) &&
            (identical(other.ccrisDetails, ccrisDetails) ||
                other.ccrisDetails == ccrisDetails) &&
            const DeepCollectionEquality()
                .equals(other._commitmentsBreakdown, _commitmentsBreakdown));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      dsrPercentage,
      ccrisGood,
      totalExistingCommitments,
      const DeepCollectionEquality().hash(_dsrBreakdown),
      ccrisDetails,
      const DeepCollectionEquality().hash(_commitmentsBreakdown));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$FinancialMetricsImplCopyWith<_$FinancialMetricsImpl> get copyWith =>
      __$$FinancialMetricsImplCopyWithImpl<_$FinancialMetricsImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FinancialMetricsImplToJson(
      this,
    );
  }
}

abstract class _FinancialMetrics implements FinancialMetrics {
  const factory _FinancialMetrics(
          {required final double dsrPercentage,
          required final bool ccrisGood,
          required final double totalExistingCommitments,
          required final Map<String, double>? dsrBreakdown,
          required final String? ccrisDetails,
          required final Map<String, double>? commitmentsBreakdown}) =
      _$FinancialMetricsImpl;

  factory _FinancialMetrics.fromJson(Map<String, dynamic> json) =
      _$FinancialMetricsImpl.fromJson;

  @override
  double get dsrPercentage;
  @override
  bool get ccrisGood;
  @override
  double get totalExistingCommitments;
  @override
  Map<String, double>? get dsrBreakdown;
  @override
  String? get ccrisDetails;
  @override
  Map<String, double>? get commitmentsBreakdown;
  @override
  @JsonKey(ignore: true)
  _$$FinancialMetricsImplCopyWith<_$FinancialMetricsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
