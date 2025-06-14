import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;

import '../../../../core/network/error/failure.dart';
import '../../data/datasources/remote/auth_remote_datasource.dart';
import '../../data/datasources/local/auth_local_datasource.dart';
import '../../domain/usecases/request_otp_use_case.dart';
import '../models/api/otp_request_success.dart';
import '../models/api/verify_otp_response.dart';

abstract class AuthRepository {
  Future<Either<Failure, OtpRequestSuccess>> requestOtp({String? email, String? phoneNumber});
  Future<Either<Failure, http.Response>> verifyOtp(String identifier, String otp);
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
  @override
  Future<Either<Failure, http.Response>> verifyOtp(String identifier, String otp) async {
    final response = await authRemoteDataSource.verifyOtp(identifier, otp);
    return response.fold(
          (failure) => Left(failure),
          (response) async {
        try {
          if (response != null) {
            return Right(response);
          } else {
            return Left(Failure('Verification failed: empty response'));
          }
        } catch (e) {
          return Left(Failure('Failed to save token: $e'));
        }
      },
    );
  }}