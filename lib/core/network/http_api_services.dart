import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'model/api_response.dart';
import 'api_service.dart';
import 'package:aiwel/features/auth/data/datasources/local/auth_local_datasource.dart';
import 'package:aiwel/features/auth/domain/usecases/refresh_token_use_case.dart';
import '../services/token_manager.dart';

class HttpApiService implements IApiService {
  final http.Client _client;
  Map<String, String> _headers = {};
  final TokenManager tokenManager;
  late RefreshTokenUseCaseBase refreshTokenUseCase;

  HttpApiService({
    http.Client? client,
    TokenManager? tokenManager,
    RefreshTokenUseCaseBase? refreshTokenUseCase,
  })  : tokenManager = tokenManager ?? TokenManager.instance,
        _client = client ?? http.Client() {
    if (refreshTokenUseCase != null) {
      this.refreshTokenUseCase = refreshTokenUseCase;
    }
  }

  Future<String?> _getValidAccessToken() async {
    final tokenResult = await tokenManager.getValidAccessToken();
    return tokenResult.fold(
      (failure) {
        // If token is expired but refresh token is valid, try to refresh
        if (failure.message.contains('refresh needed')) {
          return null; // Will trigger refresh in _withTokenRetry
        }
        return null;
      },
      (token) => token,
    );
  }

  bool _requiresAuthentication(String endpoint) {
    // List of endpoints that don't require authentication
    final unauthenticatedEndpoints = [
      '/api/v1/login_with_otp',
      '/api/v1/request_otp',
      '/api/v1/verify_otp',
    ];

    return !unauthenticatedEndpoints.any((path) => endpoint.contains(path));
  }

  Future<ApiResponse<T>> _withTokenRetry<T>(
      String endpoint,
      Future<ApiResponse<T>> Function(Map<String, String> headers)
          requestFn) async {
    // Skip token logic for unauthenticated endpoints
    if (!_requiresAuthentication(endpoint)) {
      return await requestFn(_headers);
    }

    String? token = await _getValidAccessToken();
    if (token == null) {
      return ApiResponseImpl.error('No valid access token');
    }
    final headers = {..._headers, 'Authorization': 'Bearer $token'};
    ApiResponse<T> response = await requestFn(headers);
    if (response is ApiResponseImpl &&
        response.errorMessage?.contains('Unauthorized') == true) {
      // Try refresh and retry once
      final refreshResult = await refreshTokenUseCase.execute();
      if (refreshResult.isLeft()) {
        return response;
      }
      final newToken = await tokenManager.getAccessToken();
      if (newToken == null) return response;
      final retryHeaders = {..._headers, 'Authorization': 'Bearer $newToken'};
      response = await requestFn(retryHeaders);
    }
    return response;
  }

  @override
  Future<ApiResponse<T>> get<T>(String endpoint,
      {Map<String, dynamic>? queryParams, Map<String, String>? headers}) async {
    return _withTokenRetry(endpoint, (tokenHeaders) async {
      try {
        print("About to make HTTP GET request");
        final uri = Uri.parse(endpoint).replace(
            queryParameters: queryParams?.map(
          (key, value) => MapEntry(key, value.toString()),
        ));
        final response = await _client.get(
          uri,
          headers: {...tokenHeaders, if (headers != null) ...headers},
        ).timeout(
          const Duration(seconds: 30),
          onTimeout: () => throw TimeoutException('Request timed out'),
        );
        print("HTTP GET request completed with status: ${response.statusCode}");
        return _handleResponse<T>(response);
      } catch (e) {
        print("Exception in HttpApiService.get: $e");
        return _handleError<T>(e);
      }
    });
  }

  @override
  Future<ApiResponse<T>> post<T>(String endpoint,
      {dynamic body, Map<String, String>? headers}) async {
    print("HttpApiService.post called with endpoint: $endpoint");
    return _withTokenRetry(endpoint, (tokenHeaders) async {
      try {
        print("About to make HTTP POST request");
        final response = await _client
            .post(
              Uri.parse(endpoint),
              headers: {
                ...tokenHeaders,
                'Content-Type': 'application/json',
                if (headers != null) ...headers,
              },
              body: body != null ? jsonEncode(body) : null,
            )
            .timeout(
              const Duration(seconds: 30),
              onTimeout: () => throw TimeoutException('Request timed out'),
            );
        print(
            "HTTP POST request completed with status: ${response.statusCode}");
        return _handleResponse<T>(response);
      } catch (e) {
        print("Exception in HttpApiService.post: $e");
        return _handleError<T>(e);
      }
    });
  }

  @override
  Future<ApiResponse<T>> put<T>(String endpoint,
      {dynamic body, Map<String, String>? headers}) async {
    return _withTokenRetry(endpoint, (tokenHeaders) async {
      try {
        print("About to make HTTP PUT request");
        final response = await _client
            .put(
              Uri.parse(endpoint),
              headers: {
                ...tokenHeaders,
                'Content-Type': 'application/json',
                if (headers != null) ...headers,
              },
              body: body != null ? jsonEncode(body) : null,
            )
            .timeout(
              const Duration(seconds: 30),
              onTimeout: () => throw TimeoutException('Request timed out'),
            );
        print("HTTP PUT request completed with status: ${response.statusCode}");
        return _handleResponse<T>(response);
      } catch (e) {
        print("Exception in HttpApiService.put: $e");
        return _handleError<T>(e);
      }
    });
  }

  @override
  Future<ApiResponse<T>> delete<T>(String endpoint,
      {Map<String, String>? headers}) async {
    return _withTokenRetry(endpoint, (tokenHeaders) async {
      try {
        print("About to make HTTP DELETE request");
        final response = await _client.delete(
          Uri.parse(endpoint),
          headers: {...tokenHeaders, if (headers != null) ...headers},
        ).timeout(
          const Duration(seconds: 30),
          onTimeout: () => throw TimeoutException('Request timed out'),
        );
        print(
            "HTTP DELETE request completed with status: ${response.statusCode}");
        return _handleResponse<T>(response);
      } catch (e) {
        print("Exception in HttpApiService.delete: $e");
        return _handleError<T>(e);
      }
    });
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
        final data =
            response.body.isNotEmpty ? jsonDecode(response.body) : null;
        return ApiResponseImpl.success(data, headers: response.headers);
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
