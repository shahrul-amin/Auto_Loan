import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_primary_button.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/providers/storage_provider.dart';
import '../models/loan_application.dart';
import '../models/loan_application_form.dart';
import '../viewmodels/loan_submission_viewmodel.dart';
import '../viewmodels/loan_viewmodel.dart';

class LoanApplicationStep3Details extends ConsumerStatefulWidget {
  const LoanApplicationStep3Details({
    required this.icNumber,
    super.key,
  });

  final String icNumber;

  @override
  ConsumerState<LoanApplicationStep3Details> createState() =>
      _LoanApplicationStep3DetailsState();
}

class _LoanApplicationStep3DetailsState
    extends ConsumerState<LoanApplicationStep3Details> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _purposeController = TextEditingController();

  LoanType _selectedLoanType = LoanType.personal;
  int _selectedTenure = 1;
  bool _hasGuarantor = false;
  final Map<String, String> _selectedFiles = {}; // docName -> filePath
  final Map<String, String> _uploadingDocuments = {};
  bool _documentsValidationAttempted = false;

  @override
  void dispose() {
    _amountController.dispose();
    _purposeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface.withOpacity(0.85),
      ),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: AppSpacing.screenPadding,
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Loan Application Details',
                      style: AppTextStyles.headingMedium.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    AppSpacing.verticalSpaceXS,
                    Text(
                      'Fill in the details below',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textTertiary,
                      ),
                    ),
                    AppSpacing.verticalSpaceXL,
                    _buildLoanTypeSection(),
                    AppSpacing.verticalSpaceLG,
                    _buildAmountSection(),
                    AppSpacing.verticalSpaceLG,
                    _buildTenureSection(),
                    AppSpacing.verticalSpaceLG,
                    _buildPurposeSection(),
                    AppSpacing.verticalSpaceLG,
                    _buildGuarantorSection(),
                    AppSpacing.verticalSpaceLG,
                    _buildDocumentsSection(),
                    AppSpacing.verticalSpaceXXL,
                  ],
                ),
              ),
            ),
          ),
          Container(
            padding: AppSpacing.screenPadding,
            decoration: BoxDecoration(
              color: AppColors.surface.withOpacity(0.95),
              border: const Border(
                top: BorderSide(color: AppColors.border, width: 1),
              ),
            ),
            child: AppPrimaryButton(
              onPressed: _handleSubmit,
              label: 'Submit Application',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoanTypeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Loan Type',
          style: AppTextStyles.labelMedium.copyWith(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<LoanType>(
          value: _selectedLoanType,
          items: LoanType.values
              .map(
                (type) => DropdownMenuItem<LoanType>(
                  value: type,
                  child: Text(
                    _getLoanTypeLabel(type),
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              )
              .toList(),
          onChanged: (value) {
            if (value == null) return;
            setState(() {
              _selectedLoanType = value;
            });
          },
          dropdownColor: AppColors.surfaceVariant,
          iconEnabledColor: AppColors.textSecondary,
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textPrimary,
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.surfaceVariant.withOpacity(0.3),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.border, width: 1),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.border, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:
                  const BorderSide(color: AppColors.primaryBlue, width: 2),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
        ),
      ],
    );
  }

  Widget _buildAmountSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Requested Amount',
          style: AppTextStyles.labelMedium.copyWith(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        AppTextField(
          controller: _amountController,
          label: 'Enter amount in RM',
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
          ],
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter loan amount';
            }
            final amount = double.tryParse(value);
            if (amount == null || amount <= 0) {
              return 'Please enter a valid amount';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildTenureSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Loan Tenure',
          style: AppTextStyles.labelMedium.copyWith(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surfaceVariant.withOpacity(0.3),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppColors.border,
              width: 1,
            ),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      '$_selectedTenure ${_selectedTenure == 1 ? 'year' : 'years'}',
                      style: AppTextStyles.bodyLarge.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              Slider(
                value: _selectedTenure.toDouble(),
                min: 1,
                max: 30,
                divisions: 29,
                activeColor: AppColors.primaryBlue,
                inactiveColor: AppColors.border,
                onChanged: (value) {
                  setState(() {
                    _selectedTenure = value.toInt();
                  });
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '1 year',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textTertiary,
                    ),
                  ),
                  Text(
                    '30 years',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textTertiary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPurposeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Purpose of Loan',
          style: AppTextStyles.labelMedium.copyWith(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        AppTextField(
          controller: _purposeController,
          label: 'Describe the purpose',
          maxLines: 3,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter the purpose of loan';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildGuarantorSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Guarantor',
          style: AppTextStyles.labelMedium.copyWith(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () {
            setState(() {
              _hasGuarantor = !_hasGuarantor;
            });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.surfaceVariant.withOpacity(0.3),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.border,
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'I have a guarantor',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                Switch(
                  value: _hasGuarantor,
                  onChanged: (value) {
                    setState(() {
                      _hasGuarantor = value;
                    });
                  },
                  activeColor: AppColors.primaryBlue,
                  activeTrackColor: AppColors.background,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDocumentsSection() {
    final requiredDocs = RequiredDocument.getRequiredDocuments(
      loanType: _selectedLoanType,
      hasGuarantor: _hasGuarantor,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Required Documents',
          style: AppTextStyles.labelMedium.copyWith(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Upload the following documents',
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.textTertiary,
          ),
        ),
        const SizedBox(height: 12),
        ...requiredDocs.map((doc) => _buildDocumentItem(doc)),
      ],
    );
  }

  Widget _buildDocumentItem(RequiredDocument doc) {
    final isUploaded = _selectedFiles.containsKey(doc.name);
    final isUploading = _uploadingDocuments.containsKey(doc.name);
    final showError = _documentsValidationAttempted && !isUploaded;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant.withOpacity(0.5),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: showError
              ? AppColors.error
              : (isUploaded ? AppColors.success : AppColors.border),
          width: showError ? 2 : 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            isUploaded ? Icons.check_circle : Icons.upload_file_outlined,
            color: isUploaded ? AppColors.success : AppColors.textTertiary,
            size: 24,
          ),
          AppSpacing.horizontalSpaceMD,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  doc.name,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (doc.condition != null)
                  Text(
                    doc.condition!,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textTertiary,
                    ),
                  ),
              ],
            ),
          ),
          AppSpacing.horizontalSpaceSM,
          if (isUploading)
            const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          else
            TextButton(
              onPressed: () => _handleDocumentUpload(doc.name),
              child: Text(
                isUploaded ? 'Change' : 'Upload',
                style: AppTextStyles.labelMedium.copyWith(
                  color: AppColors.primaryBlue,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _handleDocumentUpload(String docName) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
        allowMultiple: false,
      );

      if (result != null && result.files.isNotEmpty) {
        final file = result.files.first;
        final filePath = file.path;

        if (filePath == null) {
          throw Exception('File path is null');
        }

        // Store file path locally (don't upload yet)
        setState(() {
          _selectedFiles[docName] = filePath;
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${file.name} selected'),
              backgroundColor: AppColors.success,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to select file: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  Future<Map<String, String>> _uploadAllDocuments(String applicationId) async {
    final uploadedDocs = <String, String>{};
    final storageService = ref.read(storageServiceProvider);

    for (final entry in _selectedFiles.entries) {
      final docName = entry.key;
      final filePath = entry.value;

      setState(() {
        _uploadingDocuments[docName] = docName;
      });

      try {
        final downloadUrl = await storageService.uploadLoanDocument(
          icNumber: widget.icNumber,
          applicationId: applicationId,
          documentFile: File(filePath),
          documentType: docName.toLowerCase().replaceAll(' ', '_'),
        );

        if (downloadUrl != null) {
          uploadedDocs[docName] = downloadUrl;
        } else {
          throw Exception('Upload failed - no download URL');
        }
      } catch (e) {
        setState(() {
          _uploadingDocuments.clear();
        });
        rethrow;
      } finally {
        setState(() {
          _uploadingDocuments.remove(docName);
        });
      }
    }

    return uploadedDocs;
  }

  Future<void> _handleSubmit() async {
    setState(() {
      _documentsValidationAttempted = true;
    });

    if (!_formKey.currentState!.validate()) {
      return;
    }

    final requiredDocs = RequiredDocument.getRequiredDocuments(
      loanType: _selectedLoanType,
      hasGuarantor: _hasGuarantor,
    );

    final missingDocs = requiredDocs
        .where((doc) => !_selectedFiles.containsKey(doc.name))
        .toList();

    if (missingDocs.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please upload all required documents (${missingDocs.length} missing)',
          ),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    // Show loading dialog
    if (!mounted) return;
    _showLoadingDialog();

    try {
      // Generate application ID
      final now = DateTime.now();
      final timestamp = '${now.day.toString().padLeft(2, '0')}'
          '${now.month.toString().padLeft(2, '0')}'
          '${now.year.toString().substring(2)}'
          '${now.hour.toString().padLeft(2, '0')}'
          '${now.minute.toString().padLeft(2, '0')}'
          '${now.second.toString().padLeft(2, '0')}';
      final applicationId = '${widget.icNumber}_$timestamp';

      // Upload all documents first
      final uploadedDocs = await _uploadAllDocuments(applicationId);

      if (uploadedDocs.length != _selectedFiles.length) {
        throw Exception('Some documents failed to upload');
      }

      final form = LoanApplicationForm(
        applicationId: applicationId,
        loanType: _selectedLoanType,
        requestedAmount: double.parse(_amountController.text),
        tenure: _selectedTenure,
        purposeOfLoan: _purposeController.text,
        guarantorAvailable: _hasGuarantor,
        uploadedDocuments: uploadedDocs.keys.toList(),
      );

      // Submit application via viewmodel
      await ref
          .read(loanSubmissionViewModelProvider.notifier)
          .submitLoanApplication(form, widget.icNumber);

      if (!mounted) return;
      Navigator.of(context).pop(); // Close loading dialog

      final submissionState = ref.read(loanSubmissionViewModelProvider);

      submissionState.when(
        data: (application) {
          if (application != null) {
            // Invalidate loan provider to refresh the list
            ref.invalidate(loanViewModelProvider);

            // Navigate back to loan view first (pop the loan application flow)
            Navigator.of(context).popUntil(
              (route) => route.settings.name == '/main' || route.isFirst,
            );

            // Show success message after navigation completes
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Application submitted successfully!\nID: ${application.applicationId}',
                    ),
                    backgroundColor: AppColors.success,
                    duration: const Duration(seconds: 4),
                  ),
                );
              }
            });
          }
        },
        loading: () {},
        error: (error, stack) {
          String errorMessage = 'Failed to submit application';

          // Parse error message for duplicate detection
          if (error.toString().contains('active') &&
              error.toString().contains('loan application')) {
            errorMessage = error.toString().replaceAll('Exception: ', '');
          }

          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(errorMessage),
                backgroundColor: AppColors.error,
                duration: const Duration(seconds: 5),
                action: SnackBarAction(
                  label: 'Retry',
                  textColor: Colors.white,
                  onPressed: _handleSubmit,
                ),
              ),
            );
          }
        },
      );
    } catch (e) {
      if (!mounted) return;
      Navigator.of(context).pop(); // Close loading dialog

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  void _showLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => PopScope(
        canPop: false,
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  width: 60,
                  height: 60,
                  child: CircularProgressIndicator(
                    strokeWidth: 4,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppColors.primaryBlue,
                    ),
                  ),
                ),
                AppSpacing.verticalSpaceLG,
                Text(
                  'Submitting Application',
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                AppSpacing.verticalSpaceSM,
                Text(
                  'Processing and running approval model...',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getLoanTypeLabel(LoanType type) {
    switch (type) {
      case LoanType.vehicle:
        return 'Vehicle Loan';
      case LoanType.personal:
        return 'Personal Loan';
      case LoanType.housing:
        return 'Housing Loan';
      case LoanType.islamicHousing:
        return 'Islamic Housing Loan';
      case LoanType.islamicPersonal:
        return 'Islamic Personal Loan';
    }
  }
}
