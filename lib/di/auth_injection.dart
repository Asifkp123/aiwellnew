import 'package:aiwel/core/network/http_api_services.dart';
import 'package:aiwel/di/splah_dependency_manager.dart';
import 'package:aiwel/features/auth/data/datasources/local/auth_local_datasource.dart';
import 'package:aiwel/features/auth/data/datasources/remote/auth_remote_datasource.dart';
import 'package:aiwel/features/auth/data/repositories/auth_repository.dart';
import 'package:aiwel/features/auth/domain/usecases/get_access_token_use_case.dart';
import 'package:aiwel/features/auth/domain/usecases/get_access_token_expiry_use_case.dart';
import 'package:aiwel/features/auth/domain/usecases/refresh_token_use_case.dart';
import 'package:aiwel/features/auth/domain/usecases/request_otp_use_case.dart';
import 'package:aiwel/features/auth/domain/usecases/submit_profile_use_case.dart';
import 'package:aiwel/features/auth/domain/usecases/verify_otp_use_case.dart';
import 'package:aiwel/features/auth/presentation/view_models/sign_in_viewModel.dart';
import 'package:aiwel/features/auth/presentation/view_models/auth_view_model.dart';
import 'package:aiwel/features/auth/presentation/view_models/profile_view_model.dart';
import 'package:aiwel/features/auth/presentation/view_models/splash_viewModel.dart';
import 'package:aiwel/features/pal_creation/presentation/view_models/add_pal_view_model.dart';
import 'package:aiwel/features/pal_creation/di/pal_injection.dart';
import 'package:aiwel/core/services/token_manager.dart';

import '../features/auth/domain/repositories/auth_repository.dart';

class DependencyManager {
  static Future<SignInViewModel> createSignInViewModel() async {
    try {
      // Initialize TokenManager first
      final tokenManager = await TokenManager.getInstance();

      final authLocalDataSource = AuthLocalDataSourceImpl(tokenManager);

      // Initialize HttpApiService with TokenManager
      final apiService = HttpApiService(
        tokenManager: tokenManager,
      );

      // Initialize AuthRemoteDataSource with IApiService
      final authRemoteDataSource = AuthRemoteDataSourceImpl(
        authLocalDataSource: authLocalDataSource,
        apiService: apiService,
      );

      // Initialize RefreshTokenUseCase
      final refreshTokenUseCase = RefreshTokenUseCase(
        authRemoteDataSource: authRemoteDataSource,
        tokenManager: tokenManager,
      );

      // Now set the refreshTokenUseCase in apiService
      (apiService as HttpApiService).refreshTokenUseCase = refreshTokenUseCase;

      // Initialize AuthRepository
      final AuthRepositoryImpl authRepository = AuthRepositoryImpl(
        authRemoteDataSource: authRemoteDataSource,
        authLocalDataSource: authLocalDataSource,
        tokenManager: tokenManager,
      );

      // Initialize use cases
      final requestOtpUseCase = RequestOtpUseCase(repository: authRepository);
      final submitProfileUseCase =
      SubmitProfileUseCase(authRepository: authRepository);
      final verifyOtpUseCaseImpl = VerifyOtpUseCaseImpl(
        authRepository,
        tokenManager,
      );
      final getAccessTokenUseCase =
      GetAccessTokenUseCase(authRepository: authRepository);
      final getAccessTokenExpiryUseCase =
      GetAccessTokenExpiryUseCase(authRepository: authRepository);

      // Return SignInViewModel with all dependencies
      return SignInViewModel(
        requestOtpUseCase: requestOtpUseCase,
        verifyOtpUseCaseBase: verifyOtpUseCaseImpl,
        authLocalDataSourceImpl: authLocalDataSource,
        submitProfileUseCaseBase: submitProfileUseCase,
        getAccessTokenUseCase: getAccessTokenUseCase,
        getAccessTokenExpiryUseCase: getAccessTokenExpiryUseCase,
        refreshUseCase: refreshTokenUseCase,
      );
    } catch (e) {
      throw Exception('Failed to create SignInViewModel: $e');
    }
  }

