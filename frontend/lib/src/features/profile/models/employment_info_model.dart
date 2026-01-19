import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'employment_info_model.freezed.dart';
part 'employment_info_model.g.dart';

@freezed
class EmploymentInfo with _$EmploymentInfo {
  const factory EmploymentInfo({
    required String icNumber,
    required String employerName,
    required String position,
    required String employmentType,
    required double monthlyIncome,
    required DateTime employmentStartDate,
    required String industry,
    String? employerPhone,
    String? employerAddress,
    @Default(0.0) double epfMonthlyContribution,
    @Default(0.0) double epfBalance,
  }) = _EmploymentInfo;

  factory EmploymentInfo.fromJson(Map<String, dynamic> json) =>
      _$EmploymentInfoFromJson(json);

  factory EmploymentInfo.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return EmploymentInfo(
      icNumber: data['icNumber'] as String,
      employerName: data['employerName'] as String,
      position: data['position'] as String,
      employmentType: data['employmentType'] as String,
      monthlyIncome: (data['monthlyIncome'] as num).toDouble(),
      employmentStartDate: (data['employmentStartDate'] as Timestamp).toDate(),
      industry: data['industry'] as String,
      employerPhone: data['employerPhone'] as String?,
      employerAddress: data['employerAddress'] as String?,
      epfMonthlyContribution:
          (data['epfMonthlyContribution'] as num?)?.toDouble() ?? 0.0,
      epfBalance: (data['epfBalance'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

extension EmploymentInfoX on EmploymentInfo {
  Map<String, dynamic> toFirestore() {
    return {
      'icNumber': icNumber,
      'employerName': employerName,
      'position': position,
      'employmentType': employmentType,
      'monthlyIncome': monthlyIncome,
      'employmentStartDate': Timestamp.fromDate(employmentStartDate),
      'industry': industry,
      'employerPhone': employerPhone,
      'employerAddress': employerAddress,
      'epfMonthlyContribution': epfMonthlyContribution,
      'epfBalance': epfBalance,
    };
  }
}
