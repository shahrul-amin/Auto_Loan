import 'personal_info_repository.dart';
import '../models/personal_info_model.dart';
import '../services/personal_info_api_service.dart';

class BackendPersonalInfoRepository implements PersonalInfoRepository {
  final PersonalInfoApiService _personalInfoApi;

  BackendPersonalInfoRepository(this._personalInfoApi);

  @override
  Future<PersonalInfo?> getPersonalInfo(String icNumber) async {
    try {
      final res = await _personalInfoApi.getPersonalInfo(icNumber);
      if (res['success'] == true && res['personalInfo'] != null) {
        return PersonalInfo.fromJson(
            Map<String, dynamic>.from(res['personalInfo']));
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get personal info: $e');
    }
  }

  @override
  Future<void> createPersonalInfo(PersonalInfo personalInfo) async {
    try {
      await _personalInfoApi.createPersonalInfo(personalInfo.toJson());
    } catch (e) {
      throw Exception('Failed to create personal info: $e');
    }
  }

  @override
  Future<void> updatePersonalInfo(PersonalInfo personalInfo) async {
    try {
      await _personalInfoApi.updatePersonalInfo(
          personalInfo.icNumber, personalInfo.toJson());
    } catch (e) {
      throw Exception('Failed to update personal info: $e');
    }
  }
}
