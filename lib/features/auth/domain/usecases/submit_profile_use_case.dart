import 'package:dartz/dartz.dart';
import '../../../../core/network/error/failure.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/models/api/submit_profile_response.dart';

abstract class SubmitProfileUseCaseBase {
  Future<Either<Failure, bool>> execute({
    required String firstName,
    required String lastName,
    required String gender,
    required String dateOfBirth,
    required String dominantEmotion,
    required String sleepQuality,
    required String physicalActivity,
  });
}

class SubmitProfileUseCase implements SubmitProfileUseCaseBase {
  final AuthRepository authRepository;

  SubmitProfileUseCase({required this.authRepository});

  @override
  Future<Either<Failure, bool>> execute({
    required String firstName,
    required String lastName,
    required String gender,
    required String dateOfBirth,
    required String dominantEmotion,
    required String sleepQuality,
    required String physicalActivity,
  }) async {
    final result = await authRepository.submitProfile(
      firstName: firstName,
      lastName: lastName,
      gender: gender,
      dateOfBirth: dateOfBirth,
      dominantEmotion: dominantEmotion,
      sleepQuality: sleepQuality,
      physicalActivity: physicalActivity,
    );
    return result.fold(
          (failure) => Left(failure),
          (response) => Right(response.success),
    );
  }
}