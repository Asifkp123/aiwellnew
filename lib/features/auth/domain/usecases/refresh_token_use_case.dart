import 'dart:convert';

import 'package:dartz/dartz.dart';
import '../../../../core/network/error/failure.dart';
import '../../../../core/services/token_manager.dart';
import '../../data/datasources/remote/auth_remote_datasource.dart';

abstract class RefreshTokenUseCaseBase {
  Future<Either<Failure, bool>> execute();
}

class RefreshTokenUseCase implements RefreshTokenUseCaseBase {
  final AuthRemoteDataSource authRemoteDataSource;
  final TokenManager tokenManager;

  RefreshTokenUseCase({
    required this.authRemoteDataSource,
    required this.tokenManager,
  });

  @override
  Future<Either<Failure, bool>> execute() async {
    final refreshToken = await tokenManager.getRefreshToken();
    print(refreshToken);
    print("refreshToken fetched succesfully");
    final refreshTokenExpiry = await tokenManager.getRefreshTokenExpiry();

    if (refreshToken == null || refreshTokenExpiry == null) {
      return Left(Failure('No refresh token available'));
    }

    final currentTime = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    if (currentTime >= refreshTokenExpiry) {
      return Left(Failure('Refresh token has expired'));
    }

    final result = await authRemoteDataSource.refreshToken(refreshToken);
    return result.fold(
      (failure) async {
        print("Error occurred while refreshing token: ${failure.message}");
        return Left(failure);
      },
      (response) async {
        print("Response received from remote data source: $response");
        if (response.statusCode == 200) {
          final accessToken =
              response.headers['authorization']?.replaceAll('Bearer ', '') ??
                  '';
          final accessTokenExpiry =
              int.tryParse(response.headers['x-token-expiry'] ?? '') ?? 0;
          final newRefreshToken =
              response.headers['x-refresh-token'] ?? refreshToken;
          final newRefreshTokenExpiry =
              int.tryParse(response.headers['x-refresh-expiry'] ?? '') ??
                  refreshTokenExpiry;

          await tokenManager.saveTokens(
            accessToken: accessToken,
            accessTokenExpiry: accessTokenExpiry,
            refreshToken: newRefreshToken,
            refreshTokenExpiry: newRefreshTokenExpiry,
          );
          return Right(true);
        } else {
          final responseBody =
              jsonDecode(response.body) as Map<String, dynamic>;
          final errorMessage =
              responseBody['message'] ?? 'Token refresh failed';
          return Left(Failure(errorMessage));
        }
      },
    );
  }
}
