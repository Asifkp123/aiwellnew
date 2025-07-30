import 'package:aiwel/features/auth/data/datasources/local/auth_local_datasource.dart';
import 'package:aiwel/features/auth/data/datasources/remote/auth_remote_datasource.dart';
import 'package:aiwel/features/auth/data/repositories/auth_repository.dart';
import 'package:aiwel/features/auth/domain/repositories/auth_repository.dart';
import 'package:aiwel/features/auth/domain/usecases/check_auth_status_use_case.dart';
import 'package:aiwel/features/auth/domain/usecases/get_access_token_use_case.dart';
import 'package:aiwel/features/auth/domain/usecases/get_access_token_expiry_use_case.dart';
import 'package:aiwel/features/auth/domain/usecases/get_refresh_token_use_case.dart';
import 'package:aiwel/features/auth/domain/usecases/get_refresh_token_expiry_use_case.dart';
import 'package:aiwel/features/auth/domain/usecases/refresh_token_use_case.dart';
import 'package:aiwel/features/auth/presentation/screens/profile_screens/profile_screen.dart';
import 'package:aiwel/features/auth/presentation/screens/signin_signup_screen.dart';
import 'package:aiwel/features/auth/presentation/view_models/splash_viewModel.dart';
import 'package:aiwel/features/home/home_screen.dart';

import '../../../core/network/http_api_services.dart';
import '../../../core/services/token_manager.dart';

class SplashDependencyManager {
  static Future<SplashViewModel> createSplashViewModel() async {
    try {
      // Step 1: Initialize TokenManager
      final tokenManager = await TokenManager.getInstance();

      // Step 2: Auth Local and Remote
      final authLocalDataSource = AuthLocalDataSourceImpl(tokenManager);
      final authRemoteDataSource = AuthRemoteDataSourceImpl(
        authLocalDataSource: authLocalDataSource,
        apiService: HttpApiService(tokenManager: tokenManager),
      );

      // Step 3: Auth Repository
      final authRepository = AuthRepositoryImpl(
        authRemoteDataSource: authRemoteDataSource,
        authLocalDataSource: authLocalDataSource,
        tokenManager: tokenManager,
      );

      // Step 4: Auth Use Cases
      final getAccessTokenUseCase =
          GetAccessTokenUseCase(authRepository: authRepository);
      final getAccessTokenExpiryUseCase =
          GetAccessTokenExpiryUseCase(authRepository: authRepository);
      final getRefreshTokenUseCase =
          GetRefreshTokenUseCase(authRepository: authRepository);
      final getRefreshTokenExpiryUseCase =
          GetRefreshTokenExpiryUseCase(authRepository: authRepository);
      final refreshTokenUseCase = RefreshTokenUseCase(
        authRemoteDataSource: authRemoteDataSource,
        tokenManager: tokenManager,
      );

      // Step 5: ViewModels Map (for navigation screens)
      final viewModels = {
        ProfileScreen.routeName:
            null, // Replace with actual ProfileViewModel if needed
        SigninSignupScreen.routeName:
            null, // Replace with actual SigninSignupViewModel if needed
      };

      // Step 6: Return SplashViewModel
      return SplashViewModel(
        authRepository: authRepository,
        getAccessTokenUseCase: getAccessTokenUseCase,
        getAccessTokenExpiryUseCase: getAccessTokenExpiryUseCase,
        getRefreshTokenUseCase: getRefreshTokenUseCase,
        getRefreshTokenExpiryUseCase: getRefreshTokenExpiryUseCase,
        refreshTokenUseCase: refreshTokenUseCase,
        viewModels: viewModels,
      );
    } catch (e) {
      throw Exception('Failed to create SplashViewModel: $e');
    }
  }
}
