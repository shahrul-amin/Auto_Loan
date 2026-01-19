import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'dart:async';
import '../repositories/credit_score_repository.dart';
import '../repositories/backend_credit_score_repository.dart';
import '../../../core/api/api_config.dart';

part 'credit_providers.g.dart';

@riverpod
CreditScoreRepository creditScoreRepository(CreditScoreRepositoryRef ref) {
  return BackendCreditScoreRepository(
    baseUrl: ApiConfig.baseUrl.replaceAll('/api', ''),
  );
}

@riverpod
class CreditOverview extends _$CreditOverview {
  @override
  Future<Map<String, dynamic>> build(String icNumber) async {
    final repository = ref.watch(creditScoreRepositoryProvider);
    return await repository.getCreditOverview(icNumber);
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(creditScoreRepositoryProvider);
      return await repository.getCreditOverview(icNumber);
    });
  }
}
