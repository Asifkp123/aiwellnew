import 'package:dartz/dartz.dart';
import '../../../../core/network/error/failure.dart';
import '../../data/repositories/auth_repository.dart';
import '../repositories/auth_repository.dart';

abstract class GetRefreshTokenExpiryUseCaseBase {
  Future<Either<Failure, int?>> execute();
}

class GetRefreshTokenExpiryUseCase implements GetRefreshTokenExpiryUseCaseBase {
  final AuthRepositoryImpl authRepository;

  GetRefreshTokenExpiryUseCase({required this.authRepository});

  @override
  Future<Either<Failure, int?>> execute() async {
    try {
      final expiry = await authRepository.getRefreshTokenExpiry();
      return Right(expiry);
    } catch (e) {
      return Left(Failure('Failed to retrieve refresh token expiry: $e'));
    }
  }
}
