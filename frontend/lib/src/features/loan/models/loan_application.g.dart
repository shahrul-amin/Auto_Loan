// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'loan_application.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LoanApplicationImpl _$$LoanApplicationImplFromJson(
        Map<String, dynamic> json) =>
    _$LoanApplicationImpl(
      applicationId: json['applicationId'] as String,
      icNumber: json['icNumber'] as String,
      loanType: json['loanType'] as String,
      requestedAmount: (json['requestedAmount'] as num).toDouble(),
      tenure: (json['tenure'] as num).toInt(),
      purposeOfLoan: json['purposeOfLoan'] as String,
      guarantorAvailable: json['guarantorAvailable'] as bool,
      status: $enumDecode(_$LoanStatusEnumMap, json['status']),
      requiredDocuments: (json['requiredDocuments'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      uploadedDocuments: (json['uploadedDocuments'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      applicationDate: json['applicationDate'] as String,
      lastUpdated: json['lastUpdated'] as String,
      interestRate: (json['interestRate'] as num?)?.toDouble(),
      approvedAmount: (json['approvedAmount'] as num?)?.toDouble(),
      rejectionReason: json['rejectionReason'] as String?,
      assignedOfficer: json['assignedOfficer'] as String?,
      officerRemarks: json['officerRemarks'] as String?,
      mlConfidence: (json['mlConfidence'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$$LoanApplicationImplToJson(
        _$LoanApplicationImpl instance) =>
    <String, dynamic>{
      'applicationId': instance.applicationId,
      'icNumber': instance.icNumber,
      'loanType': instance.loanType,
      'requestedAmount': instance.requestedAmount,
      'tenure': instance.tenure,
      'purposeOfLoan': instance.purposeOfLoan,
      'guarantorAvailable': instance.guarantorAvailable,
      'status': _$LoanStatusEnumMap[instance.status]!,
      'requiredDocuments': instance.requiredDocuments,
      'uploadedDocuments': instance.uploadedDocuments,
      'applicationDate': instance.applicationDate,
      'lastUpdated': instance.lastUpdated,
      'interestRate': instance.interestRate,
      'approvedAmount': instance.approvedAmount,
      'rejectionReason': instance.rejectionReason,
      'assignedOfficer': instance.assignedOfficer,
      'officerRemarks': instance.officerRemarks,
      'mlConfidence': instance.mlConfidence,
    };

const _$LoanStatusEnumMap = {
  LoanStatus.rejected: 'rejected',
  LoanStatus.pending: 'pending',
  LoanStatus.approved: 'approved',
  LoanStatus.credited: 'credited',
};
