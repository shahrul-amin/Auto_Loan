import '../models/loan_application.dart';
import '../models/loan_application_form.dart';
import '../models/loan_status.dart';
import 'loan_repository.dart';
import '../../../core/api/api_service.dart';

class BackendLoanRepository implements LoanRepository {
  final ApiService _apiService;

  BackendLoanRepository({ApiService? apiService})
      : _apiService = apiService ?? ApiService();

  @override
  Future<List<LoanApplication>> getUserLoanApplications(String icNumber) async {
    try {
      final response = await _apiService.get('/loan-applications/$icNumber');

      if (response['success'] == true && response['data'] != null) {
        final List<dynamic> applicationsData = response['data'] as List;
        return applicationsData
            .map((appJson) =>
                LoanApplication.fromJson(appJson as Map<String, dynamic>))
            .toList();
      }

      throw Exception('Failed to load loan applications');
    } catch (e) {
      throw Exception('Failed to fetch loan applications: $e');
    }
  }

  @override
  Future<LoanApplication> getLoanApplicationById(String applicationId) async {
    try {
      final response = await _apiService
          .get('/loan-applications/application/$applicationId');

      if (response['success'] == true && response['data'] != null) {
        final Map<String, dynamic> applicationData =
            response['data'] as Map<String, dynamic>;
        return LoanApplication.fromJson(applicationData);
      }

      throw Exception('Loan application not found');
    } catch (e) {
      throw Exception('Failed to fetch loan application details: $e');
    }
  }

  @override
  Future<LoanApplication> submitLoanApplication(
    LoanApplicationForm form,
    String icNumber,
  ) async {
    try {
      final requestBody = {
        'applicationId': form.applicationId,
        'icNumber': icNumber,
        'loanType': _getLoanTypeString(form.loanType),
        'requestedAmount': form.requestedAmount,
        'tenure': form.tenure,
        'purposeOfLoan': form.purposeOfLoan,
        'guarantorAvailable': form.guarantorAvailable,
        'uploadedDocuments': form.uploadedDocuments,
      };

      final response = await _apiService.post(
        '/loan-applications/',
        body: requestBody,
      );

      if (response['success'] == true && response['data'] != null) {
        final applicationData = response['data'] as Map<String, dynamic>;

        // Create a minimal LoanApplication object with the returned data
        return LoanApplication(
          applicationId: applicationData['applicationId'] as String,
          icNumber: icNumber,
          loanType: _getLoanTypeString(form.loanType),
          requestedAmount: form.requestedAmount,
          tenure: form.tenure,
          purposeOfLoan: form.purposeOfLoan,
          guarantorAvailable: form.guarantorAvailable,
          status: LoanStatus.pending,
          requiredDocuments: [],
          uploadedDocuments: form.uploadedDocuments,
          applicationDate: applicationData['applicationDate'] as String? ??
              DateTime.now().toIso8601String(),
          lastUpdated: DateTime.now().toIso8601String(),
        );
      }

      // Handle error response
      if (response['error'] != null) {
        final errorMessage = response['message'] as String? ?? 'Unknown error';
        throw Exception(errorMessage);
      }

      throw Exception('Failed to submit loan application');
    } catch (e) {
      throw Exception('Failed to submit loan application: $e');
    }
  }

  String _getLoanTypeString(LoanType type) {
    switch (type) {
      case LoanType.housing:
        return 'Housing';
      case LoanType.islamicHousing:
        return 'IslamicHousing';
      case LoanType.vehicle:
        return 'Vehicle';
      case LoanType.personal:
        return 'Personal';
      case LoanType.islamicPersonal:
        return 'IslamicPersonal';
    }
  }
}
