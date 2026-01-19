import '../../../core/api/api_service.dart';

class EmploymentInfoApiService {
  final ApiService _api;

  EmploymentInfoApiService(this._api);

  Future<Map<String, dynamic>> getEmploymentInfo(String icNumber) async {
    return await _api.get('/profile/employment/$icNumber');
  }

  Future<Map<String, dynamic>> createEmploymentInfo(
      Map<String, dynamic> employmentInfo) async {
    return await _api.post('/profile/employment', body: employmentInfo);
  }

  Future<Map<String, dynamic>> updateEmploymentInfo(
      String icNumber, Map<String, dynamic> employmentInfo) async {
    return await _api.put('/profile/employment/$icNumber',
        body: employmentInfo);
  }
}
