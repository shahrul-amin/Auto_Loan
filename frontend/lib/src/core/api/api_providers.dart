import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'api_service.dart';

part 'api_providers.g.dart';

@Riverpod(keepAlive: true)
ApiService apiService(ApiServiceRef ref) {
  return ApiService();
}
