import 'package:dartz/dartz.dart';
import '../../../../core/network/error/failure.dart';
import '../../data/repositories/auth_repository.dart';

abstract class GetAccessTokenExpiryUseCaseBase {
Future<Either<Failure, int?>> execute();
}

class GetAccessTokenExpiryUseCase implements GetAccessTokenExpiryUseCaseBase {
final AuthRepository authRepository;

GetAccessTokenExpiryUseCase({required this.authRepository});

@override
Future<Either<Failure, int?>> execute() async {
try {
final expiry = await authRepository.getAccessTokenExpiry();
return Right(expiry);
} catch (e) {
return Left(Failure('Failed to retrieve access token expiry: $e'));
}
}
}
