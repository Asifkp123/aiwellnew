import 'package:aiwel/features/auth/data/datasources/local/auth_local_datasource.dart';
import 'package:aiwel/features/auth/data/datasources/remote/auth_remote_datasource.dart';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;

import '../../../../core/network/error/failure.dart';
import '../../data/models/api/otp_request_success.dart';
import '../../data/models/api/verify_otp_response.dart';
import '../../data/repositories/auth_repository.dart';

abstract class VerifyOtpUseCaseBase {
  Future<Either<Failure,  VerifyOtpResponse>> execute(String identifier, String otp);
}


class VerifyOtpUseCase implements VerifyOtpUseCaseBase {
  final AuthRepository repository;
  final AuthLocalDataSourceBase authLocalDataSource;

  VerifyOtpUseCase({required this.repository,required this.authLocalDataSource});

  Future<Either<Failure, VerifyOtpResponse>> execute(String identifier, String otp) async {
    try {
      final response = await repository.verifyOtp(identifier, otp);
      return response.fold(
            (failure) => Left(failure),
            (response) async {
          try {
            final verifyResponse = response.toVerifyOtpResponse();
            if (verifyResponse.token!.isEmpty) {
              return Left(Failure('Verification failed: empty token'));
            }
            await authLocalDataSource.saveToken(verifyResponse.token!);
            return Right(verifyResponse);
          } catch (e) {
            return Left(Failure('Failed to process OTP verification: $e'));
          }
        },
      );
    } catch (e) {
      return Left(Failure('Failed to verify OTP: $e'));
    }
  }}