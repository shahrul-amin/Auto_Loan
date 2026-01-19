import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../repositories/auth_repository.dart';
import '../repositories/bank_repository.dart';
import '../repositories/backend_auth_repository.dart';
import '../repositories/backend_bank_repository.dart';
import '../../../core/api/api_providers.dart';
import '../services/auth_api_service.dart';
import '../../profile/services/user_api_service.dart';

part 'auth_providers.g.dart';

@Riverpod(keepAlive: true)
AuthRepository authRepository(AuthRepositoryRef ref) {
  final api = ref.read(apiServiceProvider);
  final authApi = AuthApiService(api);
  final userApi = UserApiService(api);
  return BackendAuthRepository(authApi, userApi);
}

@Riverpod(keepAlive: true)
BankRepository bankRepository(BankRepositoryRef ref) {
  final api = ref.read(apiServiceProvider);
  final authApi = AuthApiService(api);
  return BackendBankRepository(authApi);
}