  // Create AuthViewModel (for signin/signup/otp screens only)
  static Future<AuthViewModel> createAuthViewModel() async {
    try {
      // Initialize TokenManager first
      final tokenManager = await TokenManager.getInstance();

      final authLocalDataSource = AuthLocalDataSourceImpl(tokenManager);

      // Initialize HttpApiService with TokenManager
      final apiService = HttpApiService(
        tokenManager: tokenManager,
      );

      // Initialize AuthRemoteDataSource with IApiService
      final authRemoteDataSource = AuthRemoteDataSourceImpl(
        authLocalDataSource: authLocalDataSource,
        apiService: apiService,
      );

      // Initialize AuthRepository
      final AuthRepositoryImpl authRepository = AuthRepositoryImpl(
        authRemoteDataSource: authRemoteDataSource,
        authLocalDataSource: authLocalDataSource,
        tokenManager: tokenManager,
      );

      // Initialize use cases for auth only
      final requestOtpUseCase = RequestOtpUseCase(repository: authRepository);
      final verifyOtpUseCaseImpl = VerifyOtpUseCaseImpl(
        authRepository,
        tokenManager,
      );

      // Return AuthViewModel with dependencies
      return AuthViewModel(
        requestOtpUseCase: requestOtpUseCase,
        verifyOtpUseCaseBase: verifyOtpUseCaseImpl,
        authLocalDataSourceImpl: authLocalDataSource,
      );
    } catch (e) {
      throw Exception('Failed to create AuthViewModel: $e');
    }
  }

  // Create ProfileViewModel (for all profile screens)
  static Future<ProfileViewModel> createProfileViewModel() async {
    try {
      // Initialize TokenManager first
      final tokenManager = await TokenManager.getInstance();

      final authLocalDataSource = AuthLocalDataSourceImpl(tokenManager);

      // Initialize HttpApiService with TokenManager
      final apiService = HttpApiService(
        tokenManager: tokenManager,
      );

      // Initialize AuthRemoteDataSource with IApiService
      final authRemoteDataSource = AuthRemoteDataSourceImpl(
        authLocalDataSource: authLocalDataSource,
        apiService: apiService,
      );

      // Initialize RefreshTokenUseCase
      final refreshTokenUseCase = RefreshTokenUseCase(
        authRemoteDataSource: authRemoteDataSource,
        tokenManager: tokenManager,
      );

      // Now set the refreshTokenUseCase in apiService
      (apiService as HttpApiService).refreshTokenUseCase = refreshTokenUseCase;

      // Initialize AuthRepository
      final AuthRepositoryImpl authRepository = AuthRepositoryImpl(
        authRemoteDataSource: authRemoteDataSource,
        authLocalDataSource: authLocalDataSource,
        tokenManager: tokenManager,
      );

      // Initialize use cases for profile
      final submitProfileUseCase =
      SubmitProfileUseCase(authRepository: authRepository);
      final getAccessTokenUseCase =
      GetAccessTokenUseCase(authRepository: authRepository);

      // Return ProfileViewModel with dependencies
      return ProfileViewModel(
        submitProfileUseCaseBase: submitProfileUseCase,
        getAccessTokenUseCase: getAccessTokenUseCase,
        refreshUseCase: refreshTokenUseCase,
        authLocalDataSourceImpl: authLocalDataSource,
      );
    } catch (e) {
      throw Exception('Failed to create ProfileViewModel: $e');
    }
  }

  static Future<AddPalViewModel> createAddPalViewModel() async {
    try {
      // Use the PAL dependency manager
      return await PalDependencyManager.createAddPalViewModel();
    } catch (e) {
      throw Exception('Failed to create AddPalViewModel: $e');
    }
  }

  static Future<SplashViewModel> createSplashViewModel() async {
    try {
      // Use the PAL dependency manager
      return await SplashDependencyManager.createSplashViewModel();
    } catch (e) {
      throw Exception('Failed to create AddPalViewModel: $e');
    }
  }

  static Future<AuthRepositoryImpl> createAuthRepository() async {
    try {
      // Initialize TokenManager first
      final tokenManager = await TokenManager.getInstance();

      // Initialize MethodChannel-based AuthLocalDataSourceImpl
      final authLocalDataSource = AuthLocalDataSourceImpl(tokenManager);

      // Initialize HttpApiService with TokenManager
      final apiService = HttpApiService(
        tokenManager: tokenManager,
      );

      // Initialize AuthRemoteDataSource with IApiService
      final authRemoteDataSource = AuthRemoteDataSourceImpl(
        authLocalDataSource: authLocalDataSource,
        apiService: apiService,
      );

      // Initialize AuthRepository with TokenManager
      final authRepository = AuthRepositoryImpl(
        authRemoteDataSource: authRemoteDataSource,
        authLocalDataSource: authLocalDataSource,
        tokenManager: tokenManager,
      );

      return authRepository;
    } catch (e) {
      throw Exception('Failed to create AuthRepository: $e');
    }
  }
}
