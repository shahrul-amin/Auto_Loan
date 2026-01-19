// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'loan_application_form.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LoanApplicationFormImpl _$$LoanApplicationFormImplFromJson(
        Map<String, dynamic> json) =>
    _$LoanApplicationFormImpl(
      applicationId: json['applicationId'] as String,
      loanType: $enumDecode(_$LoanTypeEnumMap, json['loanType']),
      requestedAmount: (json['requestedAmount'] as num).toDouble(),
      tenure: (json['tenure'] as num).toInt(),
      purposeOfLoan: json['purposeOfLoan'] as String,
      guarantorAvailable: json['guarantorAvailable'] as bool,
      uploadedDocuments: (json['uploadedDocuments'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$LoanApplicationFormImplToJson(
        _$LoanApplicationFormImpl instance) =>
    <String, dynamic>{
      'applicationId': instance.applicationId,
      'loanType': _$LoanTypeEnumMap[instance.loanType]!,
      'requestedAmount': instance.requestedAmount,
      'tenure': instance.tenure,
      'purposeOfLoan': instance.purposeOfLoan,
      'guarantorAvailable': instance.guarantorAvailable,
      'uploadedDocuments': instance.uploadedDocuments,
    };

const _$LoanTypeEnumMap = {
  LoanType.housing: 'Housing',
  LoanType.islamicHousing: 'Islamic-Housing',
  LoanType.vehicle: 'Vehicle',
  LoanType.personal: 'Personal',
  LoanType.islamicPersonal: 'Islamic-Personal',
};
