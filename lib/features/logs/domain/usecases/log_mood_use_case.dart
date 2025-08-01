import 'package:dartz/dartz.dart';
import '../../../../core/network/error/failure.dart';
import '../repositories/logs_repository.dart';
import '../../data/models/mood_log_request.dart';
import '../../data/models/mood_log_response.dart';

abstract class LogMoodUseCaseBase {
  Future<Either<Failure, MoodLogResponse>> execute(String mood, String time);
}

class LogMoodUseCase implements LogMoodUseCaseBase {
  final LogsRepository repository;

  LogMoodUseCase({required this.repository});

  @override
  Future<Either<Failure, MoodLogResponse>> execute(
      String mood, String time) async {
    final request = MoodLogRequest(
      emotion: Emotion(
        state: mood.toLowerCase(),
        time: time,
      ),
    );

    return await repository.logMood(request);
  }
}
