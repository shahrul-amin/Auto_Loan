import 'package:freezed_annotation/freezed_annotation.dart';

part 'bank_auth_state.freezed.dart';

@freezed
class BankAuthState with _$BankAuthState {
  const factory BankAuthState.initial() = _Initial;
  const factory BankAuthState.usernameValidating() = _UsernameValidating;
  const factory BankAuthState.usernameValid(String userIconUrl) =
      _UsernameValid;
  const factory BankAuthState.usernameInvalid(String message) =
      _UsernameInvalid;
  const factory BankAuthState.passwordValidating() = _PasswordValidating;
  const factory BankAuthState.passwordValid() = _PasswordValid;
  const factory BankAuthState.passwordInvalid(String message) =
      _PasswordInvalid;
  const factory BankAuthState.otpSent(String message) = _OtpSent;
  const factory BankAuthState.error(String message) = _Error;
}
