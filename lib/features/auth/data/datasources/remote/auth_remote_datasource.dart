import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import '../../../../../core/config/api_config.dart';
import '../../../../../core/network/error/failure.dart';
import '../../../../../core/network/model/api_response.dart';
import '../../../../../core/services/token_manager.dart';
import '../../models/api/otp_request_success.dart';
import '../../models/api/submit_profile_response.dart';
import '../../models/api/token_resonse.dart';
import '../../models/api/verify_otp_response.dart';
import '../local/auth_local_datasource.dart';
import '../../../../../core/network/api_service.dart';

abstract class AuthRemoteDataSource {
  Future<Either<Failure, ApiResponse>> requestOtp(
      {String? email, String? phoneNumber});
  Future<Either<Failure, ApiResponse>> verifyOtp(String identifier, String otp);
  Future<Either<Failure, ApiResponse>> submitProfile({
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
  final IApiService apiService;

  AuthRemoteDataSourceImpl(
      {required this.authLocalDataSource, required this.apiService});

  @override
  Future<Either<Failure, ApiResponse>> requestOtp(
      {String? email, String? phoneNumber}) async {
    print("requestOtp called");
    return await _performOtpRequest(email: email, phoneNumber: phoneNumber);
  }

  Future<Either<Failure, ApiResponse>> _performOtpRequest(
      {String? email, String? phoneNumber}) async {
    try {
      final body = <String, dynamic>{};
      if (email != null && email.isNotEmpty) {
        body['email'] = email;
      } else if (phoneNumber != null && phoneNumber.isNotEmpty) {
        body['phone_number'] = phoneNumber;
      } else {
        return Left(Failure('Either email or phone number is required'));
      }

      final response = await apiService.post(
        ApiConfig.requestOtpEndpoint,
        body: body,
        headers: ApiConfig.defaultHeaders,
      );

      return Right(response);
    } catch (e) {
      return Left(Failure('OTP request failed: $e'));
    }
  }

  @override
  Future<Either<Failure, ApiResponse>> verifyOtp(
      String identifier, String otp) async {
    return await _performOtpVerification(identifier, otp);
  }

  Future<Either<Failure, ApiResponse>> _performOtpVerification(
      String identifier, String otp) async {
    try {
      final body = {
        'identifier': identifier,
        'otp': otp,
      };

      final response = await apiService.post(
        ApiConfig.verifyOtpEndpoint,
        body: body,
        headers: ApiConfig.defaultHeaders,
      );

      return Right(response);
    } catch (e) {
      return Left(Failure('Verification failed: $e'));
    }
  }

  @override
  Future<Either<Failure, ApiResponse>> submitProfile({
    required String firstName,
    required String lastName,
    required String gender,
    required String dateOfBirth,
    required String dominantEmotion,
    required String sleepQuality,
    required String physicalActivity,
  }) async {
    return await _performProfileSubmission(
      firstName: firstName,
      lastName: lastName,
      gender: gender,
      dateOfBirth: dateOfBirth,
      dominantEmotion: dominantEmotion,
      sleepQuality: sleepQuality,
      physicalActivity: physicalActivity,
    );
  }

  Future<Either<Failure, ApiResponse>> _performProfileSubmission({
    required String firstName,
    required String lastName,
    required String gender,
    required String dateOfBirth,
    required String dominantEmotion,
    required String sleepQuality,
    required String physicalActivity,
  }) async {
    try {
      final body = {
        'first_name': firstName,
        'last_name': lastName,
        'gender': gender,
        'date_of_birth': dateOfBirth,
        'dominant_emotion': dominantEmotion,
        'sleep_quality': sleepQuality,
        'physical_activity': physicalActivity,
      };

      // Use apiService which handles token validation and refresh automatically
      final response = await apiService.post(
        ApiConfig.profileEndpoint,
        body: body,
        headers: ApiConfig
            .defaultHeaders, // Token will be added automatically by apiService
      );

      return Right(response);
    } catch (e) {
      return Left(Failure('Profile submission failed: $e'));
    }
  }

  @override
  Future<Either<Failure, http.Response>> refreshToken(
      String refreshToken) async {
    return await _performTokenRefresh(refreshToken);
  }

  Future<Either<Failure, http.Response>> _performTokenRefresh(
      String refreshToken) async {
    try {
      // Get access token (if needed for Authorization header)
      final tokenManager = await TokenManager.getInstance();
      final authLocalDataSource = AuthLocalDataSourceImpl(tokenManager);
      final accessToken = await authLocalDataSource.getAccessToken();

      // Debug prints to trace the issue
      print('=== DEBUG REFRESH TOKEN ===');
      print('refreshToken: $refreshToken');
      print('accessToken: $accessToken');
      print('accessToken is null: ${accessToken == null}');
      print('accessToken is empty: ${accessToken?.isEmpty}');

      final headers = {
        ...ApiConfig.defaultHeaders,
        'Authorization': 'Bearer $refreshToken',
      };
      print('Headers being sent: $headers');
      print('=== END DEBUG ===');

      final response = await apiService.post(
        ApiConfig.refreshTokenEndpoint,
        headers: headers,
      );
      print(ApiConfig.defaultHeaders);
      print(response);
      print("responseresponse");
      if (response.isSuccess && response.data != null) {
        return Right(http.Response(
          response.data.toString(),
          200,
          headers: {'content-type': 'application/json'},
        ));
      } else {
        final errorMessage = response.errorMessage!;
        return Left(Failure(errorMessage));
      }
    } catch (e) {
      return Left(Failure('$e'));
    }
  }
}
