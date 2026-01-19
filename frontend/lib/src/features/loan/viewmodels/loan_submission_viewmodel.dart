import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/loan_application.dart';
import '../models/loan_application_form.dart';
import 'loan_viewmodel.dart';

class LoanSubmissionViewModel
    extends StateNotifier<AsyncValue<LoanApplication?>> {
  LoanSubmissionViewModel(this._ref) : super(const AsyncValue.data(null));

  final Ref _ref;

  Future<void> submitLoanApplication(
    LoanApplicationForm form,
    String icNumber,
  ) async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      final loanViewModel = _ref.read(loanViewModelProvider(icNumber).notifier);
      return await loanViewModel.submitApplication(form, icNumber);
    });
  }

  void reset() {
    state = const AsyncValue.data(null);
  }
}

final loanSubmissionViewModelProvider = StateNotifierProvider<
    LoanSubmissionViewModel, AsyncValue<LoanApplication?>>(
  (ref) => LoanSubmissionViewModel(ref),
);
