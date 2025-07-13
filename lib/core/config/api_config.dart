// lib/core/config/api_config.dart
import '../../features/auth/data/datasources/local/auth_local_datasource.dart';

class ApiConfig {
  static const String baseUrl = 'http://api-test.aiwel.org/api/v1';
  static const String requestOtpEndpoint = '$baseUrl/login_with_otp';
  static const String verifyOtpEndpoint = '$baseUrl/verify_otp';
  static const String profileEndpoint = '$baseUrl/profile';
  static const String refreshTokenEndpoint = '$baseUrl/refresh_token';
  static const String patientCreationEndPoint = '$baseUrl/patient';

  static Map<String, String> get defaultHeaders => {
        'Content-Type': 'application/json',
      };

  static Future<Map<String, String>> getAuthenticatedHeaders() async {
    final authLocalDataSource = AuthLocalDataSourceImpl();
    final accessToken = await authLocalDataSource.getAccessToken();
    if (accessToken == null) return defaultHeaders;
    return {
      ...defaultHeaders,
      'Authorization': 'Bearer $accessToken',
    };
  }
}
