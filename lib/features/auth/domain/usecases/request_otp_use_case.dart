import 'package:dartz/dartz.dart';

import '../../../../core/network/error/failure.dart';
import '../../data/models/api/otp_request_success.dart';
import '../../data/repositories/auth_repository.dart';
import '../repositories/auth_repository.dart';

abstract class RequestOtpUseCaseBase {
  Future<Either<Failure, OtpRequestSuccess>> execute(
      {String? email, String? phoneNumber});
}

class RequestOtpUseCase extends RequestOtpUseCaseBase {
  final AuthRepositoryImpl repository;

  RequestOtpUseCase({required this.repository});

  @override
  Future<Either<Failure, OtpRequestSuccess>> execute(
      {String? email, String? phoneNumber}) async {
    // Validate input parameters
    if (email == null && phoneNumber == null) {
      return Left(Failure('Either email or phone number is required'));
    }

    if (email != null && email.trim().isEmpty) {
      return Left(Failure('Email cannot be empty'));
    }

    if (phoneNumber != null && phoneNumber.trim().isEmpty) {
      return Left(Failure('Phone number cannot be empty'));
    }

    // Validate email format if provided
    if (email != null) {
      final emailRegex =
          RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
      if (!emailRegex.hasMatch(email.trim())) {
        return Left(Failure('Invalid email format'));
      }
    }

    // Validate phone number format if provided
    if (phoneNumber != null) {
      final phoneRegex = RegExp(r'^\+?[1-9]\d{9,14}$');
      if (!phoneRegex.hasMatch(phoneNumber.trim())) {
        return Left(Failure('Invalid phone number format'));
      }
    }

    // Execute the repository call
    return await repository.requestOtp(
      email: email?.trim(),
      phoneNumber: phoneNumber?.trim(),
    );
  }
}
