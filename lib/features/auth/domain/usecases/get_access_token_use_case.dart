import 'package:dartz/dartz.dart';
import '../../../../core/network/error/failure.dart';
import '../../data/repositories/auth_repository.dart';

abstract class GetAccessTokenUseCaseBase {
  Future<Either<Failure, (String?, int?)>> execute();
}

class GetAccessTokenUseCase implements GetAccessTokenUseCaseBase {
  final AuthRepository authRepository;

  GetAccessTokenUseCase({required this.authRepository});

  @override
  Future<Either<Failure, (String?, int?)>> execute() async {
    try {
      final accessToken = await authRepository.getAccessToken();
      final accessTokenExpiry = await authRepository.getAccessTokenExpiry();
      return Right((accessToken, accessTokenExpiry));
    } catch (e) {
      return Left(Failure('Failed to retrieve token or expiry: $e'));
    }
  }
}