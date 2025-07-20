import 'dart:convert';
import 'package:dartz/dartz.dart';
import '../../../../core/network/error/failure.dart';
import '../../../../core/services/token_manager.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/models/api/verify_otp_response.dart';
import '../entities/otp_verification.dart';

class VerifyOtpParams {
  final String identifier;
  final String otp;

  VerifyOtpParams({
    required this.identifier,
    required this.otp,
  });
}

abstract class VerifyOtpUseCaseBase {
  Future<Either<Failure, OtpVerification>> execute(VerifyOtpParams params);
}

class VerifyOtpUseCase implements VerifyOtpUseCaseBase {
  final AuthRepository _authRepository;
  final TokenManager _tokenManager;

  VerifyOtpUseCase({
    required AuthRepository authRepository,
    required TokenManager tokenManager,
  })  : _authRepository = authRepository,
        _tokenManager = tokenManager;

  // Business Logic
  @override
  Future<Either<Failure, OtpVerification>> execute(
      VerifyOtpParams params) async {
    // Domain Validation
    if (!_isValidIdentifier(params.identifier)) {
      return Left(Failure('Invalid identifier format'));
    }

    if (!_isValidOtp(params.otp)) {
      return Left(Failure('OTP must be exactly 6 digits'));
    }

    // Business Rules
    if (_isExpiredOtp(params.otp)) {
      return Left(Failure('OTP has expired'));
    }

    // Repository Call
    final result =
        await _authRepository.verifyOtp(params.identifier, params.otp);

    return result.fold(
      (failure) => Left(failure),
      (verification) async {
        print("herer11");
        // ✅ BUSINESS LOGIC IN USE CASE - Save tokens and approval status
        if (verification.accessToken != null && verification.refreshToken != null) {
          print("herer22");

          await _tokenManager.saveTokens(
            accessToken: verification.accessToken!,
            accessTokenExpiry: verification.accessTokenExpiry ?? 0,
            refreshToken: verification.refreshToken!,
            refreshTokenExpiry: verification.refreshTokenExpiry ?? 0,
          );
        }
        // await _tokenManager.saveApprovalStatus(verification.isApproved);
        return Right(verification);
      },
    );
  }

  // Business Logic Validation
  bool _isValidIdentifier(String identifier) {
    return identifier.isNotEmpty && identifier.length >= 3;
  }

  bool _isValidOtp(String otp) {
    return otp.length == 6 && RegExp(r'^\d{6}$').hasMatch(otp);
  }

  // Business Rules
  bool _isExpiredOtp(String otp) {
    // This is a placeholder for OTP expiration logic
    // In real implementation, you would check against stored timestamp
    return false;
  }
}
