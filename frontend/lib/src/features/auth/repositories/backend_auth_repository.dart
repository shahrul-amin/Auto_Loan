import '../models/bank_user_model.dart';
import '../models/user_model.dart';
import 'auth_repository.dart';
import '../../auth/services/auth_api_service.dart';
import '../../profile/services/user_api_service.dart';

class BackendAuthRepository implements AuthRepository {
  final AuthApiService _apiService;
  final UserApiService _userApiService;

  BackendAuthRepository(this._apiService, this._userApiService);

  String? _currentBankCode;
  String? _validatedUsername;

  void setAuthContext(String bankCode, String username) {
    _currentBankCode = bankCode;
    _validatedUsername = username;
  }

  @override
  Future<BankUser?> getBankUser(String bankId, String username) async {
    try {
      final res = await _apiService.validateUsername(
          bankCode: bankId, username: username);

      if (res['success'] == true) {
        // Backend now returns icNumber along with userIcon
        return BankUser(
          bankId: bankId,
          username: username,
          passwordHash: '',
          icNumber: res['icNumber'] ?? '',
          accountNumber: '',
          createdAt: DateTime.now(),
        );
      }

      return null;
    } catch (e) {
      throw Exception('Failed to get bank user: $e');
    }
  }

  @override
  Future<User?> getUser(String icNumber) async {
    try {
      final res = await _userApiService.getUser(icNumber);
      if (res['success'] == true) {
        return User.fromJson(Map<String, dynamic>.from(res['user']));
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get user: $e');
    }
  }

  @override
  Future<void> createUser(User user) async {
    try {
      await _userApiService.createUser(user.toJson());
    } catch (e) {
      throw Exception('Failed to create user: $e');
    }
  }

  @override
  Future<void> updateUser(User user) async {
    try {
      await _userApiService.updateUser(user.icNumber, user.toJson());
    } catch (e) {
      throw Exception('Failed to update user: $e');
    }
  }

  @override
  Future<void> updateProfileImage(String icNumber, String imageUrl) async {
    try {
      await _userApiService.updateProfileImage(icNumber, imageUrl);
    } catch (e) {
      throw Exception('Failed to update profile image: $e');
    }
  }

  @override
  Future<void> addConnectedBank(String icNumber, String bankId) async {
    try {
      await _userApiService.addConnectedBank(icNumber, bankId);
    } catch (e) {
      throw Exception('Failed to add connected bank: $e');
    }
  }

  // The OTP/session is handled by backend endpoints via AuthApiService

  @override
  Future<User> completeAuthentication(String bankId, String username) async {
    final res = await _apiService.completeAuthentication(
        bankId: bankId, username: username);
    if (res['success'] == true && res['user'] != null) {
      return User.fromJson(Map<String, dynamic>.from(res['user']));
    }
    throw Exception('Failed to complete authentication');
  }

  @override
  Future<bool> verifyOtp(String otp) async {
    if (_currentBankCode == null || _validatedUsername == null) {
      throw Exception('No authentication session. Please login first.');
    }

    try {
      final res = await _apiService.verifyOtp(
        bankCode: _currentBankCode!,
        username: _validatedUsername!,
        otp: otp,
      );

      return res['success'] == true;
    } catch (e) {
      throw Exception('OTP verification failed: $e');
    }
  }

  @override
  Future<void> resendOtp() async {
    if (_currentBankCode == null || _validatedUsername == null) {
      throw Exception('No authentication session. Please login first.');
    }

    try {
      await _apiService.sendOtp(
        bankCode: _currentBankCode!,
        username: _validatedUsername!,
      );
    } catch (e) {
      throw Exception('Failed to resend OTP: $e');
    }
  }

  @override
  Future<void> logout() async {
    // clear any local session if needed
    return;
  }

  @override
  Future<User?> getCurrentUser() async {
    // Frontend should maintain current user session; fallback to API current endpoint is available
    return null;
  }
}
