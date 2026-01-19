import '../../../core/api/api_service.dart';

class AuthApiService {
  final ApiService _apiService;

  AuthApiService(this._apiService);

  Future<Map<String, dynamic>> validateUsername({
    required String bankCode,
    required String username,
  }) async {
    return await _apiService.post(
      '/auth/validate-username',
      body: {
        'bankCode': bankCode,
        'username': username,
      },
    );
  }

  Future<Map<String, dynamic>> validatePassword({
    required String bankCode,
    required String username,
    required String password,
  }) async {
    return await _apiService.post(
      '/auth/validate-password',
      body: {
        'bankCode': bankCode,
        'username': username,
        'password': password,
      },
    );
  }

  Future<Map<String, dynamic>> sendOtp({
    required String bankCode,
    required String username,
  }) async {
    return await _apiService.post(
      '/auth/send-otp',
      body: {
        'bankCode': bankCode,
        'username': username,
      },
    );
  }

  Future<Map<String, dynamic>> verifyOtp({
    required String bankCode,
    required String username,
    required String otp,
  }) async {
    return await _apiService.post(
      '/auth/verify-otp',
      body: {
        'bankCode': bankCode,
        'username': username,
        'otp': otp,
      },
    );
  }

  Future<Map<String, dynamic>> completeAuthentication({
    required String bankId,
    required String username,
  }) async {
    return await _apiService.post(
      '/auth/complete-authentication',
      body: {
        'bankId': bankId,
        'username': username,
      },
    );
  }
}
