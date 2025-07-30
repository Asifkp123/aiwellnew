import 'package:dartz/dartz.dart';
import '../../../../core/network/error/failure.dart';
import '../entities/otp_verification.dart';

abstract class AuthRepository {
  Future<Either<Failure, OtpVerification>> verifyOtp(
      String identifier, String otp);
  Future<String?> getAccessToken();
  Future<int?> getAccessTokenExpiry();
  Future<bool?> getApprovalStatus();
}
