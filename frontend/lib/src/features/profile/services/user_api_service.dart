import '../../../core/api/api_service.dart';

class UserApiService {
  final ApiService _apiService;

  UserApiService(this._apiService);

  Future<Map<String, dynamic>> getUser(String icNumber) async {
    return await _apiService.get('/user/$icNumber');
  }

  Future<Map<String, dynamic>> createUser(Map<String, dynamic> userData) async {
    return await _apiService.post('/user/', body: userData);
  }

  Future<Map<String, dynamic>> updateUser(
    String icNumber,
    Map<String, dynamic> userData,
  ) async {
    return await _apiService.put('/user/$icNumber', body: userData);
  }

  Future<Map<String, dynamic>> updateProfileImage(
    String icNumber,
    String imageUrl,
  ) async {
    return await _apiService.put(
      '/user/$icNumber/profile-image',
      body: {'imageUrl': imageUrl},
    );
  }

  Future<Map<String, dynamic>> addConnectedBank(
    String icNumber,
    String bankId,
  ) async {
    return await _apiService.post(
      '/user/$icNumber/connected-banks',
      body: {'bankId': bankId},
    );
  }
}
