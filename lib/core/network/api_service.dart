import 'model/api_response.dart';

abstract class IApiService {
  /// Performs a GET request to fetch data of type [T].
  /// [endpoint] is the API endpoint to hit (e.g., '/users').
  /// [queryParams] is an optional map of query parameters.
  /// [headers] is an optional map of headers for this request.
  /// Returns an [ApiResponse] containing the result or error.
  Future<ApiResponse<T>> get<T>(String endpoint, {Map<String, dynamic>? queryParams, Map<String, String>? headers});

  /// Performs a POST request to send data and receive a response of type [T].
  /// [endpoint] is the API endpoint to hit.
  /// [body] is the data to send in the request.
  /// [headers] is an optional map of headers for this request.
  /// Returns an [ApiResponse] containing the result or error.
  Future<ApiResponse<T>> post<T>(String endpoint, {dynamic body, Map<String, String>? headers});

  /// Performs a PUT request to update data and receive a response of type [T].
  /// [endpoint] is the API endpoint to hit.
  /// [body] is the data to send in the request.
  /// [headers] is an optional map of headers for this request.
  /// Returns an [ApiResponse] containing the result or error.
  Future<ApiResponse<T>> put<T>(String endpoint, {dynamic body, Map<String, String>? headers});

  /// Performs a DELETE request to remove a resource.
  /// [endpoint] is the API endpoint to hit.
  /// [headers] is an optional map of headers for this request.
  /// Returns an [ApiResponse] containing the result or error.
  Future<ApiResponse<T>> delete<T>(String endpoint, {Map<String, String>? headers});

  /// Sets custom headers for API requests (e.g., Authorization token).
  /// [headers] is a map of header key-value pairs.
  void setHeaders(Map<String, String> headers);

  /// Clears any stored headers (e.g., for logout or reset).
  void clearHeaders();
}