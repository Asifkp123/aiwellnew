import 'package:dartz/dartz.dart';
import '../../../../core/network/error/failure.dart';
import '../repositories/logs_repository.dart';
import '../../data/models/sleep_log_request.dart';
import '../../data/models/mood_log_response.dart';

abstract class LogSleepUseCaseBase {
  Future<Either<Failure, MoodLogResponse>> execute({
    required String quality,
    required String startTime,
    required String duration,
  });
}

class LogSleepUseCase implements LogSleepUseCaseBase {
  final LogsRepository repository;

  LogSleepUseCase({required this.repository});

  @override
  Future<Either<Failure, MoodLogResponse>> execute({
    required String quality,
    required String startTime,
    required String duration,
  }) async {
    // Transform UI data to API format
    final sleepQuality = _mapQualityToApiFormat(quality);
    final timeOfDay = _deriveTimeOfDay(startTime);
    final formattedTime = _formatTime(startTime);
    final formattedDuration = _formatDuration(duration);

    final request = SleepLogRequest(
      sleep: Sleep(
        sleepStart: formattedTime,
        timeOfDay: timeOfDay,
        sleepHours: formattedDuration,
        sleepQuality: sleepQuality,
      ),
    );

    return await repository.logSleep(request);
  }

  // Helper methods for data transformation
  String _mapQualityToApiFormat(String quality) {
    switch (quality.toLowerCase()) {
      case 'excellent':
        return 'excellent';
      case 'good':
        return 'good';
      case 'average':
        return 'average';
      case 'poor':
        return 'poor';
      case 'terrible':
        return 'poor'; // Map terrible to poor for API
      default:
        return 'good';
    }
  }

  String _deriveTimeOfDay(String time) {
    final hour = int.tryParse(time.split(':')[0]) ?? 22;

    // Sleep times are typically evening/night
    if (hour >= 20 || hour <= 4) {
      return 'Night';
    } else if (hour >= 5 && hour < 12) {
      return 'Morning';
    } else if (hour >= 12 && hour < 17) {
      return 'Afternoon';
    } else {
      return 'Evening';
    }
  }

  String _formatTime(String time) {
    // Convert "10:00 PM" to "22:00"
    if (time.contains('PM')) {
      final hour = int.tryParse(time.split(':')[0]) ?? 10;
      final minute = time.split(':')[1].replaceAll(' PM', '');
      final adjustedHour = hour == 12 ? 12 : hour + 12;
      return '$adjustedHour:$minute';
    } else if (time.contains('AM')) {
      final hour = int.tryParse(time.split(':')[0]) ?? 10;
      final minute = time.split(':')[1].replaceAll(' AM', '');
      final adjustedHour = hour == 12 ? 0 : hour;
      return '${adjustedHour.toString().padLeft(2, '0')}:$minute';
    } else {
      // Already in 24-hour format
      return time;
    }
  }

  String _formatDuration(String duration) {
    // Convert "8 Hrs" to "8.0", "30 Min" to "0.5"
    if (duration.contains('Hr')) {
      final hours = duration.replaceAll(RegExp(r'[^\d.]'), '');
      return hours.isEmpty ? '8.0' : hours;
    } else if (duration.contains('Min')) {
      final minutes =
          int.tryParse(duration.replaceAll(RegExp(r'[^\d]'), '')) ?? 30;
      return (minutes / 60.0).toString();
    }
    return '8.0';
  }
}
