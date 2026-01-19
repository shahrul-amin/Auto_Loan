// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

User _$UserFromJson(Map<String, dynamic> json) {
  return _User.fromJson(json);
}

/// @nodoc
mixin _$User {
  String get icNumber => throw _privateConstructorUsedError;
  String? get profileImageUrl => throw _privateConstructorUsedError;
  String? get surName => throw _privateConstructorUsedError;
  List<String> get connectedBanks => throw _privateConstructorUsedError;
  bool get dataConsentGiven => throw _privateConstructorUsedError;
  DateTime? get dataConsentDate => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UserCopyWith<User> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserCopyWith<$Res> {
  factory $UserCopyWith(User value, $Res Function(User) then) =
      _$UserCopyWithImpl<$Res, User>;
  @useResult
  $Res call(
      {String icNumber,
      String? profileImageUrl,
      String? surName,
      List<String> connectedBanks,
      bool dataConsentGiven,
      DateTime? dataConsentDate,
      DateTime createdAt});
}

/// @nodoc
class _$UserCopyWithImpl<$Res, $Val extends User>
    implements $UserCopyWith<$Res> {
  _$UserCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? icNumber = null,
    Object? profileImageUrl = freezed,
    Object? surName = freezed,
    Object? connectedBanks = null,
    Object? dataConsentGiven = null,
    Object? dataConsentDate = freezed,
    Object? createdAt = null,
  }) {
    return _then(_value.copyWith(
      icNumber: null == icNumber
          ? _value.icNumber
          : icNumber // ignore: cast_nullable_to_non_nullable
              as String,
      profileImageUrl: freezed == profileImageUrl
          ? _value.profileImageUrl
          : profileImageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      surName: freezed == surName
          ? _value.surName
          : surName // ignore: cast_nullable_to_non_nullable
              as String?,
      connectedBanks: null == connectedBanks
          ? _value.connectedBanks
          : connectedBanks // ignore: cast_nullable_to_non_nullable
              as List<String>,
      dataConsentGiven: null == dataConsentGiven
          ? _value.dataConsentGiven
          : dataConsentGiven // ignore: cast_nullable_to_non_nullable
              as bool,
      dataConsentDate: freezed == dataConsentDate
          ? _value.dataConsentDate
          : dataConsentDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UserImplCopyWith<$Res> implements $UserCopyWith<$Res> {
  factory _$$UserImplCopyWith(
          _$UserImpl value, $Res Function(_$UserImpl) then) =
      __$$UserImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String icNumber,
      String? profileImageUrl,
      String? surName,
      List<String> connectedBanks,
      bool dataConsentGiven,
      DateTime? dataConsentDate,
      DateTime createdAt});
}

/// @nodoc
class __$$UserImplCopyWithImpl<$Res>
    extends _$UserCopyWithImpl<$Res, _$UserImpl>
    implements _$$UserImplCopyWith<$Res> {
  __$$UserImplCopyWithImpl(_$UserImpl _value, $Res Function(_$UserImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? icNumber = null,
    Object? profileImageUrl = freezed,
    Object? surName = freezed,
    Object? connectedBanks = null,
    Object? dataConsentGiven = null,
    Object? dataConsentDate = freezed,
    Object? createdAt = null,
  }) {
    return _then(_$UserImpl(
      icNumber: null == icNumber
          ? _value.icNumber
          : icNumber // ignore: cast_nullable_to_non_nullable
              as String,
      profileImageUrl: freezed == profileImageUrl
          ? _value.profileImageUrl
          : profileImageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      surName: freezed == surName
          ? _value.surName
          : surName // ignore: cast_nullable_to_non_nullable
              as String?,
      connectedBanks: null == connectedBanks
          ? _value._connectedBanks
          : connectedBanks // ignore: cast_nullable_to_non_nullable
              as List<String>,
      dataConsentGiven: null == dataConsentGiven
          ? _value.dataConsentGiven
          : dataConsentGiven // ignore: cast_nullable_to_non_nullable
              as bool,
      dataConsentDate: freezed == dataConsentDate
          ? _value.dataConsentDate
          : dataConsentDate // ignore: cast_nullable_to_non_nullable
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
class _$UserImpl implements _User {
  const _$UserImpl(
      {required this.icNumber,
      this.profileImageUrl,
      this.surName,
      final List<String> connectedBanks = const [],
      this.dataConsentGiven = false,
      this.dataConsentDate,
      required this.createdAt})
      : _connectedBanks = connectedBanks;

  factory _$UserImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserImplFromJson(json);

  @override
  final String icNumber;
  @override
  final String? profileImageUrl;
  @override
  final String? surName;
  final List<String> _connectedBanks;
  @override
  @JsonKey()
  List<String> get connectedBanks {
    if (_connectedBanks is EqualUnmodifiableListView) return _connectedBanks;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_connectedBanks);
  }

  @override
  @JsonKey()
  final bool dataConsentGiven;
  @override
  final DateTime? dataConsentDate;
  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'User(icNumber: $icNumber, profileImageUrl: $profileImageUrl, surName: $surName, connectedBanks: $connectedBanks, dataConsentGiven: $dataConsentGiven, dataConsentDate: $dataConsentDate, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserImpl &&
            (identical(other.icNumber, icNumber) ||
                other.icNumber == icNumber) &&
            (identical(other.profileImageUrl, profileImageUrl) ||
                other.profileImageUrl == profileImageUrl) &&
            (identical(other.surName, surName) || other.surName == surName) &&
            const DeepCollectionEquality()
                .equals(other._connectedBanks, _connectedBanks) &&
            (identical(other.dataConsentGiven, dataConsentGiven) ||
                other.dataConsentGiven == dataConsentGiven) &&
            (identical(other.dataConsentDate, dataConsentDate) ||
                other.dataConsentDate == dataConsentDate) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      icNumber,
      profileImageUrl,
      surName,
      const DeepCollectionEquality().hash(_connectedBanks),
      dataConsentGiven,
      dataConsentDate,
      createdAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$UserImplCopyWith<_$UserImpl> get copyWith =>
      __$$UserImplCopyWithImpl<_$UserImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserImplToJson(
      this,
    );
  }
}

abstract class _User implements User {
  const factory _User(
      {required final String icNumber,
      final String? profileImageUrl,
      final String? surName,
      final List<String> connectedBanks,
      final bool dataConsentGiven,
      final DateTime? dataConsentDate,
      required final DateTime createdAt}) = _$UserImpl;

  factory _User.fromJson(Map<String, dynamic> json) = _$UserImpl.fromJson;

  @override
  String get icNumber;
  @override
  String? get profileImageUrl;
  @override
  String? get surName;
  @override
  List<String> get connectedBanks;
  @override
  bool get dataConsentGiven;
  @override
  DateTime? get dataConsentDate;
  @override
  DateTime get createdAt;
  @override
  @JsonKey(ignore: true)
  _$$UserImplCopyWith<_$UserImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
