import 'dart:async';
import '../../data/datasources/remote/auth_remote_datasource.dart';
import '../../data/datasources/local/auth_local_datasource.dart';

abstract class AuthRepository {
  Future<void> requestOtp({String? email, String? phoneNumber});
  Future<String> verifyOtp(String identifier, String otp);
}

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource authRemoteDataSource;
  final AuthLocalDataSource authLocalDataSource;

  AuthRepositoryImpl({
    required this.authRemoteDataSource,
    required this.authLocalDataSource,
  });

  @override
  Future<void> requestOtp({String? email, String? phoneNumber}) async {
    try {
      await authRemoteDataSource.requestOtp(email: email, phoneNumber: phoneNumber);
    } catch (e) {
      throw Exception('Failed to request OTP: $e');
    }
  }

  @override
  Future<String> verifyOtp(String identifier, String otp) async {
    try {
      final token = await authRemoteDataSource.verifyOtp(identifier, otp);
      await authLocalDataSource.saveToken(token); // Save token locally
      return token;
    } catch (e) {
      throw Exception('Failed to verify OTP: $e');
    }
  }
}