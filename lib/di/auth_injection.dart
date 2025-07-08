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

class DependencyManager {
static Future<SignInViewModel> createSignInViewModel() async {
try {
// Initialize MethodChannel-based AuthLocalDataSourceImpl
final authLocalDataSource = AuthLocalDataSourceImpl();

// Initialize HttpApiService for remote data source
final apiService = HttpApiService();

// Initialize AuthRemoteDataSource with IApiService
final authRemoteDataSource = AuthRemoteDataSourceImpl(
authLocalDataSource: authLocalDataSource,
);

// Initialize AuthRepository
final authRepository = AuthRepositoryImpl(
authRemoteDataSource: authRemoteDataSource,
authLocalDataSource: authLocalDataSource,
);

// Initialize use cases
final requestOtpUseCase = RequestOtpUseCase(repository: authRepository);
final submitProfileUseCase = SubmitProfileUseCase(authRepository: authRepository);
final verifyOtpUseCase = VerifyOtpUseCase(
repository: authRepository,
authLocalDataSource: authLocalDataSource,
);
final getAccessTokenUseCase = GetAccessTokenUseCase(authRepository: authRepository);
final getAccessTokenExpiryUseCase = GetAccessTokenExpiryUseCase(authRepository: authRepository);
final refreshTokenUseCase = RefreshTokenUseCase(
authRemoteDataSource: authRemoteDataSource,
authLocalDataSource: authLocalDataSource,
);

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
}
