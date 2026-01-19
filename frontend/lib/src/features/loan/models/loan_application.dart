import 'package:freezed_annotation/freezed_annotation.dart';
import 'loan_status.dart';

part 'loan_application.freezed.dart';
part 'loan_application.g.dart';

@freezed
class LoanApplication with _$LoanApplication {
  const factory LoanApplication({
    required String applicationId,
    required String icNumber,
    required String loanType,
    required double requestedAmount,
    required int tenure,
    required String purposeOfLoan,
    required bool guarantorAvailable,
    required LoanStatus status,
    required List<String> requiredDocuments,
    required List<String> uploadedDocuments,
    required String applicationDate,
    required String lastUpdated,
    double? interestRate,
    double? approvedAmount,
    String? rejectionReason,
    String? assignedOfficer,
    String? officerRemarks,
    double? mlConfidence,
  }) = _LoanApplication;

  factory LoanApplication.fromJson(Map<String, dynamic> json) =>
      _$LoanApplicationFromJson(json);
}

enum LoanType {
  @JsonValue('Housing')
  housing,
  @JsonValue('Islamic-Housing')
  islamicHousing,
  @JsonValue('Vehicle')
  vehicle,
  @JsonValue('Personal')
  personal,
  @JsonValue('Islamic-Personal')
  islamicPersonal,
}
