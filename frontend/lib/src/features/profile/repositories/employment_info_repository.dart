import '../models/employment_info_model.dart';

abstract class EmploymentInfoRepository {
  Future<EmploymentInfo?> getEmploymentInfo(String icNumber);
  Future<void> createEmploymentInfo(EmploymentInfo employmentInfo);
  Future<void> updateEmploymentInfo(EmploymentInfo employmentInfo);
}
