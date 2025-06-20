import 'package:dartz/dartz.dart';

import '../../../../core/network/error/failure.dart';
import '../../data/models/api/otp_request_success.dart';
import '../../data/repositories/auth_repository.dart';



abstract class RequestOtpUseCaseBase {
  Future<Either<Failure, OtpRequestSuccess>> execute({String? email, String? phoneNumber});
}


class RequestOtpUseCase  extends RequestOtpUseCaseBase{
  final AuthRepository repository;

  RequestOtpUseCase({required this.repository});

  Future<Either<Failure, OtpRequestSuccess>> execute({String? email, String? phoneNumber}) async {
    try {
      Either<Failure, OtpRequestSuccess> response = await repository.requestOtp(
          email: email, phoneNumber: phoneNumber);

      return response.fold(
            (failure) => Left(failure), // Propagate the failure
            (otpSuccess) => Right(otpSuccess), // Pass the OtpRequestSuccess directly
      );
    }catch (e) {
      return Left(Failure('Failed to request OTP: $e'));
    }
  }
}



