// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'loan_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$loanRepositoryHash() => r'5775da44a9c042edeb13cfae5f5d8631a048b754';

/// See also [loanRepository].
@ProviderFor(loanRepository)
final loanRepositoryProvider = AutoDisposeProvider<LoanRepository>.internal(
  loanRepository,
  name: r'loanRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$loanRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef LoanRepositoryRef = AutoDisposeProviderRef<LoanRepository>;
String _$loanViewModelHash() => r'042c1242dc688e6fbef25e24b1e3bf020ebae163';

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

abstract class _$LoanViewModel
    extends BuildlessAutoDisposeAsyncNotifier<List<LoanApplication>> {
  late final String icNumber;

  FutureOr<List<LoanApplication>> build(
    String icNumber,
  );
}

/// See also [LoanViewModel].
@ProviderFor(LoanViewModel)
const loanViewModelProvider = LoanViewModelFamily();

/// See also [LoanViewModel].
class LoanViewModelFamily extends Family<AsyncValue<List<LoanApplication>>> {
  /// See also [LoanViewModel].
  const LoanViewModelFamily();

  /// See also [LoanViewModel].
  LoanViewModelProvider call(
    String icNumber,
  ) {
    return LoanViewModelProvider(
      icNumber,
    );
  }

  @override
  LoanViewModelProvider getProviderOverride(
    covariant LoanViewModelProvider provider,
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
  String? get name => r'loanViewModelProvider';
}

/// See also [LoanViewModel].
class LoanViewModelProvider extends AutoDisposeAsyncNotifierProviderImpl<
    LoanViewModel, List<LoanApplication>> {
  /// See also [LoanViewModel].
  LoanViewModelProvider(
    String icNumber,
  ) : this._internal(
          () => LoanViewModel()..icNumber = icNumber,
          from: loanViewModelProvider,
          name: r'loanViewModelProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$loanViewModelHash,
          dependencies: LoanViewModelFamily._dependencies,
          allTransitiveDependencies:
              LoanViewModelFamily._allTransitiveDependencies,
          icNumber: icNumber,
        );

  LoanViewModelProvider._internal(
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
  FutureOr<List<LoanApplication>> runNotifierBuild(
    covariant LoanViewModel notifier,
  ) {
    return notifier.build(
      icNumber,
    );
  }

  @override
  Override overrideWith(LoanViewModel Function() create) {
    return ProviderOverride(
      origin: this,
      override: LoanViewModelProvider._internal(
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
  AutoDisposeAsyncNotifierProviderElement<LoanViewModel, List<LoanApplication>>
      createElement() {
    return _LoanViewModelProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is LoanViewModelProvider && other.icNumber == icNumber;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, icNumber.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin LoanViewModelRef
    on AutoDisposeAsyncNotifierProviderRef<List<LoanApplication>> {
  /// The parameter `icNumber` of this provider.
  String get icNumber;
}

class _LoanViewModelProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<LoanViewModel,
        List<LoanApplication>> with LoanViewModelRef {
  _LoanViewModelProviderElement(super.provider);

  @override
  String get icNumber => (origin as LoanViewModelProvider).icNumber;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
