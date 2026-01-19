// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'employment_info_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$employmentInfoRepositoryHash() =>
    r'0b5c17de91a7ea905067f7dc4d25bdb992883bbb';

/// See also [employmentInfoRepository].
@ProviderFor(employmentInfoRepository)
final employmentInfoRepositoryProvider =
    AutoDisposeProvider<EmploymentInfoRepository>.internal(
  employmentInfoRepository,
  name: r'employmentInfoRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$employmentInfoRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef EmploymentInfoRepositoryRef
    = AutoDisposeProviderRef<EmploymentInfoRepository>;
String _$employmentInfoHash() => r'f138604390a3315243e5c09e1f5785d61a9d672d';

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

/// See also [employmentInfo].
@ProviderFor(employmentInfo)
const employmentInfoProvider = EmploymentInfoFamily();

/// See also [employmentInfo].
class EmploymentInfoFamily extends Family<AsyncValue<EmploymentInfo?>> {
  /// See also [employmentInfo].
  const EmploymentInfoFamily();

  /// See also [employmentInfo].
  EmploymentInfoProvider call(
    String icNumber,
  ) {
    return EmploymentInfoProvider(
      icNumber,
    );
  }

  @override
  EmploymentInfoProvider getProviderOverride(
    covariant EmploymentInfoProvider provider,
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
  String? get name => r'employmentInfoProvider';
}

/// See also [employmentInfo].
class EmploymentInfoProvider
    extends AutoDisposeFutureProvider<EmploymentInfo?> {
  /// See also [employmentInfo].
  EmploymentInfoProvider(
    String icNumber,
  ) : this._internal(
          (ref) => employmentInfo(
            ref as EmploymentInfoRef,
            icNumber,
          ),
          from: employmentInfoProvider,
          name: r'employmentInfoProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$employmentInfoHash,
          dependencies: EmploymentInfoFamily._dependencies,
          allTransitiveDependencies:
              EmploymentInfoFamily._allTransitiveDependencies,
          icNumber: icNumber,
        );

  EmploymentInfoProvider._internal(
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
    FutureOr<EmploymentInfo?> Function(EmploymentInfoRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: EmploymentInfoProvider._internal(
        (ref) => create(ref as EmploymentInfoRef),
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
  AutoDisposeFutureProviderElement<EmploymentInfo?> createElement() {
    return _EmploymentInfoProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is EmploymentInfoProvider && other.icNumber == icNumber;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, icNumber.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin EmploymentInfoRef on AutoDisposeFutureProviderRef<EmploymentInfo?> {
  /// The parameter `icNumber` of this provider.
  String get icNumber;
}

class _EmploymentInfoProviderElement
    extends AutoDisposeFutureProviderElement<EmploymentInfo?>
    with EmploymentInfoRef {
  _EmploymentInfoProviderElement(super.provider);

  @override
  String get icNumber => (origin as EmploymentInfoProvider).icNumber;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
