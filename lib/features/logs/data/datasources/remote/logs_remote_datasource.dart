import '../../../../../core/network/api_service.dart';
import '../../../../../core/network/model/api_response.dart';
import '../../models/mood_log_request.dart';
import '../../models/workout_log_request.dart';
import '../../models/sleep_log_request.dart';

abstract class LogsRemoteDataSource {
  Future<ApiResponse<Map<String, dynamic>>> logMood(MoodLogRequest request);
  Future<ApiResponse<Map<String, dynamic>>> logWorkout(
      WorkoutLogRequest request);
  Future<ApiResponse<Map<String, dynamic>>> logSleep(SleepLogRequest request);
}

class LogsRemoteDataSourceImpl implements LogsRemoteDataSource {
  final IApiService apiService;
  static const String _logsEndpoint =
      'http://api-test.aiwel.org/api/v1/profile/logs';

  LogsRemoteDataSourceImpl({required this.apiService});

  @override
  Future<ApiResponse<Map<String, dynamic>>> logMood(
      MoodLogRequest request) async {
    print('🚀 DataSource: Logging mood: ${request.toJson()}');

    return await apiService.post<Map<String, dynamic>>(
      _logsEndpoint,
      body: request.toJson(),
    );
  }

  @override
  Future<ApiResponse<Map<String, dynamic>>> logWorkout(
      WorkoutLogRequest request) async {
    print('🚀 DataSource: Logging workout: ${request.toJson()}');

    return await apiService.post<Map<String, dynamic>>(
      _logsEndpoint,
      body: request.toJson(),
    );
  }

  @override
  Future<ApiResponse<Map<String, dynamic>>> logSleep(
      SleepLogRequest request) async {
    print('🚀 DataSource: Logging sleep: ${request.toJson()}');

    return await apiService.post<Map<String, dynamic>>(
      _logsEndpoint,
      body: request.toJson(),
    );
  }
}
