import '../../../core/api/api_service.dart';

class PersonalInfoApiService {
  final ApiService _api;

  PersonalInfoApiService(this._api);

  Future<Map<String, dynamic>> getPersonalInfo(String icNumber) async {
    return await _api.get('/profile/personal/$icNumber');
  }

  Future<Map<String, dynamic>> createPersonalInfo(
      Map<String, dynamic> personalInfo) async {
    return await _api.post('/profile/personal', body: personalInfo);
  }

  Future<Map<String, dynamic>> updatePersonalInfo(
      String icNumber, Map<String, dynamic> personalInfo) async {
    return await _api.put('/profile/personal/$icNumber', body: personalInfo);
  }
}
