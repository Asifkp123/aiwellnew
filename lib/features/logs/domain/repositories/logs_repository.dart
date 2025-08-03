import 'package:dartz/dartz.dart';
import '../../../../core/network/error/failure.dart';
import '../../data/models/mood_log_request.dart';
import '../../data/models/mood_log_response.dart';
import '../../data/models/workout_log_request.dart';
import '../../data/models/sleep_log_request.dart';

abstract class LogsRepository {
  Future<Either<Failure, MoodLogResponse>> logMood(MoodLogRequest request);
  Future<Either<Failure, MoodLogResponse>> logWorkout(
      WorkoutLogRequest request);
  Future<Either<Failure, MoodLogResponse>> logSleep(SleepLogRequest request);
}
