import 'dart:convert';
import 'package:http/http.dart' as http;

class VerifyOtpResponseModle {
  final String status;
  final String message;
  final String token;

  VerifyOtpResponseModle({
    required this.status,
    required this.message,
    required this.token,
  });

  // Factory method to create an instance from the HTTP response
  factory VerifyOtpResponseModle.fromResponse(http.Response response) {
    // Parse the JSON body
    final jsonBody = jsonDecode(response.body) as Map<String, dynamic>;

    return VerifyOtpResponseModle(
      status: jsonBody['status'] as String? ?? 'unknown',
      message: jsonBody['message'] as String? ?? 'No message provided',
      token: response.headers['authorization']?.replaceAll('Bearer ', '') ?? '',
    );
  }
}