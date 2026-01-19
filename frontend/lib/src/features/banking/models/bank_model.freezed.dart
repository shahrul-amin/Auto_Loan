// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bank_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Bank _$BankFromJson(Map<String, dynamic> json) {
  return _Bank.fromJson(json);
}

/// @nodoc
mixin _$Bank {
  String get bankId => throw _privateConstructorUsedError;
  String get bankName => throw _privateConstructorUsedError;
  String get code => throw _privateConstructorUsedError;
  String get bankLogoUrl => throw _privateConstructorUsedError;
  String get primaryColor => throw _privateConstructorUsedError;
  String get secondaryColor => throw _privateConstructorUsedError;
  String get onlineBankingName => throw _privateConstructorUsedError;
  String get websiteUrl => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $BankCopyWith<Bank> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BankCopyWith<$Res> {
  factory $BankCopyWith(Bank value, $Res Function(Bank) then) =
      _$BankCopyWithImpl<$Res, Bank>;
  @useResult
  $Res call(
      {String bankId,
      String bankName,
      String code,
      String bankLogoUrl,
      String primaryColor,
      String secondaryColor,
      String onlineBankingName,
      String websiteUrl,
      bool isActive});
}

/// @nodoc
class _$BankCopyWithImpl<$Res, $Val extends Bank>
    implements $BankCopyWith<$Res> {
  _$BankCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? bankId = null,
    Object? bankName = null,
    Object? code = null,
    Object? bankLogoUrl = null,
    Object? primaryColor = null,
    Object? secondaryColor = null,
    Object? onlineBankingName = null,
    Object? websiteUrl = null,
    Object? isActive = null,
  }) {
    return _then(_value.copyWith(
      bankId: null == bankId
          ? _value.bankId
          : bankId // ignore: cast_nullable_to_non_nullable
              as String,
      bankName: null == bankName
          ? _value.bankName
          : bankName // ignore: cast_nullable_to_non_nullable
              as String,
      code: null == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as String,
      bankLogoUrl: null == bankLogoUrl
          ? _value.bankLogoUrl
          : bankLogoUrl // ignore: cast_nullable_to_non_nullable
              as String,
      primaryColor: null == primaryColor
          ? _value.primaryColor
          : primaryColor // ignore: cast_nullable_to_non_nullable
              as String,
      secondaryColor: null == secondaryColor
          ? _value.secondaryColor
          : secondaryColor // ignore: cast_nullable_to_non_nullable
              as String,
      onlineBankingName: null == onlineBankingName
          ? _value.onlineBankingName
          : onlineBankingName // ignore: cast_nullable_to_non_nullable
              as String,
      websiteUrl: null == websiteUrl
          ? _value.websiteUrl
          : websiteUrl // ignore: cast_nullable_to_non_nullable
              as String,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BankImplCopyWith<$Res> implements $BankCopyWith<$Res> {
  factory _$$BankImplCopyWith(
          _$BankImpl value, $Res Function(_$BankImpl) then) =
      __$$BankImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String bankId,
      String bankName,
      String code,
      String bankLogoUrl,
      String primaryColor,
      String secondaryColor,
      String onlineBankingName,
      String websiteUrl,
      bool isActive});
}

/// @nodoc
class __$$BankImplCopyWithImpl<$Res>
    extends _$BankCopyWithImpl<$Res, _$BankImpl>
    implements _$$BankImplCopyWith<$Res> {
  __$$BankImplCopyWithImpl(_$BankImpl _value, $Res Function(_$BankImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? bankId = null,
    Object? bankName = null,
    Object? code = null,
    Object? bankLogoUrl = null,
    Object? primaryColor = null,
    Object? secondaryColor = null,
    Object? onlineBankingName = null,
    Object? websiteUrl = null,
    Object? isActive = null,
  }) {
    return _then(_$BankImpl(
      bankId: null == bankId
          ? _value.bankId
          : bankId // ignore: cast_nullable_to_non_nullable
              as String,
      bankName: null == bankName
          ? _value.bankName
          : bankName // ignore: cast_nullable_to_non_nullable
              as String,
      code: null == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as String,
      bankLogoUrl: null == bankLogoUrl
          ? _value.bankLogoUrl
          : bankLogoUrl // ignore: cast_nullable_to_non_nullable
              as String,
      primaryColor: null == primaryColor
          ? _value.primaryColor
          : primaryColor // ignore: cast_nullable_to_non_nullable
              as String,
      secondaryColor: null == secondaryColor
          ? _value.secondaryColor
          : secondaryColor // ignore: cast_nullable_to_non_nullable
              as String,
      onlineBankingName: null == onlineBankingName
          ? _value.onlineBankingName
          : onlineBankingName // ignore: cast_nullable_to_non_nullable
              as String,
      websiteUrl: null == websiteUrl
          ? _value.websiteUrl
          : websiteUrl // ignore: cast_nullable_to_non_nullable
              as String,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BankImpl implements _Bank {
  const _$BankImpl(
      {required this.bankId,
      required this.bankName,
      required this.code,
      required this.bankLogoUrl,
      required this.primaryColor,
      required this.secondaryColor,
      required this.onlineBankingName,
      required this.websiteUrl,
      this.isActive = true});

  factory _$BankImpl.fromJson(Map<String, dynamic> json) =>
      _$$BankImplFromJson(json);

  @override
  final String bankId;
  @override
  final String bankName;
  @override
  final String code;
  @override
  final String bankLogoUrl;
  @override
  final String primaryColor;
  @override
  final String secondaryColor;
  @override
  final String onlineBankingName;
  @override
  final String websiteUrl;
  @override
  @JsonKey()
  final bool isActive;

  @override
  String toString() {
    return 'Bank(bankId: $bankId, bankName: $bankName, code: $code, bankLogoUrl: $bankLogoUrl, primaryColor: $primaryColor, secondaryColor: $secondaryColor, onlineBankingName: $onlineBankingName, websiteUrl: $websiteUrl, isActive: $isActive)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BankImpl &&
            (identical(other.bankId, bankId) || other.bankId == bankId) &&
            (identical(other.bankName, bankName) ||
                other.bankName == bankName) &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.bankLogoUrl, bankLogoUrl) ||
                other.bankLogoUrl == bankLogoUrl) &&
            (identical(other.primaryColor, primaryColor) ||
                other.primaryColor == primaryColor) &&
            (identical(other.secondaryColor, secondaryColor) ||
                other.secondaryColor == secondaryColor) &&
            (identical(other.onlineBankingName, onlineBankingName) ||
                other.onlineBankingName == onlineBankingName) &&
            (identical(other.websiteUrl, websiteUrl) ||
                other.websiteUrl == websiteUrl) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      bankId,
      bankName,
      code,
      bankLogoUrl,
      primaryColor,
      secondaryColor,
      onlineBankingName,
      websiteUrl,
      isActive);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$BankImplCopyWith<_$BankImpl> get copyWith =>
      __$$BankImplCopyWithImpl<_$BankImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BankImplToJson(
      this,
    );
  }
}

abstract class _Bank implements Bank {
  const factory _Bank(
      {required final String bankId,
      required final String bankName,
      required final String code,
      required final String bankLogoUrl,
      required final String primaryColor,
      required final String secondaryColor,
      required final String onlineBankingName,
      required final String websiteUrl,
      final bool isActive}) = _$BankImpl;

  factory _Bank.fromJson(Map<String, dynamic> json) = _$BankImpl.fromJson;

  @override
  String get bankId;
  @override
  String get bankName;
  @override
  String get code;
  @override
  String get bankLogoUrl;
  @override
  String get primaryColor;
  @override
  String get secondaryColor;
  @override
  String get onlineBankingName;
  @override
  String get websiteUrl;
  @override
  bool get isActive;
  @override
  @JsonKey(ignore: true)
  _$$BankImplCopyWith<_$BankImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
