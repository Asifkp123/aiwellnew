import '../../../core/network/http_api_services.dart';
import '../data/datasources/remote/logs_remote_datasource.dart';
import '../data/repositories/logs_repository.dart';
import '../domain/repositories/logs_repository.dart';
import '../domain/usecases/log_mood_use_case.dart';
import '../presentation/view_models/logs_view_model.dart';

class LogsDependencyManager {
  static Future<LogsViewModel> createLogsViewModel() async {
    // Create API service (reuse existing one)
    final apiService = HttpApiService();

    // Create data source
    final remoteDataSource = LogsRemoteDataSourceImpl(apiService: apiService);

    // Create repository
    final LogsRepository repository =
        LogsRepositoryImpl(remoteDataSource: remoteDataSource);

    // Create use case
    final logMoodUseCase = LogMoodUseCase(repository: repository);

    // Create and return view model
    return LogsViewModel(logMoodUseCase: logMoodUseCase);
  }
}
