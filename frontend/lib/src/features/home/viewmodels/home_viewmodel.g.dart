// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$homeViewModelHash() => r'14a1ad9a6bee53cadfd2bc73b444d0ae20911f92';

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

abstract class _$HomeViewModel
    extends BuildlessAutoDisposeAsyncNotifier<HomeData> {
  late final String userId;

  FutureOr<HomeData> build(
    String userId,
  );
}

/// See also [HomeViewModel].
@ProviderFor(HomeViewModel)
const homeViewModelProvider = HomeViewModelFamily();

/// See also [HomeViewModel].
class HomeViewModelFamily extends Family<AsyncValue<HomeData>> {
  /// See also [HomeViewModel].
  const HomeViewModelFamily();

  /// See also [HomeViewModel].
  HomeViewModelProvider call(
    String userId,
  ) {
    return HomeViewModelProvider(
      userId,
    );
  }

  @override
  HomeViewModelProvider getProviderOverride(
    covariant HomeViewModelProvider provider,
  ) {
    return call(
      provider.userId,
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
  String? get name => r'homeViewModelProvider';
}

/// See also [HomeViewModel].
class HomeViewModelProvider
    extends AutoDisposeAsyncNotifierProviderImpl<HomeViewModel, HomeData> {
  /// See also [HomeViewModel].
  HomeViewModelProvider(
    String userId,
  ) : this._internal(
          () => HomeViewModel()..userId = userId,
          from: homeViewModelProvider,
          name: r'homeViewModelProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$homeViewModelHash,
          dependencies: HomeViewModelFamily._dependencies,
          allTransitiveDependencies:
              HomeViewModelFamily._allTransitiveDependencies,
          userId: userId,
        );

  HomeViewModelProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.userId,
  }) : super.internal();

  final String userId;

  @override
  FutureOr<HomeData> runNotifierBuild(
    covariant HomeViewModel notifier,
  ) {
    return notifier.build(
      userId,
    );
  }

  @override
  Override overrideWith(HomeViewModel Function() create) {
    return ProviderOverride(
      origin: this,
      override: HomeViewModelProvider._internal(
        () => create()..userId = userId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        userId: userId,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<HomeViewModel, HomeData>
      createElement() {
    return _HomeViewModelProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is HomeViewModelProvider && other.userId == userId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, userId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin HomeViewModelRef on AutoDisposeAsyncNotifierProviderRef<HomeData> {
  /// The parameter `userId` of this provider.
  String get userId;
}

class _HomeViewModelProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<HomeViewModel, HomeData>
    with HomeViewModelRef {
  _HomeViewModelProviderElement(super.provider);

  @override
  String get userId => (origin as HomeViewModelProvider).userId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
