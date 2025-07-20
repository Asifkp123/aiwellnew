import 'package:aiwel/core/network/http_api_services.dart';
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
import 'package:aiwel/features/pal_creation/presentation/view_models/add_pal_view_model.dart';
import 'package:aiwel/features/pal_creation/di/pal_injection.dart';
import 'package:aiwel/core/services/token_manager.dart';

class DependencyManager {
  static Future<SignInViewModel> createSignInViewModel() async {
    try {
      // Initialize TokenManager first
      final tokenManager = await TokenManager.getInstance();

      final authLocalDataSource = AuthLocalDataSourceImpl();

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
      final authRepository = AuthRepositoryImpl(
        authRemoteDataSource: authRemoteDataSource,
        authLocalDataSource: authLocalDataSource,
        tokenManager: tokenManager,
      );

      // Initialize use cases
      final requestOtpUseCase = RequestOtpUseCase(repository: authRepository);
      final submitProfileUseCase =
          SubmitProfileUseCase(authRepository: authRepository);
      final verifyOtpUseCase = VerifyOtpUseCase(
        authRepository: authRepository,
        tokenManager: tokenManager,
      );
      final getAccessTokenUseCase =
          GetAccessTokenUseCase(authRepository: authRepository);
      final getAccessTokenExpiryUseCase =
          GetAccessTokenExpiryUseCase(authRepository: authRepository);

      // Return SignInViewModel with all dependencies
      return SignInViewModel(
        requestOtpUseCase: requestOtpUseCase,
        verifyOtpUseCaseBase: verifyOtpUseCase,
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

  static Future<AddPalViewModel> createAddPalViewModel() async {
    try {
      // Use the PAL dependency manager
      return await PalDependencyManager.createAddPalViewModel();
    } catch (e) {
      throw Exception('Failed to create AddPalViewModel: $e');
    }
  }

  static Future<AuthRepository> createAuthRepository() async {
    try {
      // Initialize TokenManager first
      final tokenManager = await TokenManager.getInstance();

      // Initialize MethodChannel-based AuthLocalDataSourceImpl
      final authLocalDataSource = AuthLocalDataSourceImpl();

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
