import 'package:aiwel/core/network/http_api_services.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/network/api_service.dart';
import '../features/auth/data/datasources/local/auth_local_datasource.dart';
import '../features/auth/data/datasources/remote/auth_remote_datasource.dart';
import '../features/auth/data/repositories/auth_repository.dart';
import '../features/auth/domain/usecases/request_otp_use_case.dart';
import '../features/auth/domain/usecases/verify_otp_use_case.dart';
import '../features/auth/presentation/view_models/sign_in_viewModel.dart';

Future<void> setupAuthDependencies() async {
  GetIt getIt = GetIt.instance;

  final sharedPreferences = await SharedPreferences.getInstance();

  // Register SharedPreferences
  getIt.registerSingleton<SharedPreferences>(sharedPreferences);

  // Register AuthLocalDataSourceImpl as the concrete type
  getIt.registerSingleton<AuthLocalDataSourceImpl>(
    AuthLocalDataSourceImpl(getIt<SharedPreferences>()),
  );

  // Register IApiService
  getIt.registerLazySingleton<IApiService>(() => HttpApiService());

  // Register data sources
  getIt.registerLazySingleton<AuthRemoteDataSource>(
        () => AuthRemoteDataSource(apiService: getIt<IApiService>()),
  );

  // Register repository
  getIt.registerLazySingleton<AuthRepository>(
        () => AuthRepositoryImpl(
      authRemoteDataSource: getIt<AuthRemoteDataSource>(),
      authLocalDataSource: getIt<AuthLocalDataSourceImpl>(), // Use concrete type here
    ),
  );

  // Register use cases
  getIt.registerLazySingleton<RequestOtpUseCase>(
        () => RequestOtpUseCase(repository: getIt<AuthRepository>()),
  );
  getIt.registerLazySingleton<VerifyOtpUseCase>(
        () => VerifyOtpUseCase(repository: getIt<AuthRepository>(),
        authLocalDataSource: getIt<AuthLocalDataSourceImpl>()
        ),
  );

  // Register ViewModel
  getIt.registerFactory<SignInViewModelBase>(
        () => SignInViewModel(

      requestOtpUseCase: getIt<RequestOtpUseCase>(),
      verifyOtpUseCaseBase: getIt<VerifyOtpUseCase>(),
      authLocalDataSourceImpl: getIt<AuthLocalDataSourceImpl>(), // Fix parameter name and type
    ),
  );
}