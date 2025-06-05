import 'dart:async';
import 'package:dartz/dartz.dart';

import '../../../../core/network/error/failure.dart';
import '../../data/datasources/remote/auth_remote_datasource.dart';
import '../../data/datasources/local/auth_local_datasource.dart';
import '../../domain/usecases/request_otp_use_case.dart';
import '../models/api/otp_request_success.dart';
import '../models/api/verify_otp_response.dart';

abstract class AuthRepository {
  Future<Either<Failure, OtpRequestSuccess>> requestOtp({String? email, String? phoneNumber});
  Future<Either<Failure, VerifyOtpResponse>> verifyOtp(String identifier, String otp);
}

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource authRemoteDataSource;
  final AuthLocalDataSourceBase authLocalDataSource;


  AuthRepositoryImpl({
    required this.authRemoteDataSource,
    required this.authLocalDataSource,
  });

  @override
  Future<Either<Failure, OtpRequestSuccess>> requestOtp(
      {String? email, String? phoneNumber}) async {
    Either<Failure, OtpRequestSuccess> response = await authRemoteDataSource
        .requestOtp(email: email, phoneNumber: phoneNumber);
    return response;
  }


  @override
  Future<Either<Failure, VerifyOtpResponse>> verifyOtp(String identifier, String otp) async {
    final response = await authRemoteDataSource.verifyOtp(identifier, otp);

    // Use fold to handle both Left and Right cases
    return response.fold(
          (failure) => Left(failure), // Propagate the failure
          (success) async {
        try {
          // Extract and save the token if it exists
          if (success.token != null) {
            await authLocalDataSource.saveToken(success.token!);
          }

          return Right(success); // Return the success result
        } catch (e) {
          // Handle errors from saveToken
          return Left(Failure('Failed to save token: $e'));
        }
      },
    );
  }
}