import 'dart:convert';
import 'package:dartz/dartz.dart';
import '../../../../core/network/error/failure.dart';
import '../../data/datasources/local/auth_local_datasource.dart';
import '../../data/datasources/remote/auth_remote_datasource.dart';
import '../../data/models/api/token_resonse.dart';
import '../../data/models/api/verify_otp_response.dart';
import '../../data/repositories/auth_repository.dart';

abstract class VerifyOtpUseCaseBase {
  Future<Either<Failure, VerifyOtpResponse>> execute(String identifier, String otp);
}

class VerifyOtpUseCase implements VerifyOtpUseCaseBase {
  final AuthRepository repository;
  final AuthLocalDataSourceBase authLocalDataSource;

  VerifyOtpUseCase({
    required this.repository,
    required this.authLocalDataSource,
  });

  @override
  Future<Either<Failure, VerifyOtpResponse>> execute(String identifier, String otp) async {
    try {
      final response = await repository.verifyOtp(identifier, otp);
      return response.fold(
            (failure) {
          return Left(Failure(failure.message.isNotEmpty ? failure.message : 'Verification failed'));
        },
            (tokenResponse) async {
          if (tokenResponse is TokenResponse) {
            if (tokenResponse.accessToken.isEmpty || tokenResponse.refreshToken.isEmpty) {
              return Left(Failure('Verification failed: empty token'));
            }
            await authLocalDataSource.saveTokens(
              accessToken: tokenResponse.accessToken,
              accessTokenExpiry: tokenResponse.accessTokenExpiry,
              refreshToken: tokenResponse.refreshToken,
              refreshTokenExpiry: tokenResponse.refreshTokenExpiry,
            );
            return Right(tokenResponse as VerifyOtpResponse);
          } else {
            return Left(Failure('Invalid response type from verification'));
          }
        },
      );
    } catch (e) {
      return Left(Failure('Failed to verify OTP: $e'));
    }
  }
}