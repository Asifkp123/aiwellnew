import 'package:dartz/dartz.dart';
import '../../../../core/network/error/failure.dart';
import '../../data/models/mood_log_request.dart';
import '../../data/models/mood_log_response.dart';

abstract class LogsRepository {
  Future<Either<Failure, MoodLogResponse>> logMood(MoodLogRequest request);
  // Future methods for sleep and workout logging can be added here
}
