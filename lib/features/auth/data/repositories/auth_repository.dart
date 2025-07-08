import 'package:dartz/dartz.dart';
import '../../../../core/network/error/failure.dart';
import '../datasources/local/auth_local_datasource.dart';
import '../datasources/remote/auth_remote_datasource.dart';
import '../models/api/otp_request_success.dart';
import '../models/api/token_resonse.dart';
import '../models/api/submit_profile_response.dart';
import '../models/api/verify_otp_response.dart';

abstract class AuthRepository {
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
Future<String?> getAccessToken();
Future<int?> getAccessTokenExpiry();
}


class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource authRemoteDataSource;
  final AuthLocalDataSourceBase authLocalDataSource;

  AuthRepositoryImpl({
    required this.authRemoteDataSource,
    required this.authLocalDataSource,
  });

  @override
  Future<Either<Failure, OtpRequestSuccess>> requestOtp({String? email, String? phoneNumber}) async {
    return await authRemoteDataSource.requestOtp(email: email, phoneNumber: phoneNumber);
  }

  @override
  Future<Either<Failure, TokenResponse>> verifyOtp(String identifier, String otp) async {
    return await authRemoteDataSource.verifyOtp(identifier, otp);
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
    return await authRemoteDataSource.submitProfile(
      firstName: firstName,
      lastName: lastName,
      gender: gender,
      dateOfBirth: dateOfBirth,
      dominantEmotion: dominantEmotion,
      sleepQuality: sleepQuality,
      physicalActivity: physicalActivity,
    );
  }

  @override
  Future<String?> getAccessToken() async {
    return await authLocalDataSource.getAccessToken();
  }

  @override
  Future<int?> getAccessTokenExpiry() async {
    return await authLocalDataSource.getAccessTokenExpiry();
  }
}