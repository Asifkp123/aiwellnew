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
  if (!getIt.isRegistered<SharedPreferences>()) {
    getIt.registerSingleton<SharedPreferences>(sharedPreferences);
  }

  // Register AuthLocalDataSourceImpl
  if (!getIt.isRegistered<AuthLocalDataSourceImpl>()) {
    getIt.registerSingleton<AuthLocalDataSourceImpl>(
      AuthLocalDataSourceImpl(getIt<SharedPreferences>()),
    );
  }

  // Register IApiService
  if (!getIt.isRegistered<IApiService>()) {
    getIt.registerLazySingleton<IApiService>(() => HttpApiService());
  }

  // Register data sources
  if (!getIt.isRegistered<AuthRemoteDataSource>()) {
    getIt.registerLazySingleton<AuthRemoteDataSource>(
          () => AuthRemoteDataSource(apiService: getIt<IApiService>()),
    );
  }

  // Register repository
  if (!getIt.isRegistered<AuthRepository>()) {
    getIt.registerLazySingleton<AuthRepository>(
          () => AuthRepositoryImpl(
        authRemoteDataSource: getIt<AuthRemoteDataSource>(),
        authLocalDataSource: getIt<AuthLocalDataSourceImpl>(),
      ),
    );
  }

  // Register use cases
  if (!getIt.isRegistered<RequestOtpUseCase>()) {
    getIt.registerLazySingleton<RequestOtpUseCase>(
          () => RequestOtpUseCase(repository: getIt<AuthRepository>()),
    );
  }
  if (!getIt.isRegistered<VerifyOtpUseCase>()) {
    getIt.registerLazySingleton<VerifyOtpUseCase>(
          () => VerifyOtpUseCase(
        repository: getIt<AuthRepository>(),
        authLocalDataSource: getIt<AuthLocalDataSourceImpl>(),
      ),
    );
  }

  // Register ViewModel as singleton
  if (!getIt.isRegistered<SignInViewModelBase>()) {
    getIt.registerSingleton<SignInViewModelBase>(
      SignInViewModel(
        requestOtpUseCase: getIt<RequestOtpUseCase>(),
        verifyOtpUseCaseBase: getIt<VerifyOtpUseCase>(),
        authLocalDataSourceImpl: getIt<AuthLocalDataSourceImpl>(),
      ),
    );
  }
}