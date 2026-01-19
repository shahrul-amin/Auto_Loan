import 'package:freezed_annotation/freezed_annotation.dart';
import 'loan_application.dart';

part 'loan_application_form.freezed.dart';
part 'loan_application_form.g.dart';

@freezed
class LoanApplicationForm with _$LoanApplicationForm {
  const factory LoanApplicationForm({
    required String applicationId,
    required LoanType loanType,
    required double requestedAmount,
    required int tenure,
    required String purposeOfLoan,
    required bool guarantorAvailable,
    @Default([]) List<String> uploadedDocuments,
  }) = _LoanApplicationForm;

  factory LoanApplicationForm.fromJson(Map<String, dynamic> json) =>
      _$LoanApplicationFormFromJson(json);

  factory LoanApplicationForm.empty() => const LoanApplicationForm(
        applicationId: '',
        loanType: LoanType.personal,
        requestedAmount: 0,
        tenure: 1,
        purposeOfLoan: '',
        guarantorAvailable: false,
        uploadedDocuments: [],
      );
}

class RequiredDocument {
  final String name;
  final bool isOptional;
  final String? condition;

  const RequiredDocument({
    required this.name,
    this.isOptional = false,
    this.condition,
  });

  // Base required documents for all loan types
  static const identityCard =
      RequiredDocument(name: 'Identity card (IC/MyKad)');
  static const payslips3Months =
      RequiredDocument(name: "Latest 3 months' payslips");
  static const bankStatements3to6Months =
      RequiredDocument(name: "Latest 3-6 months' bank statements");
  static const employmentConfirmationLetter =
      RequiredDocument(name: 'Employment confirmation letter');

  // Conditional documents
  static const guarantorIdentityCard = RequiredDocument(
    name: 'Guarantor Identity Card',
    isOptional: true,
    condition: 'Required if guarantor is available',
  );

  // Housing specific
  static const salesPurchaseAgreement = RequiredDocument(
    name: 'Sales & Purchase Agreement (SPA)',
    condition: 'Required for housing loans',
  );
  static const propertyValuationReport = RequiredDocument(
    name: 'Property valuation report',
    condition: 'Required for housing loans',
  );

  // Vehicle specific
  static const drivingLicense = RequiredDocument(
    name: 'Driving license',
    condition: 'Required for vehicle loans',
  );
  static const vehicleQuotationInvoice = RequiredDocument(
    name: 'Vehicle quotation/invoice',
    condition: 'Required for vehicle loans',
  );

  static List<RequiredDocument> getRequiredDocuments({
    required LoanType loanType,
    required bool hasGuarantor,
  }) {
    final docs = <RequiredDocument>[
      identityCard,
      payslips3Months,
      bankStatements3to6Months,
      employmentConfirmationLetter,
    ];

    if (hasGuarantor) {
      docs.add(guarantorIdentityCard);
    }

    // Housing & Islamic Housing additional documents
    if (loanType == LoanType.housing || loanType == LoanType.islamicHousing) {
      docs.addAll([
        salesPurchaseAgreement,
        propertyValuationReport,
      ]);
    }

    // Vehicle loan additional documents
    if (loanType == LoanType.vehicle) {
      docs.addAll([
        drivingLicense,
        vehicleQuotationInvoice,
      ]);
    }

    return docs;
  }
}
