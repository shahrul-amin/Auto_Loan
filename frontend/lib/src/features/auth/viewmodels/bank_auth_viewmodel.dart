import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/bank_auth_state.dart';
import '../providers/auth_providers.dart';
import '../repositories/backend_auth_repository.dart';

part 'bank_auth_viewmodel.g.dart';

@riverpod
class BankAuthViewModel extends _$BankAuthViewModel {
  String? _validatedUsername;
  String? _currentBankCode;

  @override
  BankAuthState build() {
    return const BankAuthState.initial();
  }

  void reset() {
    _validatedUsername = null;
    _currentBankCode = null;
    state = const BankAuthState.initial();
  }

  Future<String?> validateUsername(String bankCode, String username) async {
    if (username.trim().isEmpty) {
      state = const BankAuthState.usernameInvalid('Username cannot be empty');
      return null;
    }

    state = const BankAuthState.usernameValidating();
    _currentBankCode = bankCode;

    try {
      final repository = ref.read(bankRepositoryProvider);
      final userIcon = await repository.validateUsername(bankCode, username);

      if (userIcon != null) {
        _validatedUsername = username;
        state = BankAuthState.usernameValid(userIcon);
        return userIcon;
      } else {
        state = const BankAuthState.usernameInvalid(
          'Username not found. Please check and try again.',
        );
        return null;
      }
    } catch (e) {
      state = BankAuthState.error('Error validating username: ${e.toString()}');
      return null;
    }
  }

  Future<bool> validatePassword(String password) async {
    if (_validatedUsername == null || _currentBankCode == null) {
      state = const BankAuthState.error('Please validate username first');
      return false;
    }

    if (password.trim().isEmpty) {
      state = const BankAuthState.passwordInvalid('Password cannot be empty');
      return false;
    }

    state = const BankAuthState.passwordValidating();

    try {
      final repository = ref.read(bankRepositoryProvider);
      final isValid = await repository.validatePassword(
        _currentBankCode!,
        _validatedUsername!,
        password,
      );

      if (isValid) {
        // Send OTP
        await repository.sendOtp(_currentBankCode!, _validatedUsername!);

        // Set authentication context in auth repository for OTP verification
        final authRepository = ref.read(authRepositoryProvider);
        if (authRepository is BackendAuthRepository) {
          authRepository.setAuthContext(_currentBankCode!, _validatedUsername!);
        }

        state = const BankAuthState.otpSent(
          'OTP has been sent to your registered mobile number',
        );
        return true;
      } else {
        state = const BankAuthState.passwordInvalid(
          'Incorrect password. Please try again.',
        );
        return false;
      }
    } catch (e) {
      state = BankAuthState.error('Error validating password: ${e.toString()}');
      return false;
    }
  }

  String? get validatedUsername => _validatedUsername;
  String? get currentBankCode => _currentBankCode;
}
