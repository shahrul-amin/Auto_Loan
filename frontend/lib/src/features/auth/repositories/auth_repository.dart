import '../models/bank_user_model.dart';
import '../models/user_model.dart';

abstract class AuthRepository {
  Future<User> completeAuthentication(String bankId, String username);
  Future<bool> verifyOtp(String otp);
  Future<void> resendOtp();
  Future<void> logout();
  Future<User?> getCurrentUser();

  Future<BankUser?> getBankUser(String bankId, String username);

  Future<User?> getUser(String icNumber);
  Future<void> createUser(User user);
  Future<void> updateUser(User user);
  Future<void> updateProfileImage(String icNumber, String imageUrl);
  Future<void> addConnectedBank(String icNumber, String bankId);
}
