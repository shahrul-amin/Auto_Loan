// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bank_user_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

BankUser _$BankUserFromJson(Map<String, dynamic> json) {
  return _BankUser.fromJson(json);
}

/// @nodoc
mixin _$BankUser {
  String get bankId => throw _privateConstructorUsedError;
  String get username => throw _privateConstructorUsedError;
  String get passwordHash => throw _privateConstructorUsedError;
  String get icNumber => throw _privateConstructorUsedError;
  String get accountNumber => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;
  DateTime? get lastLoginAt => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $BankUserCopyWith<BankUser> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BankUserCopyWith<$Res> {
  factory $BankUserCopyWith(BankUser value, $Res Function(BankUser) then) =
      _$BankUserCopyWithImpl<$Res, BankUser>;
  @useResult
  $Res call(
      {String bankId,
      String username,
      String passwordHash,
      String icNumber,
      String accountNumber,
      bool isActive,
      DateTime? lastLoginAt,
      DateTime createdAt});
}

/// @nodoc
class _$BankUserCopyWithImpl<$Res, $Val extends BankUser>
    implements $BankUserCopyWith<$Res> {
  _$BankUserCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? bankId = null,
    Object? username = null,
    Object? passwordHash = null,
    Object? icNumber = null,
    Object? accountNumber = null,
    Object? isActive = null,
    Object? lastLoginAt = freezed,
    Object? createdAt = null,
  }) {
    return _then(_value.copyWith(
      bankId: null == bankId
          ? _value.bankId
          : bankId // ignore: cast_nullable_to_non_nullable
              as String,
      username: null == username
          ? _value.username
          : username // ignore: cast_nullable_to_non_nullable
              as String,
      passwordHash: null == passwordHash
          ? _value.passwordHash
          : passwordHash // ignore: cast_nullable_to_non_nullable
              as String,
      icNumber: null == icNumber
          ? _value.icNumber
          : icNumber // ignore: cast_nullable_to_non_nullable
              as String,
      accountNumber: null == accountNumber
          ? _value.accountNumber
          : accountNumber // ignore: cast_nullable_to_non_nullable
              as String,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      lastLoginAt: freezed == lastLoginAt
          ? _value.lastLoginAt
          : lastLoginAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BankUserImplCopyWith<$Res>
    implements $BankUserCopyWith<$Res> {
  factory _$$BankUserImplCopyWith(
          _$BankUserImpl value, $Res Function(_$BankUserImpl) then) =
      __$$BankUserImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String bankId,
      String username,
      String passwordHash,
      String icNumber,
      String accountNumber,
      bool isActive,
      DateTime? lastLoginAt,
      DateTime createdAt});
}

/// @nodoc
class __$$BankUserImplCopyWithImpl<$Res>
    extends _$BankUserCopyWithImpl<$Res, _$BankUserImpl>
    implements _$$BankUserImplCopyWith<$Res> {
  __$$BankUserImplCopyWithImpl(
      _$BankUserImpl _value, $Res Function(_$BankUserImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? bankId = null,
    Object? username = null,
    Object? passwordHash = null,
    Object? icNumber = null,
    Object? accountNumber = null,
    Object? isActive = null,
    Object? lastLoginAt = freezed,
    Object? createdAt = null,
  }) {
    return _then(_$BankUserImpl(
      bankId: null == bankId
          ? _value.bankId
          : bankId // ignore: cast_nullable_to_non_nullable
              as String,
      username: null == username
          ? _value.username
          : username // ignore: cast_nullable_to_non_nullable
              as String,
      passwordHash: null == passwordHash
          ? _value.passwordHash
          : passwordHash // ignore: cast_nullable_to_non_nullable
              as String,
      icNumber: null == icNumber
          ? _value.icNumber
          : icNumber // ignore: cast_nullable_to_non_nullable
              as String,
      accountNumber: null == accountNumber
          ? _value.accountNumber
          : accountNumber // ignore: cast_nullable_to_non_nullable
              as String,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      lastLoginAt: freezed == lastLoginAt
          ? _value.lastLoginAt
          : lastLoginAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BankUserImpl implements _BankUser {
  const _$BankUserImpl(
      {required this.bankId,
      required this.username,
      required this.passwordHash,
      required this.icNumber,
      required this.accountNumber,
      this.isActive = true,
      this.lastLoginAt,
      required this.createdAt});

  factory _$BankUserImpl.fromJson(Map<String, dynamic> json) =>
      _$$BankUserImplFromJson(json);

  @override
  final String bankId;
  @override
  final String username;
  @override
  final String passwordHash;
  @override
  final String icNumber;
  @override
  final String accountNumber;
  @override
  @JsonKey()
  final bool isActive;
  @override
  final DateTime? lastLoginAt;
  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'BankUser(bankId: $bankId, username: $username, passwordHash: $passwordHash, icNumber: $icNumber, accountNumber: $accountNumber, isActive: $isActive, lastLoginAt: $lastLoginAt, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BankUserImpl &&
            (identical(other.bankId, bankId) || other.bankId == bankId) &&
            (identical(other.username, username) ||
                other.username == username) &&
            (identical(other.passwordHash, passwordHash) ||
                other.passwordHash == passwordHash) &&
            (identical(other.icNumber, icNumber) ||
                other.icNumber == icNumber) &&
            (identical(other.accountNumber, accountNumber) ||
                other.accountNumber == accountNumber) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.lastLoginAt, lastLoginAt) ||
                other.lastLoginAt == lastLoginAt) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, bankId, username, passwordHash,
      icNumber, accountNumber, isActive, lastLoginAt, createdAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$BankUserImplCopyWith<_$BankUserImpl> get copyWith =>
      __$$BankUserImplCopyWithImpl<_$BankUserImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BankUserImplToJson(
      this,
    );
  }
}

abstract class _BankUser implements BankUser {
  const factory _BankUser(
      {required final String bankId,
      required final String username,
      required final String passwordHash,
      required final String icNumber,
      required final String accountNumber,
      final bool isActive,
      final DateTime? lastLoginAt,
      required final DateTime createdAt}) = _$BankUserImpl;

  factory _BankUser.fromJson(Map<String, dynamic> json) =
      _$BankUserImpl.fromJson;

  @override
  String get bankId;
  @override
  String get username;
  @override
  String get passwordHash;
  @override
  String get icNumber;
  @override
  String get accountNumber;
  @override
  bool get isActive;
  @override
  DateTime? get lastLoginAt;
  @override
  DateTime get createdAt;
  @override
  @JsonKey(ignore: true)
  _$$BankUserImplCopyWith<_$BankUserImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
