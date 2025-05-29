import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthRemoteDataSource {
  // Initiates login by sending OTP to the provided email or phone number
  Future<void> requestOtp({String? email, String? phoneNumber}) async {
    if (email == null && phoneNumber == null) {
      throw Exception('Either email or phone number must be provided');
    }
    if (email != null && phoneNumber != null) {
      throw Exception('Provide only one: email or phone number');
    }

    final payload = email != null
        ? {'email': email}
        : {'phone_number': phoneNumber};

    final response = await http.post(
      Uri.parse('https://api.aiwel.org/api/v1/login_with_otp'),
      body: jsonEncode(payload),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to request OTP: ${response.reasonPhrase}');
    }
  }

  // Verifies the OTP for the given identifier (email or phone number)
  Future<String> verifyOtp(String identifier, String otp) async {
    final payload = {
      'identifier': identifier,
      'otp': otp,
    };

    final response = await http.post(
      Uri.parse('https://api.aiwel.org/api/v1/verify_otp'),
      body: jsonEncode(payload),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['token']; // Assuming the API returns a token
    } else {
      throw Exception('Failed to verify OTP: ${response.reasonPhrase}');
    }
  }
}