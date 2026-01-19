import 'package:freezed_annotation/freezed_annotation.dart';
import 'user_model.dart';
import '../../banking/models/bank_model.dart';

part 'auth_state.freezed.dart';

@freezed
class AuthState with _$AuthState {
  const factory AuthState.initial() = _Initial;
  const factory AuthState.unauthenticated() = _Unauthenticated;
  const factory AuthState.bankSelectionInProgress(Bank bank) =
      _BankSelectionInProgress;
  const factory AuthState.authenticating() = _Authenticating;
  const factory AuthState.authenticated(User user) = _Authenticated;
  const factory AuthState.error(String message) = _Error;
}
