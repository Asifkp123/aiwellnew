import 'package:dartz/dartz.dart';
import '../../../../core/network/error/failure.dart';
import '../../domain/repositories/logs_repository.dart';
import '../datasources/remote/logs_remote_datasource.dart';
import '../models/mood_log_request.dart';
import '../models/mood_log_response.dart';

class LogsRepositoryImpl implements LogsRepository {
  final LogsRemoteDataSource remoteDataSource;

  LogsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, MoodLogResponse>> logMood(
      MoodLogRequest request) async {
    try {
      print('📦 Repository: Processing mood log request');

      // Call data source (returns raw ApiResponse)
      final apiResponse = await remoteDataSource.logMood(request);

      // Extract and convert to domain model
      if (apiResponse.isSuccess && apiResponse.data != null) {
        final moodResponse = MoodLogResponse.fromJson(apiResponse.data!);
        print('✅ Repository: Successfully converted response to model');
        return Right(moodResponse);
      } else {
        final errorMessage = apiResponse.errorMessage ?? 'Failed to log mood';
        print('❌ Repository: API error - $errorMessage');
        return Left(Failure(errorMessage));
      }
    } catch (e) {
      print('❌ Repository: Exception - $e');
      return Left(Failure('Repository error: $e'));
    }
  }
}
