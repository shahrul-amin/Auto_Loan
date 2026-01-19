import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../banking/models/bank_model.dart';
import '../../banking/repositories/backend_banking_repository.dart';
import '../../banking/repositories/banking_repository.dart';
import '../../banking/services/banking_api_service.dart';
import '../../../core/api/api_providers.dart';

part 'bank_providers.g.dart';

@riverpod
BankingRepository bankingRepository(BankingRepositoryRef ref) {
  final apiService = ref.watch(apiServiceProvider);
  final bankingApiService = BankingApiService(apiService);
  return BackendBankingRepository(bankingApiService);
}

@riverpod
Future<List<Bank>> availableBanks(AvailableBanksRef ref) async {
  final repository = ref.watch(bankingRepositoryProvider);
  return await repository.getAllBanks();
}
