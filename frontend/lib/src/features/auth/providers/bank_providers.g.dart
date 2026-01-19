// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bank_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$bankingRepositoryHash() => r'8d7eae70aafd028ad733b27f5e336d9cb7dd1e9a';

/// See also [bankingRepository].
@ProviderFor(bankingRepository)
final bankingRepositoryProvider =
    AutoDisposeProvider<BankingRepository>.internal(
  bankingRepository,
  name: r'bankingRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$bankingRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef BankingRepositoryRef = AutoDisposeProviderRef<BankingRepository>;
String _$availableBanksHash() => r'e322660e9b12a30ee56200f834693a621f503dff';

/// See also [availableBanks].
@ProviderFor(availableBanks)
final availableBanksProvider = AutoDisposeFutureProvider<List<Bank>>.internal(
  availableBanks,
  name: r'availableBanksProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$availableBanksHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef AvailableBanksRef = AutoDisposeFutureProviderRef<List<Bank>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
