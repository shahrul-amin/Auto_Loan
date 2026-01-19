import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/auth_state.dart';
import '../../banking/models/bank_model.dart';
import '../models/user_model.dart';
import '../providers/auth_providers.dart';

part 'auth_viewmodel.g.dart';

@riverpod
class AuthViewModel extends _$AuthViewModel {
  @override
  AuthState build() {
    // Check if user is already authenticated
    _checkAuthStatus();
    return const AuthState.initial();
  }

  Future<void> _checkAuthStatus() async {
    final repository = ref.read(authRepositoryProvider);
    final user = await repository.getCurrentUser();

    if (user != null) {
      state = AuthState.authenticated(user);
    } else {
      state = const AuthState.unauthenticated();
    }
  }

  void initiateBankLogin(Bank bank) {
    state = AuthState.bankSelectionInProgress(bank);
  }

  Future<void> completeAuthentication(String bankId, String username) async {
    state = const AuthState.authenticating();

    try {
      final repository = ref.read(authRepositoryProvider);
      final user = await repository.completeAuthentication(bankId, username);
      state = AuthState.authenticated(user);
    } catch (e) {
      state = AuthState.error('Authentication failed: ${e.toString()}');
    }
  }

  Future<bool> verifyOtp(String otp) async {
    try {
      final repository = ref.read(authRepositoryProvider);
      final isValid = await repository.verifyOtp(otp);

      if (!isValid) {
        state = const AuthState.error('Invalid OTP. Please try again.');
      }

      return isValid;
    } catch (e) {
      state = AuthState.error('OTP verification failed: ${e.toString()}');
      return false;
    }
  }

  Future<void> resendOtp() async {
    try {
      final repository = ref.read(authRepositoryProvider);
      await repository.resendOtp();
    } catch (e) {
      state = AuthState.error('Failed to resend OTP: ${e.toString()}');
    }
  }

  Future<void> logout() async {
    try {
      final repository = ref.read(authRepositoryProvider);
      await repository.logout();
      state = const AuthState.unauthenticated();
    } catch (e) {
      state = AuthState.error('Logout failed: ${e.toString()}');
    }
  }

  User? get currentUser {
    return state.maybeWhen(
      authenticated: (user) => user,
      orElse: () => null,
    );
  }
}
