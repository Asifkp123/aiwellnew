import '../../data/repositories/auth_repository.dart';

class RequestOtpUseCase {
  final AuthRepository repository;

  RequestOtpUseCase({required this.repository});

  Future<void> execute({String? email, String? phoneNumber}) async {
    await repository.requestOtp(email: email, phoneNumber: phoneNumber);
  }
}

class VerifyOtpUseCase {
  final AuthRepository repository;

  VerifyOtpUseCase({required this.repository});

  Future<String> execute(String identifier, String otp) async {
    return await repository.verifyOtp(identifier, otp);
  }
}