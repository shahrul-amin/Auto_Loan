import '../models/loan_application.dart';
import '../models/loan_application_form.dart';

abstract class LoanRepository {
  Future<List<LoanApplication>> getUserLoanApplications(String icNumber);
  Future<LoanApplication> getLoanApplicationById(String applicationId);
  Future<LoanApplication> submitLoanApplication(
    LoanApplicationForm form,
    String icNumber,
  );
}
