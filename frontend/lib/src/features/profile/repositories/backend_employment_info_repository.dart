import 'employment_info_repository.dart';
import '../models/employment_info_model.dart';
import '../services/employment_info_api_service.dart';

class BackendEmploymentInfoRepository implements EmploymentInfoRepository {
  final EmploymentInfoApiService _employmentInfoApi;

  BackendEmploymentInfoRepository(this._employmentInfoApi);

  @override
  Future<EmploymentInfo?> getEmploymentInfo(String icNumber) async {
    try {
      final res = await _employmentInfoApi.getEmploymentInfo(icNumber);
      if (res['success'] == true && res['employmentInfo'] != null) {
        return EmploymentInfo.fromJson(
            Map<String, dynamic>.from(res['employmentInfo']));
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get employment info: $e');
    }
  }

  @override
  Future<void> createEmploymentInfo(EmploymentInfo employmentInfo) async {
    try {
      await _employmentInfoApi.createEmploymentInfo(employmentInfo.toJson());
    } catch (e) {
      throw Exception('Failed to create employment info: $e');
    }
  }

  @override
  Future<void> updateEmploymentInfo(EmploymentInfo employmentInfo) async {
    try {
      await _employmentInfoApi.updateEmploymentInfo(
          employmentInfo.icNumber, employmentInfo.toJson());
    } catch (e) {
      throw Exception('Failed to update employment info: $e');
    }
  }
}
