import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'model/api_response.dart';
import 'api_service.dart';

class HttpApiService implements IApiService {
  final http.Client _client;
  Map<String, String> _headers = {};

  HttpApiService({http.Client? client}) : _client = client ?? http.Client();

  @override
  Future<ApiResponse<T>> get<T>(String endpoint, {Map<String, dynamic>? queryParams, Map<String, String>? headers}) async {
    try {
      final uri = Uri.parse(endpoint).replace(queryParameters: queryParams?.map(
            (key, value) => MapEntry(key, value.toString()),
      ));
      final response = await _client.get(
        uri,
        headers: {..._headers, if (headers != null) ...headers},
      ).timeout(
        const Duration(seconds: 30),
        onTimeout: () => throw TimeoutException('Request timed out'),
      );

      return _handleResponse<T>(response);
    } catch (e) {
      return _handleError<T>(e);
    }
  }

  @override
  Future<ApiResponse<T>> post<T>(String endpoint, {dynamic body, Map<String, String>? headers}) async {
    try {
      final response = await _client
          .post(
        Uri.parse(endpoint),
        headers: {
          ..._headers,
          'Content-Type': 'application/json',
          if (headers != null) ...headers,
        },
        body: body != null ? jsonEncode(body) : null,
      )
          .timeout(
        const Duration(seconds: 30),
        onTimeout: () => throw TimeoutException('Request timed out'),
      );

      return _handleResponse<T>(response);
    } catch (e) {
      return _handleError<T>(e);
    }
  }

  @override
  Future<ApiResponse<T>> put<T>(String endpoint, {dynamic body, Map<String, String>? headers}) async {
    try {
      final response = await _client
          .put(
        Uri.parse(endpoint),
        headers: {
          ..._headers,
          'Content-Type': 'application/json',
          if (headers != null) ...headers,
        },
        body: body != null ? jsonEncode(body) : null,
      )
          .timeout(
        const Duration(seconds: 30),
        onTimeout: () => throw TimeoutException('Request timed out'),
      );

      return _handleResponse<T>(response);
    } catch (e) {
      return _handleError<T>(e);
    }
  }

  @override
  Future<ApiResponse<T>> delete<T>(String endpoint, {Map<String, String>? headers}) async {
    try {
      final response = await _client.delete(
        Uri.parse(endpoint),
        headers: {..._headers, if (headers != null) ...headers},
      ).timeout(
        const Duration(seconds: 30),
        onTimeout: () => throw TimeoutException('Request timed out'),
      );

      return _handleResponse<T>(response);
    } catch (e) {
      return _handleError<T>(e);
    }
  }

  @override
  void setHeaders(Map<String, String> headers) {
    _headers = {...headers};
  }

  @override
  void clearHeaders() {
    _headers = {};
  }

  ApiResponse<T> _handleResponse<T>(http.Response response) {
    final statusCode = response.statusCode;
    if (statusCode >= 200 && statusCode < 300) {
      try {
        final data = response.body.isNotEmpty ? jsonDecode(response.body) : null;
        return ApiResponseImpl.success(data);
      } catch (e) {
        return ApiResponseImpl.error('Failed to parse response: $e');
      }
    } else {
      String errorMessage;
      switch (statusCode) {
        case 400:
          errorMessage = 'Bad request';
          break;
        case 401:
          errorMessage = 'Unauthorized';
          break;
        case 403:
          errorMessage = 'Forbidden';
          break;
        case 404:
          errorMessage = 'Resource not found';
          break;
        case 500:
          errorMessage = 'Server error';
          break;
        default:
          errorMessage = 'HTTP error: $statusCode';
      }
      try {
        final errorBody = jsonDecode(response.body);
        errorMessage += ' - ${errorBody['message'] ?? errorBody.toString()}';
      } catch (_) {
        // Ignore if response body is not JSON
      }
      return ApiResponseImpl.error(errorMessage);
    }
  }

  ApiResponse<T> _handleError<T>(dynamic error) {
    if (error is http.ClientException) {
      return ApiResponseImpl.error('Network error: ${error.message}');
    } else if (error is TimeoutException) {
      return ApiResponseImpl.error('Request timed out');
    } else {
      return ApiResponseImpl.error('Unexpected error: $error');
    }
  }

  void dispose() {
    _client.close();
  }
}