import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import '../../../../../core/config/api_config.dart';
import '../../../../../core/network/error/failure.dart';
import '../../../../../core/network/model/api_response.dart';
import '../../models/api/otp_request_success.dart';
import '../../models/api/submit_profile_response.dart';
import '../../models/api/token_resonse.dart';
import '../../models/api/verify_otp_response.dart';
import '../local/auth_local_datasource.dart';
import '../../../../../core/network/api_service.dart';

abstract class AuthRemoteDataSource {
  Future<Either<Failure, OtpRequestSuccess>> requestOtp(
      {String? email, String? phoneNumber});
  Future<Either<Failure, ApiResponse>> verifyOtp(String identifier, String otp);
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
  final IApiService apiService;

  AuthRemoteDataSourceImpl(
      {required this.authLocalDataSource, required this.apiService});

  @override
  Future<Either<Failure, OtpRequestSuccess>> requestOtp(
      {String? email, String? phoneNumber}) async {
    print("requestOtp called");
    try {
      final payload =
          email != null ? {'email': email} : {'phone_number': phoneNumber};
      print("Payload: $payload");

      print("About to call apiService.post");
      final response = await apiService.post(
        ApiConfig.requestOtpEndpoint,
        body: payload,
        headers: ApiConfig.defaultHeaders,
      );
      print("apiService.post returned");
      print(response);
      print("response");

      if (response.isSuccess && response.data != null) {
        return Right(OtpRequestSuccess(response.data.toString()));
      } else {
        final errorMessage = response.errorMessage ?? 'Failed to request OTP';
        return Left(Failure(errorMessage));
      }
    } catch (e) {
      print("Exception in requestOtp: $e");
      return Left(Failure('Network error: $e'));
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
      final payload = {
        'identifier': identifier,
        'otp': otp,
      };

      final response = await apiService.post(
        ApiConfig.verifyOtpEndpoint,
        body: payload,
        headers: ApiConfig.defaultHeaders,
      );

      if (response.isSuccess && response.data != null) {
        return Right(response);
      } else {
        final errorMessage = response.errorMessage ?? 'OTP verification failed';
        return Left(Failure(errorMessage));
      }
    } catch (e) {
      return Left(Failure('Verification failed: $e'));
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

  Future<Either<Failure, SubmitProfileResponse>> _performProfileSubmission({
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

      if (response.isSuccess && response.data != null) {
        return Right(SubmitProfileResponse.fromJson(response.data));
      } else {
        final errorMessage =
            response.errorMessage ?? 'Profile submission failed';
        return Left(Failure(errorMessage));
      }
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
      final response = await apiService.post(
        ApiConfig.refreshTokenEndpoint,
        headers: {
          ...ApiConfig.defaultHeaders,
          'X-Refresh-Token': refreshToken,
        },
      );

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
