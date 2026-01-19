// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'loan_application_form.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

LoanApplicationForm _$LoanApplicationFormFromJson(Map<String, dynamic> json) {
  return _LoanApplicationForm.fromJson(json);
}

/// @nodoc
mixin _$LoanApplicationForm {
  String get applicationId => throw _privateConstructorUsedError;
  LoanType get loanType => throw _privateConstructorUsedError;
  double get requestedAmount => throw _privateConstructorUsedError;
  int get tenure => throw _privateConstructorUsedError;
  String get purposeOfLoan => throw _privateConstructorUsedError;
  bool get guarantorAvailable => throw _privateConstructorUsedError;
  List<String> get uploadedDocuments => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $LoanApplicationFormCopyWith<LoanApplicationForm> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LoanApplicationFormCopyWith<$Res> {
  factory $LoanApplicationFormCopyWith(
          LoanApplicationForm value, $Res Function(LoanApplicationForm) then) =
      _$LoanApplicationFormCopyWithImpl<$Res, LoanApplicationForm>;
  @useResult
  $Res call(
      {String applicationId,
      LoanType loanType,
      double requestedAmount,
      int tenure,
      String purposeOfLoan,
      bool guarantorAvailable,
      List<String> uploadedDocuments});
}

/// @nodoc
class _$LoanApplicationFormCopyWithImpl<$Res, $Val extends LoanApplicationForm>
    implements $LoanApplicationFormCopyWith<$Res> {
  _$LoanApplicationFormCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? applicationId = null,
    Object? loanType = null,
    Object? requestedAmount = null,
    Object? tenure = null,
    Object? purposeOfLoan = null,
    Object? guarantorAvailable = null,
    Object? uploadedDocuments = null,
  }) {
    return _then(_value.copyWith(
      applicationId: null == applicationId
          ? _value.applicationId
          : applicationId // ignore: cast_nullable_to_non_nullable
              as String,
      loanType: null == loanType
          ? _value.loanType
          : loanType // ignore: cast_nullable_to_non_nullable
              as LoanType,
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
      uploadedDocuments: null == uploadedDocuments
          ? _value.uploadedDocuments
          : uploadedDocuments // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$LoanApplicationFormImplCopyWith<$Res>
    implements $LoanApplicationFormCopyWith<$Res> {
  factory _$$LoanApplicationFormImplCopyWith(_$LoanApplicationFormImpl value,
          $Res Function(_$LoanApplicationFormImpl) then) =
      __$$LoanApplicationFormImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String applicationId,
      LoanType loanType,
      double requestedAmount,
      int tenure,
      String purposeOfLoan,
      bool guarantorAvailable,
      List<String> uploadedDocuments});
}

/// @nodoc
class __$$LoanApplicationFormImplCopyWithImpl<$Res>
    extends _$LoanApplicationFormCopyWithImpl<$Res, _$LoanApplicationFormImpl>
    implements _$$LoanApplicationFormImplCopyWith<$Res> {
  __$$LoanApplicationFormImplCopyWithImpl(_$LoanApplicationFormImpl _value,
      $Res Function(_$LoanApplicationFormImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? applicationId = null,
    Object? loanType = null,
    Object? requestedAmount = null,
    Object? tenure = null,
    Object? purposeOfLoan = null,
    Object? guarantorAvailable = null,
    Object? uploadedDocuments = null,
  }) {
    return _then(_$LoanApplicationFormImpl(
      applicationId: null == applicationId
          ? _value.applicationId
          : applicationId // ignore: cast_nullable_to_non_nullable
              as String,
      loanType: null == loanType
          ? _value.loanType
          : loanType // ignore: cast_nullable_to_non_nullable
              as LoanType,
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
      uploadedDocuments: null == uploadedDocuments
          ? _value._uploadedDocuments
          : uploadedDocuments // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$LoanApplicationFormImpl implements _LoanApplicationForm {
  const _$LoanApplicationFormImpl(
      {required this.applicationId,
      required this.loanType,
      required this.requestedAmount,
      required this.tenure,
      required this.purposeOfLoan,
      required this.guarantorAvailable,
      final List<String> uploadedDocuments = const []})
      : _uploadedDocuments = uploadedDocuments;

  factory _$LoanApplicationFormImpl.fromJson(Map<String, dynamic> json) =>
      _$$LoanApplicationFormImplFromJson(json);

  @override
  final String applicationId;
  @override
  final LoanType loanType;
  @override
  final double requestedAmount;
  @override
  final int tenure;
  @override
  final String purposeOfLoan;
  @override
  final bool guarantorAvailable;
  final List<String> _uploadedDocuments;
  @override
  @JsonKey()
  List<String> get uploadedDocuments {
    if (_uploadedDocuments is EqualUnmodifiableListView)
      return _uploadedDocuments;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_uploadedDocuments);
  }

  @override
  String toString() {
    return 'LoanApplicationForm(applicationId: $applicationId, loanType: $loanType, requestedAmount: $requestedAmount, tenure: $tenure, purposeOfLoan: $purposeOfLoan, guarantorAvailable: $guarantorAvailable, uploadedDocuments: $uploadedDocuments)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LoanApplicationFormImpl &&
            (identical(other.applicationId, applicationId) ||
                other.applicationId == applicationId) &&
            (identical(other.loanType, loanType) ||
                other.loanType == loanType) &&
            (identical(other.requestedAmount, requestedAmount) ||
                other.requestedAmount == requestedAmount) &&
            (identical(other.tenure, tenure) || other.tenure == tenure) &&
            (identical(other.purposeOfLoan, purposeOfLoan) ||
                other.purposeOfLoan == purposeOfLoan) &&
            (identical(other.guarantorAvailable, guarantorAvailable) ||
                other.guarantorAvailable == guarantorAvailable) &&
            const DeepCollectionEquality()
                .equals(other._uploadedDocuments, _uploadedDocuments));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      applicationId,
      loanType,
      requestedAmount,
      tenure,
      purposeOfLoan,
      guarantorAvailable,
      const DeepCollectionEquality().hash(_uploadedDocuments));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$LoanApplicationFormImplCopyWith<_$LoanApplicationFormImpl> get copyWith =>
      __$$LoanApplicationFormImplCopyWithImpl<_$LoanApplicationFormImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LoanApplicationFormImplToJson(
      this,
    );
  }
}

abstract class _LoanApplicationForm implements LoanApplicationForm {
  const factory _LoanApplicationForm(
      {required final String applicationId,
      required final LoanType loanType,
      required final double requestedAmount,
      required final int tenure,
      required final String purposeOfLoan,
      required final bool guarantorAvailable,
      final List<String> uploadedDocuments}) = _$LoanApplicationFormImpl;

  factory _LoanApplicationForm.fromJson(Map<String, dynamic> json) =
      _$LoanApplicationFormImpl.fromJson;

  @override
  String get applicationId;
  @override
  LoanType get loanType;
  @override
  double get requestedAmount;
  @override
  int get tenure;
  @override
  String get purposeOfLoan;
  @override
  bool get guarantorAvailable;
  @override
  List<String> get uploadedDocuments;
  @override
  @JsonKey(ignore: true)
  _$$LoanApplicationFormImplCopyWith<_$LoanApplicationFormImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
