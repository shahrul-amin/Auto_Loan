import '../../auth/repositories/bank_repository.dart';
import '../../auth/services/auth_api_service.dart';

class BackendBankRepository implements BankRepository {
  final AuthApiService _authApiService;

  BackendBankRepository(this._authApiService);

  @override
  Future<String?> validateUsername(String bankCode, String username) async {
    try {
      final res = await _authApiService.validateUsername(
          bankCode: bankCode, username: username);
      if (res['success'] == true) return res['userIcon'] as String?;
      return null;
    } catch (e) {
      throw Exception('Failed to validate username: $e');
    }
  }

  @override
  Future<bool> validatePassword(
      String bankCode, String username, String password) async {
    try {
      final res = await _authApiService.validatePassword(
          bankCode: bankCode, username: username, password: password);
      return res['success'] == true;
    } catch (e) {
      throw Exception('Failed to validate password: $e');
    }
  }

  @override
  Future<void> sendOtp(String bankCode, String username) async {
    try {
      await _authApiService.sendOtp(bankCode: bankCode, username: username);
    } catch (e) {
      throw Exception('Failed to send OTP: $e');
    }
  }
}
