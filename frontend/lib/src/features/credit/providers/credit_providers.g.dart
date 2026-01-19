// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'credit_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$creditScoreRepositoryHash() =>
    r'910c5949dc5745af6eb005c124c8b99a4012a201';

/// See also [creditScoreRepository].
@ProviderFor(creditScoreRepository)
final creditScoreRepositoryProvider =
    AutoDisposeProvider<CreditScoreRepository>.internal(
  creditScoreRepository,
  name: r'creditScoreRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$creditScoreRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef CreditScoreRepositoryRef
    = AutoDisposeProviderRef<CreditScoreRepository>;
String _$creditOverviewHash() => r'e043bb904c793bfce94af8079c6577e2c86ff661';

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

abstract class _$CreditOverview
    extends BuildlessAutoDisposeAsyncNotifier<Map<String, dynamic>> {
  late final String icNumber;

  FutureOr<Map<String, dynamic>> build(
    String icNumber,
  );
}

/// See also [CreditOverview].
@ProviderFor(CreditOverview)
const creditOverviewProvider = CreditOverviewFamily();

/// See also [CreditOverview].
class CreditOverviewFamily extends Family<AsyncValue<Map<String, dynamic>>> {
  /// See also [CreditOverview].
  const CreditOverviewFamily();

  /// See also [CreditOverview].
  CreditOverviewProvider call(
    String icNumber,
  ) {
    return CreditOverviewProvider(
      icNumber,
    );
  }

  @override
  CreditOverviewProvider getProviderOverride(
    covariant CreditOverviewProvider provider,
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
  String? get name => r'creditOverviewProvider';
}

/// See also [CreditOverview].
class CreditOverviewProvider extends AutoDisposeAsyncNotifierProviderImpl<
    CreditOverview, Map<String, dynamic>> {
  /// See also [CreditOverview].
  CreditOverviewProvider(
    String icNumber,
  ) : this._internal(
          () => CreditOverview()..icNumber = icNumber,
          from: creditOverviewProvider,
          name: r'creditOverviewProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$creditOverviewHash,
          dependencies: CreditOverviewFamily._dependencies,
          allTransitiveDependencies:
              CreditOverviewFamily._allTransitiveDependencies,
          icNumber: icNumber,
        );

  CreditOverviewProvider._internal(
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
  FutureOr<Map<String, dynamic>> runNotifierBuild(
    covariant CreditOverview notifier,
  ) {
    return notifier.build(
      icNumber,
    );
  }

  @override
  Override overrideWith(CreditOverview Function() create) {
    return ProviderOverride(
      origin: this,
      override: CreditOverviewProvider._internal(
        () => create()..icNumber = icNumber,
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
  AutoDisposeAsyncNotifierProviderElement<CreditOverview, Map<String, dynamic>>
      createElement() {
    return _CreditOverviewProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CreditOverviewProvider && other.icNumber == icNumber;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, icNumber.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin CreditOverviewRef
    on AutoDisposeAsyncNotifierProviderRef<Map<String, dynamic>> {
  /// The parameter `icNumber` of this provider.
  String get icNumber;
}

class _CreditOverviewProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<CreditOverview,
        Map<String, dynamic>> with CreditOverviewRef {
  _CreditOverviewProviderElement(super.provider);

  @override
  String get icNumber => (origin as CreditOverviewProvider).icNumber;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
