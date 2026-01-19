/// Abstract interface for bank authentication operations
abstract class BankRepository {
  /// Validate username and return user icon URL if valid
  Future<String?> validateUsername(String bankCode, String username);

  /// Validate password for given username
  Future<bool> validatePassword(
      String bankCode, String username, String password);

  /// Send OTP to user's registered mobile
  Future<void> sendOtp(String bankCode, String username);
}
