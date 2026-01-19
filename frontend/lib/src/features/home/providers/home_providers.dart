import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../repositories/home_repository.dart';
import '../repositories/backend_home_repository.dart';

part 'home_providers.g.dart';

@riverpod
HomeRepository homeRepository(HomeRepositoryRef ref) {
  return BackendHomeRepository();
}
