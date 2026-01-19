// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'loan_application.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

LoanApplication _$LoanApplicationFromJson(Map<String, dynamic> json) {
  return _LoanApplication.fromJson(json);
}

/// @nodoc
mixin _$LoanApplication {
  String get applicationId => throw _privateConstructorUsedError;
  String get icNumber => throw _privateConstructorUsedError;
  String get loanType => throw _privateConstructorUsedError;
  double get requestedAmount => throw _privateConstructorUsedError;
  int get tenure => throw _privateConstructorUsedError;
  String get purposeOfLoan => throw _privateConstructorUsedError;
  bool get guarantorAvailable => throw _privateConstructorUsedError;
  LoanStatus get status => throw _privateConstructorUsedError;
  List<String> get requiredDocuments => throw _privateConstructorUsedError;
  List<String> get uploadedDocuments => throw _privateConstructorUsedError;
  String get applicationDate => throw _privateConstructorUsedError;
  String get lastUpdated => throw _privateConstructorUsedError;
  double? get interestRate => throw _privateConstructorUsedError;
  double? get approvedAmount => throw _privateConstructorUsedError;
  String? get rejectionReason => throw _privateConstructorUsedError;
  String? get assignedOfficer => throw _privateConstructorUsedError;
  String? get officerRemarks => throw _privateConstructorUsedError;
  double? get mlConfidence => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $LoanApplicationCopyWith<LoanApplication> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LoanApplicationCopyWith<$Res> {
  factory $LoanApplicationCopyWith(
          LoanApplication value, $Res Function(LoanApplication) then) =
      _$LoanApplicationCopyWithImpl<$Res, LoanApplication>;
  @useResult
  $Res call(
      {String applicationId,
      String icNumber,
      String loanType,
      double requestedAmount,
      int tenure,
      String purposeOfLoan,
      bool guarantorAvailable,
      LoanStatus status,
      List<String> requiredDocuments,
      List<String> uploadedDocuments,
      String applicationDate,
      String lastUpdated,
      double? interestRate,
      double? approvedAmount,
      String? rejectionReason,
      String? assignedOfficer,
      String? officerRemarks,
      double? mlConfidence});
}

/// @nodoc
class _$LoanApplicationCopyWithImpl<$Res, $Val extends LoanApplication>
    implements $LoanApplicationCopyWith<$Res> {
  _$LoanApplicationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? applicationId = null,
    Object? icNumber = null,
    Object? loanType = null,
    Object? requestedAmount = null,
    Object? tenure = null,
    Object? purposeOfLoan = null,
    Object? guarantorAvailable = null,
    Object? status = null,
    Object? requiredDocuments = null,
    Object? uploadedDocuments = null,
    Object? applicationDate = null,
    Object? lastUpdated = null,
    Object? interestRate = freezed,
    Object? approvedAmount = freezed,
    Object? rejectionReason = freezed,
    Object? assignedOfficer = freezed,
    Object? officerRemarks = freezed,
    Object? mlConfidence = freezed,
  }) {
    return _then(_value.copyWith(
      applicationId: null == applicationId
          ? _value.applicationId
          : applicationId // ignore: cast_nullable_to_non_nullable
              as String,
      icNumber: null == icNumber
          ? _value.icNumber
          : icNumber // ignore: cast_nullable_to_non_nullable
              as String,
      loanType: null == loanType
          ? _value.loanType
          : loanType // ignore: cast_nullable_to_non_nullable
              as String,
      requestedAmount: null == requestedAmount
          ? _value.requestedAmount
          : requestedAmount // ignore: cast_nullable_to_non_nullable
              as double,
      tenure: null == tenure
          ? _value.tenure
          : tenure // ignore: cast_nullable_to_non_nullable
              as int,
      purposeOfLoan: null == purposeOfLoan
          ? _value.purposeOfLoan
          : purposeOfLoan // ignore: cast_nullable_to_non_nullable
              as String,
      guarantorAvailable: null == guarantorAvailable
          ? _value.guarantorAvailable
          : guarantorAvailable // ignore: cast_nullable_to_non_nullable
              as bool,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as LoanStatus,
      requiredDocuments: null == requiredDocuments
          ? _value.requiredDocuments
          : requiredDocuments // ignore: cast_nullable_to_non_nullable
              as List<String>,
      uploadedDocuments: null == uploadedDocuments
          ? _value.uploadedDocuments
          : uploadedDocuments // ignore: cast_nullable_to_non_nullable
              as List<String>,
      applicationDate: null == applicationDate
          ? _value.applicationDate
          : applicationDate // ignore: cast_nullable_to_non_nullable
              as String,
      lastUpdated: null == lastUpdated
          ? _value.lastUpdated
          : lastUpdated // ignore: cast_nullable_to_non_nullable
              as String,
      interestRate: freezed == interestRate
          ? _value.interestRate
          : interestRate // ignore: cast_nullable_to_non_nullable
              as double?,
      approvedAmount: freezed == approvedAmount
          ? _value.approvedAmount
          : approvedAmount // ignore: cast_nullable_to_non_nullable
              as double?,
      rejectionReason: freezed == rejectionReason
          ? _value.rejectionReason
          : rejectionReason // ignore: cast_nullable_to_non_nullable
              as String?,
      assignedOfficer: freezed == assignedOfficer
          ? _value.assignedOfficer
          : assignedOfficer // ignore: cast_nullable_to_non_nullable
              as String?,
      officerRemarks: freezed == officerRemarks
          ? _value.officerRemarks
          : officerRemarks // ignore: cast_nullable_to_non_nullable
              as String?,
      mlConfidence: freezed == mlConfidence
          ? _value.mlConfidence
          : mlConfidence // ignore: cast_nullable_to_non_nullable
              as double?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$LoanApplicationImplCopyWith<$Res>
    implements $LoanApplicationCopyWith<$Res> {
  factory _$$LoanApplicationImplCopyWith(_$LoanApplicationImpl value,
          $Res Function(_$LoanApplicationImpl) then) =
      __$$LoanApplicationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String applicationId,
      String icNumber,
      String loanType,
      double requestedAmount,
      int tenure,
      String purposeOfLoan,
      bool guarantorAvailable,
      LoanStatus status,
      List<String> requiredDocuments,
      List<String> uploadedDocuments,
      String applicationDate,
      String lastUpdated,
      double? interestRate,
      double? approvedAmount,
      String? rejectionReason,
      String? assignedOfficer,
      String? officerRemarks,
      double? mlConfidence});
}

/// @nodoc
class __$$LoanApplicationImplCopyWithImpl<$Res>
    extends _$LoanApplicationCopyWithImpl<$Res, _$LoanApplicationImpl>
    implements _$$LoanApplicationImplCopyWith<$Res> {
  __$$LoanApplicationImplCopyWithImpl(
      _$LoanApplicationImpl _value, $Res Function(_$LoanApplicationImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? applicationId = null,
    Object? icNumber = null,
    Object? loanType = null,
    Object? requestedAmount = null,
    Object? tenure = null,
    Object? purposeOfLoan = null,
    Object? guarantorAvailable = null,
    Object? status = null,
    Object? requiredDocuments = null,
    Object? uploadedDocuments = null,
    Object? applicationDate = null,
    Object? lastUpdated = null,
    Object? interestRate = freezed,
    Object? approvedAmount = freezed,
    Object? rejectionReason = freezed,
    Object? assignedOfficer = freezed,
    Object? officerRemarks = freezed,
    Object? mlConfidence = freezed,
  }) {
    return _then(_$LoanApplicationImpl(
      applicationId: null == applicationId
          ? _value.applicationId
          : applicationId // ignore: cast_nullable_to_non_nullable
              as String,
      icNumber: null == icNumber
          ? _value.icNumber
          : icNumber // ignore: cast_nullable_to_non_nullable
              as String,
      loanType: null == loanType
          ? _value.loanType
          : loanType // ignore: cast_nullable_to_non_nullable
              as String,
      requestedAmount: null == requestedAmount
          ? _value.requestedAmount
          : requestedAmount // ignore: cast_nullable_to_non_nullable
              as double,
      tenure: null == tenure
          ? _value.tenure
          : tenure // ignore: cast_nullable_to_non_nullable
              as int,
      purposeOfLoan: null == purposeOfLoan
          ? _value.purposeOfLoan
          : purposeOfLoan // ignore: cast_nullable_to_non_nullable
              as String,
      guarantorAvailable: null == guarantorAvailable
          ? _value.guarantorAvailable
          : guarantorAvailable // ignore: cast_nullable_to_non_nullable
              as bool,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as LoanStatus,
      requiredDocuments: null == requiredDocuments
          ? _value._requiredDocuments
          : requiredDocuments // ignore: cast_nullable_to_non_nullable
              as List<String>,
      uploadedDocuments: null == uploadedDocuments
          ? _value._uploadedDocuments
          : uploadedDocuments // ignore: cast_nullable_to_non_nullable
              as List<String>,
      applicationDate: null == applicationDate
          ? _value.applicationDate
          : applicationDate // ignore: cast_nullable_to_non_nullable
              as String,
      lastUpdated: null == lastUpdated
          ? _value.lastUpdated
          : lastUpdated // ignore: cast_nullable_to_non_nullable
              as String,
      interestRate: freezed == interestRate
          ? _value.interestRate
          : interestRate // ignore: cast_nullable_to_non_nullable
              as double?,
      approvedAmount: freezed == approvedAmount
          ? _value.approvedAmount
          : approvedAmount // ignore: cast_nullable_to_non_nullable
              as double?,
      rejectionReason: freezed == rejectionReason
          ? _value.rejectionReason
          : rejectionReason // ignore: cast_nullable_to_non_nullable
              as String?,
      assignedOfficer: freezed == assignedOfficer
          ? _value.assignedOfficer
          : assignedOfficer // ignore: cast_nullable_to_non_nullable
              as String?,
      officerRemarks: freezed == officerRemarks
          ? _value.officerRemarks
          : officerRemarks // ignore: cast_nullable_to_non_nullable
              as String?,
      mlConfidence: freezed == mlConfidence
          ? _value.mlConfidence
          : mlConfidence // ignore: cast_nullable_to_non_nullable
              as double?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$LoanApplicationImpl implements _LoanApplication {
  const _$LoanApplicationImpl(
      {required this.applicationId,
      required this.icNumber,
      required this.loanType,
      required this.requestedAmount,
      required this.tenure,
      required this.purposeOfLoan,
      required this.guarantorAvailable,
      required this.status,
      required final List<String> requiredDocuments,
      required final List<String> uploadedDocuments,
      required this.applicationDate,
      required this.lastUpdated,
      this.interestRate,
      this.approvedAmount,
      this.rejectionReason,
      this.assignedOfficer,
      this.officerRemarks,
      this.mlConfidence})
      : _requiredDocuments = requiredDocuments,
        _uploadedDocuments = uploadedDocuments;

  factory _$LoanApplicationImpl.fromJson(Map<String, dynamic> json) =>
      _$$LoanApplicationImplFromJson(json);

  @override
  final String applicationId;
  @override
  final String icNumber;
  @override
  final String loanType;
  @override
  final double requestedAmount;
  @override
  final int tenure;
  @override
  final String purposeOfLoan;
  @override
  final bool guarantorAvailable;
  @override
  final LoanStatus status;
  final List<String> _requiredDocuments;
  @override
  List<String> get requiredDocuments {
    if (_requiredDocuments is EqualUnmodifiableListView)
      return _requiredDocuments;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_requiredDocuments);
  }

  final List<String> _uploadedDocuments;
  @override
  List<String> get uploadedDocuments {
    if (_uploadedDocuments is EqualUnmodifiableListView)
      return _uploadedDocuments;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_uploadedDocuments);
  }

  @override
  final String applicationDate;
  @override
  final String lastUpdated;
  @override
  final double? interestRate;
  @override
  final double? approvedAmount;
  @override
  final String? rejectionReason;
  @override
  final String? assignedOfficer;
  @override
  final String? officerRemarks;
  @override
  final double? mlConfidence;

  @override
  String toString() {
    return 'LoanApplication(applicationId: $applicationId, icNumber: $icNumber, loanType: $loanType, requestedAmount: $requestedAmount, tenure: $tenure, purposeOfLoan: $purposeOfLoan, guarantorAvailable: $guarantorAvailable, status: $status, requiredDocuments: $requiredDocuments, uploadedDocuments: $uploadedDocuments, applicationDate: $applicationDate, lastUpdated: $lastUpdated, interestRate: $interestRate, approvedAmount: $approvedAmount, rejectionReason: $rejectionReason, assignedOfficer: $assignedOfficer, officerRemarks: $officerRemarks, mlConfidence: $mlConfidence)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LoanApplicationImpl &&
            (identical(other.applicationId, applicationId) ||
                other.applicationId == applicationId) &&
            (identical(other.icNumber, icNumber) ||
                other.icNumber == icNumber) &&
            (identical(other.loanType, loanType) ||
                other.loanType == loanType) &&
            (identical(other.requestedAmount, requestedAmount) ||
                other.requestedAmount == requestedAmount) &&
            (identical(other.tenure, tenure) || other.tenure == tenure) &&
            (identical(other.purposeOfLoan, purposeOfLoan) ||
                other.purposeOfLoan == purposeOfLoan) &&
            (identical(other.guarantorAvailable, guarantorAvailable) ||
                other.guarantorAvailable == guarantorAvailable) &&
            (identical(other.status, status) || other.status == status) &&
            const DeepCollectionEquality()
                .equals(other._requiredDocuments, _requiredDocuments) &&
            const DeepCollectionEquality()
                .equals(other._uploadedDocuments, _uploadedDocuments) &&
            (identical(other.applicationDate, applicationDate) ||
                other.applicationDate == applicationDate) &&
            (identical(other.lastUpdated, lastUpdated) ||
                other.lastUpdated == lastUpdated) &&
            (identical(other.interestRate, interestRate) ||
                other.interestRate == interestRate) &&
            (identical(other.approvedAmount, approvedAmount) ||
                other.approvedAmount == approvedAmount) &&
            (identical(other.rejectionReason, rejectionReason) ||
                other.rejectionReason == rejectionReason) &&
            (identical(other.assignedOfficer, assignedOfficer) ||
                other.assignedOfficer == assignedOfficer) &&
            (identical(other.officerRemarks, officerRemarks) ||
                other.officerRemarks == officerRemarks) &&
            (identical(other.mlConfidence, mlConfidence) ||
                other.mlConfidence == mlConfidence));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      applicationId,
      icNumber,
      loanType,
      requestedAmount,
      tenure,
      purposeOfLoan,
      guarantorAvailable,
      status,
      const DeepCollectionEquality().hash(_requiredDocuments),
      const DeepCollectionEquality().hash(_uploadedDocuments),
      applicationDate,
      lastUpdated,
      interestRate,
      approvedAmount,
      rejectionReason,
      assignedOfficer,
      officerRemarks,
      mlConfidence);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$LoanApplicationImplCopyWith<_$LoanApplicationImpl> get copyWith =>
      __$$LoanApplicationImplCopyWithImpl<_$LoanApplicationImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LoanApplicationImplToJson(
      this,
    );
  }
}

abstract class _LoanApplication implements LoanApplication {
  const factory _LoanApplication(
      {required final String applicationId,
      required final String icNumber,
      required final String loanType,
      required final double requestedAmount,
      required final int tenure,
      required final String purposeOfLoan,
      required final bool guarantorAvailable,
      required final LoanStatus status,
      required final List<String> requiredDocuments,
      required final List<String> uploadedDocuments,
      required final String applicationDate,
      required final String lastUpdated,
      final double? interestRate,
      final double? approvedAmount,
      final String? rejectionReason,
      final String? assignedOfficer,
      final String? officerRemarks,
      final double? mlConfidence}) = _$LoanApplicationImpl;

  factory _LoanApplication.fromJson(Map<String, dynamic> json) =
      _$LoanApplicationImpl.fromJson;

  @override
  String get applicationId;
  @override
  String get icNumber;
  @override
  String get loanType;
  @override
  double get requestedAmount;
  @override
  int get tenure;
  @override
  String get purposeOfLoan;
  @override
  bool get guarantorAvailable;
  @override
  LoanStatus get status;
  @override
  List<String> get requiredDocuments;
  @override
  List<String> get uploadedDocuments;
  @override
  String get applicationDate;
  @override
  String get lastUpdated;
  @override
  double? get interestRate;
  @override
  double? get approvedAmount;
  @override
  String? get rejectionReason;
  @override
  String? get assignedOfficer;
  @override
  String? get officerRemarks;
  @override
  double? get mlConfidence;
  @override
  @JsonKey(ignore: true)
  _$$LoanApplicationImplCopyWith<_$LoanApplicationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
