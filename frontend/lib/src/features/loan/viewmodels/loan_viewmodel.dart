import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/loan_application.dart';
import '../models/loan_application_form.dart';
import '../repositories/loan_repository.dart';
import '../repositories/backend_loan_repository.dart';

part 'loan_viewmodel.g.dart';

@riverpod
LoanRepository loanRepository(LoanRepositoryRef ref) {
  return BackendLoanRepository();
}

@riverpod
class LoanViewModel extends _$LoanViewModel {
  @override
  Future<List<LoanApplication>> build(String icNumber) async {
    final repository = ref.read(loanRepositoryProvider);
    return repository.getUserLoanApplications(icNumber);
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(loanRepositoryProvider);
      return repository.getUserLoanApplications(icNumber);
    });
  }

  Future<LoanApplication> getLoanApplicationDetails(
      String applicationId) async {
    final repository = ref.read(loanRepositoryProvider);
    return repository.getLoanApplicationById(applicationId);
  }

  Future<LoanApplication> submitApplication(
    LoanApplicationForm form,
    String icNumber,
  ) async {
    final repository = ref.read(loanRepositoryProvider);
    final application = await repository.submitLoanApplication(form, icNumber);

    // Refresh the list after submission
    await refresh();

    return application;
  }
}
