import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_config.dart';
import 'api_exceptions.dart';

class ApiService {
  final http.Client _client;

  ApiService({http.Client? client}) : _client = client ?? http.Client();

  Future<Map<String, dynamic>> get(
    String endpoint, {
    Map<String, String>? headers,
    Map<String, String>? queryParameters,
  }) async {
    try {
      final uri = _buildUri(endpoint, queryParameters);
      final response = await _client.get(
        uri,
        headers: {...ApiConfig.headers, ...?headers},
      ).timeout(ApiConfig.timeout);

      return _handleResponse(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> post(
    String endpoint, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
    Map<String, String>? queryParameters,
  }) async {
    try {
      final uri = _buildUri(endpoint, queryParameters);
      final response = await _client
          .post(
            uri,
            headers: {...ApiConfig.headers, ...?headers},
            body: body != null ? jsonEncode(body) : null,
          )
          .timeout(ApiConfig.timeout);

      return _handleResponse(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> put(
    String endpoint, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
    Map<String, String>? queryParameters,
  }) async {
    try {
      final uri = _buildUri(endpoint, queryParameters);
      final response = await _client
          .put(
            uri,
            headers: {...ApiConfig.headers, ...?headers},
            body: body != null ? jsonEncode(body) : null,
          )
          .timeout(ApiConfig.timeout);

      return _handleResponse(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> delete(
    String endpoint, {
    Map<String, String>? headers,
    Map<String, String>? queryParameters,
  }) async {
    try {
      final uri = _buildUri(endpoint, queryParameters);
      final response = await _client.delete(
        uri,
        headers: {...ApiConfig.headers, ...?headers},
      ).timeout(ApiConfig.timeout);

      return _handleResponse(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Uri _buildUri(String endpoint, Map<String, String>? queryParameters) {
    final url = '${ApiConfig.baseUrl}$endpoint';
    final uri = Uri.parse(url);

    if (queryParameters != null && queryParameters.isNotEmpty) {
      return uri.replace(queryParameters: queryParameters);
    }

    return uri;
  }

  Map<String, dynamic> _handleResponse(http.Response response) {
    final statusCode = response.statusCode;

    if (response.body.isEmpty) {
      if (statusCode >= 200 && statusCode < 300) {
        return {'success': true};
      }
      throw ApiException(
        message: 'Empty response from server',
        statusCode: statusCode,
      );
    }

    final Map<String, dynamic> data = jsonDecode(response.body);

    if (statusCode >= 200 && statusCode < 300) {
      return data;
    }

    throw ApiException(
      message: data['message'] ?? data['error'] ?? 'Unknown error occurred',
      statusCode: statusCode,
      data: data,
    );
  }

  Exception _handleError(dynamic error) {
    if (error is ApiException) {
      return error;
    }

    if (error is http.ClientException) {
      return NetworkException('Network error: ${error.message}');
    }

    return NetworkException('Unexpected error: ${error.toString()}');
  }

  void dispose() {
    _client.close();
  }
}
