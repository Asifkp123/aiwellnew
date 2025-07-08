import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import '../../../../../core/config/api_config.dart';
import '../../../../../core/network/error/failure.dart';
import '../../models/api/otp_request_success.dart';
import '../../models/api/submit_profile_response.dart';
import '../../models/api/token_resonse.dart';
import '../../models/api/verify_otp_response.dart';
import '../local/auth_local_datasource.dart';

abstract class AuthRemoteDataSource {
  Future<Either<Failure, OtpRequestSuccess>> requestOtp({String? email, String? phoneNumber});
  Future<Either<Failure, TokenResponse>> verifyOtp(String identifier, String otp);
  Future<Either<Failure, SubmitProfileResponse>> submitProfile({
    required String firstName,
    required String lastName,
    required String gender,
    required String dateOfBirth,
    required String dominantEmotion,
    required String sleepQuality,
    required String physicalActivity,
  });
  Future<Either<Failure, http.Response>> refreshToken(String refreshToken);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final AuthLocalDataSourceBase authLocalDataSource;

  AuthRemoteDataSourceImpl({required this.authLocalDataSource});

  @override
  Future<Either<Failure, OtpRequestSuccess>> requestOtp({String? email, String? phoneNumber}) async {
    try {
      final payload = email != null ? {'email': email} : {'phone_number': phoneNumber};

      final response = await http.post(
        Uri.parse(ApiConfig.requestOtpEndpoint),
        body: jsonEncode(payload),
        headers: ApiConfig.defaultHeaders,
      );

      if (response.statusCode != 200) {
        final responseBody = jsonDecode(response.body) as Map<String, dynamic>;
        final errorMessage = responseBody['message'] ?? 'Failed to request OTP: ${response.reasonPhrase}';
        return Left(Failure(errorMessage));
      }
      return Right(OtpRequestSuccess(response.body));
    } catch (e) {
      return Left(Failure('Network error: $e'));
    }
  }

  @override
  Future<Either<Failure, TokenResponse>> verifyOtp(String identifier, String otp) async {
    try {
      final payload = {
        'identifier': identifier,
        'otp': otp,
      };

      final response = await http.post(
        Uri.parse(ApiConfig.verifyOtpEndpoint),
        body: jsonEncode(payload),
        headers: ApiConfig.defaultHeaders,
      );

      if (response.statusCode == 200) {
        final accessToken = response.headers['authorization']?.replaceAll('Bearer ', '') ?? '';
        final accessTokenExpiry = int.tryParse(response.headers['x-token-expiry'] ?? '') ?? 0;
        final refreshToken = response.headers['x-refresh-token'] ?? '';
        final refreshTokenExpiry = int.tryParse(response.headers['x-refresh-expiry'] ?? '') ?? 0;

        if (accessToken.isEmpty || refreshToken.isEmpty) {
          return Left(Failure('Missing token data in response'));
        }

        return Right(TokenResponse(
          accessToken: accessToken,
          accessTokenExpiry: accessTokenExpiry,
          refreshToken: refreshToken,
          refreshTokenExpiry: refreshTokenExpiry,
        ));
      } else {
        final responseBody = jsonDecode(response.body) as Map<String, dynamic>;
        final errorMessage = responseBody['message'] ?? 'OTP verification failed: ${response.reasonPhrase}';
        return Left(Failure(errorMessage));
      }
    } catch (e) {
      return Left(Failure('Network error: $e'));
    }
  }

  @override
  Future<Either<Failure, SubmitProfileResponse>> submitProfile({
    required String firstName,
    required String lastName,
    required String gender,
    required String dateOfBirth,
    required String dominantEmotion,
    required String sleepQuality,
    required String physicalActivity,
  }) async {
    try {
      final headers = await ApiConfig.getAuthenticatedHeaders();

      final response = await http.post(
        Uri.parse(ApiConfig.profileEndpoint),
        headers: headers,
        body: jsonEncode({
          'first_name': firstName,
          'last_name': lastName,
          'gender': gender,
          'date_of_birth': dateOfBirth,
          'dominant_emotion': dominantEmotion,
          'sleep_quality': sleepQuality,
          'physical_activity': physicalActivity,
        }),
      );

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body) as Map<String, dynamic>;
        return Right(SubmitProfileResponse.fromJson(responseBody));
      } else {
        final responseBody = jsonDecode(response.body) as Map<String, dynamic>;
        final errorMessage = responseBody['message'] ?? 'Failed to submit profile: ${response.reasonPhrase}';
        return Left(Failure(errorMessage));
      }
    } catch (e) {
      return Left(Failure('Network error: $e'));
    }
  }

  @override
  Future<Either<Failure, http.Response>> refreshToken(String refreshToken) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConfig.refreshTokenEndpoint),
        headers: {
          ...ApiConfig.defaultHeaders,
          'X-Refresh-Token': refreshToken,
        },
      );
      return Right(response);
    } catch (e) {
      return Left(Failure('Network error: $e'));
    }
  }
}