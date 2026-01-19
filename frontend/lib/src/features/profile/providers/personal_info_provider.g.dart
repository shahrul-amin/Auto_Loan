// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'personal_info_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$personalInfoRepositoryHash() =>
    r'19c6244828e568b67db43ab7c14dc4c066df7aae';

/// See also [personalInfoRepository].
@ProviderFor(personalInfoRepository)
final personalInfoRepositoryProvider =
    Provider<PersonalInfoRepository>.internal(
  personalInfoRepository,
  name: r'personalInfoRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$personalInfoRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef PersonalInfoRepositoryRef = ProviderRef<PersonalInfoRepository>;
String _$personalInfoHash() => r'a9df72f453a1e0010089c80202bd6c647bad1865';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [personalInfo].
@ProviderFor(personalInfo)
const personalInfoProvider = PersonalInfoFamily();

/// See also [personalInfo].
class PersonalInfoFamily extends Family<AsyncValue<PersonalInfo?>> {
  /// See also [personalInfo].
  const PersonalInfoFamily();

  /// See also [personalInfo].
  PersonalInfoProvider call(
    String icNumber,
  ) {
    return PersonalInfoProvider(
      icNumber,
    );
  }

  @override
  PersonalInfoProvider getProviderOverride(
    covariant PersonalInfoProvider provider,
  ) {
    return call(
      provider.icNumber,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'personalInfoProvider';
}

/// See also [personalInfo].
class PersonalInfoProvider extends AutoDisposeFutureProvider<PersonalInfo?> {
  /// See also [personalInfo].
  PersonalInfoProvider(
    String icNumber,
  ) : this._internal(
          (ref) => personalInfo(
            ref as PersonalInfoRef,
            icNumber,
          ),
          from: personalInfoProvider,
          name: r'personalInfoProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$personalInfoHash,
          dependencies: PersonalInfoFamily._dependencies,
          allTransitiveDependencies:
              PersonalInfoFamily._allTransitiveDependencies,
          icNumber: icNumber,
        );

  PersonalInfoProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.icNumber,
  }) : super.internal();

  final String icNumber;

  @override
  Override overrideWith(
    FutureOr<PersonalInfo?> Function(PersonalInfoRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: PersonalInfoProvider._internal(
        (ref) => create(ref as PersonalInfoRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        icNumber: icNumber,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<PersonalInfo?> createElement() {
    return _PersonalInfoProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is PersonalInfoProvider && other.icNumber == icNumber;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, icNumber.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin PersonalInfoRef on AutoDisposeFutureProviderRef<PersonalInfo?> {
  /// The parameter `icNumber` of this provider.
  String get icNumber;
}

class _PersonalInfoProviderElement
    extends AutoDisposeFutureProviderElement<PersonalInfo?>
    with PersonalInfoRef {
  _PersonalInfoProviderElement(super.provider);

  @override
  String get icNumber => (origin as PersonalInfoProvider).icNumber;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
