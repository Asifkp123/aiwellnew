import '../../../core/network/http_api_services.dart';
import '../../../core/services/token_manager.dart';
import '../data/datasources/remote/pal_remote_datasource.dart';
import '../data/repositories/pal_repository.dart';
import '../domain/repositories/pal_repository.dart';
import '../domain/usecases/create_pal_use_case.dart';
import '../presentation/view_models/add_pal_view_model.dart';
import '../../auth/data/datasources/local/auth_local_datasource.dart';
import '../../auth/data/datasources/remote/auth_remote_datasource.dart';
import '../../auth/data/repositories/auth_repository.dart';
import '../../auth/domain/usecases/get_access_token_use_case.dart';
import '../../auth/domain/usecases/refresh_token_use_case.dart';

class PalDependencyManager {
  static Future<AddPalViewModel> createAddPalViewModel() async {
    try {
      // Initialize TokenManager first
      final tokenManager = await TokenManager.getInstance();

      // Initialize AuthLocalDataSourceImpl
      final authLocalDataSource = AuthLocalDataSourceImpl(tokenManager);

      // Initialize AuthRemoteDataSource
      final authRemoteDataSource = AuthRemoteDataSourceImpl(
        authLocalDataSource: authLocalDataSource,
        apiService: HttpApiService(
          tokenManager: tokenManager,
        ),
      );

      // Initialize AuthRepository
      final authRepository = AuthRepositoryImpl(
        authRemoteDataSource: authRemoteDataSource,
        authLocalDataSource: authLocalDataSource,
        tokenManager: tokenManager,
      );

      // Initialize Auth Use Cases
      final getAccessTokenUseCase = GetAccessTokenUseCase(
        authRepository: authRepository,
      );

      final refreshTokenUseCase = RefreshTokenUseCase(
        authRemoteDataSource: authRemoteDataSource,
        tokenManager: tokenManager,
      );

      // Initialize HttpApiService for PAL operations
      final apiService = HttpApiService(
        tokenManager: tokenManager,
      );

      // Initialize PalRemoteDataSource
      final palRemoteDataSource = PalRemoteDataSourceImpl(
        apiService: apiService,
      );

      // Initialize PalRepository
      final palRepository = PalRepositoryImpl(
        palRemoteDataSource: palRemoteDataSource,
      );

      // Initialize CreatePalUseCase
      final createPalUseCase = CreatePalUseCase(
        palRepository: palRepository,
      );

      // Return AddPalViewModel with all dependencies
      return AddPalViewModel(
        tokenManager: tokenManager,
        createPalUseCase: createPalUseCase,
        getAccessTokenUseCase: getAccessTokenUseCase,
        refreshTokenUseCase: refreshTokenUseCase,
      );
    } catch (e) {
      print('Error creating AddPalViewModel: $e');
      rethrow;
    }
  }
}
