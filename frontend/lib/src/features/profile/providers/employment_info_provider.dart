import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/employment_info_model.dart';
import '../repositories/employment_info_repository.dart';
import '../repositories/backend_employment_info_repository.dart';
import '../services/employment_info_api_service.dart';
import '../../../core/api/api_providers.dart';

part 'employment_info_provider.g.dart';

@riverpod
EmploymentInfoRepository employmentInfoRepository(
    EmploymentInfoRepositoryRef ref) {
  final apiService = ref.watch(apiServiceProvider);
  final employmentInfoApiService = EmploymentInfoApiService(apiService);
  return BackendEmploymentInfoRepository(employmentInfoApiService);
}

@riverpod
Future<EmploymentInfo?> employmentInfo(
    EmploymentInfoRef ref, String icNumber) async {
  final repository = ref.watch(employmentInfoRepositoryProvider);
  return repository.getEmploymentInfo(icNumber);
}
