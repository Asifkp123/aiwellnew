import 'package:dartz/dartz.dart';

import '../../../../core/network/error/failure.dart';
import '../../data/models/api/otp_request_success.dart';
import '../../data/models/api/verify_otp_response.dart';
import '../../data/repositories/auth_repository.dart';

class VerifyOtpUseCase {
  final AuthRepository repository;

  VerifyOtpUseCase({required this.repository});

  Future<Either<Failure, VerifyOtpResponse>> execute(String identifier, String otp) async {
    try {
      final response = await repository.verifyOtp(identifier, otp);

      return response.fold(
            (failure) => Left(failure), // Propagate the failure
            (otpSuccess) =>
            Right(VerifyOtpResponse(otpSuccess.response, otpSuccess.token)), // Pass the OtpRequestSuccess directly
      );
    }
    catch (e) {
      return Left(Failure("Failed to verify OTP: $e"));
    }
  }
}