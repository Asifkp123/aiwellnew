import 'package:aiwel/features/auth/data/repositories/auth_repository.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/network/error/failure.dart';
import '../repositories/auth_repository.dart';

abstract class GetRefreshTokenUseCaseBase {
  Future<Either<Failure, String?>> execute();
}

class GetRefreshTokenUseCase implements GetRefreshTokenUseCaseBase {
  final AuthRepositoryImpl authRepository;

  GetRefreshTokenUseCase({required this.authRepository});

  @override
  Future<Either<Failure, String?>> execute() async {
    try {
      final refreshToken = await authRepository.getRefreshToken();
      return Right(refreshToken);
    } catch (e) {
      return Left(Failure('Failed to retrieve refresh token: $e'));
    }
  }
}
