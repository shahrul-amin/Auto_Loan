import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/personal_info_model.dart';
import '../repositories/personal_info_repository.dart';
import '../repositories/backend_personal_info_repository.dart';
import '../services/personal_info_api_service.dart';
import '../../../core/api/api_providers.dart';

part 'personal_info_provider.g.dart';

@Riverpod(keepAlive: true)
PersonalInfoRepository personalInfoRepository(PersonalInfoRepositoryRef ref) {
  final api = ref.read(apiServiceProvider);
  final personalInfoApi = PersonalInfoApiService(api);
  return BackendPersonalInfoRepository(personalInfoApi);
}

@riverpod
Future<PersonalInfo?> personalInfo(PersonalInfoRef ref, String icNumber) async {
  try {
    final repository = ref.read(personalInfoRepositoryProvider);
    return await repository.getPersonalInfo(icNumber);
  } catch (e) {
    throw Exception('Failed to fetch personal info: $e');
  }
}
