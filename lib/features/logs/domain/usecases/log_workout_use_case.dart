import 'package:dartz/dartz.dart';
import '../../../../core/network/error/failure.dart';
import '../repositories/logs_repository.dart';
import '../../data/models/workout_log_request.dart';
import '../../data/models/mood_log_response.dart';

abstract class LogWorkoutUseCaseBase {
  Future<Either<Failure, MoodLogResponse>> execute({
    required String type,
    required String rating,
    required String time,
    required String duration,
  });
}

class LogWorkoutUseCase implements LogWorkoutUseCaseBase {
  final LogsRepository repository;

  LogWorkoutUseCase({required this.repository});

  @override
  Future<Either<Failure, MoodLogResponse>> execute({
    required String type,
    required String rating,
    required String time,
    required String duration,
  }) async {
    // Transform UI data to API format
    final workoutType = _mapActivityToType(type);
    final intensity = _mapRatingToIntensity(rating);
    final timeOfDay = _deriveTimeOfDay(time);
    final formattedTime = _formatTime(time);
    final formattedDuration = _formatDuration(duration);

    final request = WorkoutLogRequest(
      workout: Workout(
        type: workoutType,
        startTime: formattedTime,
        timeOfDay: timeOfDay,
        duration: formattedDuration,
        intensity: intensity,
      ),
    );

    return await repository.logWorkout(request);
  }

  // Helper methods for data transformation
  String _mapActivityToType(String activity) {
    switch (activity.toLowerCase()) {
      case 'running':
      case 'cycling':
      case 'swimming':
        return 'Cardio';
      case 'weight training':
      case 'strength training':
      case 'bodyweight':
        return 'Strength';
      case 'yoga':
      case 'stretching':
      case 'pilates':
        return 'Flexibility';
      case 'dancing':
      case 'sports':
        return 'Activity';
      default:
        return 'General';
    }
  }

  String _mapRatingToIntensity(String rating) {
    switch (rating.toLowerCase()) {
      case 'excellent':
        return 'intense';
      case 'good':
        return 'moderate';
      case 'average':
        return 'moderate';
      case 'poor':
        return 'mild';
      default:
        return 'moderate';
    }
  }

  String _deriveTimeOfDay(String time) {
    final hour = int.tryParse(time.split(':')[0]) ?? 12;

    if (hour >= 5 && hour < 12) {
      return 'Morning';
    } else if (hour >= 12 && hour < 17) {
      return 'Afternoon';
    } else {
      return 'Evening';
    }
  }

  String _formatTime(String time) {
    // Convert "10:00 AM" to "10:00"
    return time.replaceAll(RegExp(r'\s*(AM|PM)'), '');
  }

  String _formatDuration(String duration) {
    // Convert "1 Hr" to "1.0", "30 Min" to "0.5"
    if (duration.contains('Hr')) {
      final hours = duration.replaceAll(RegExp(r'[^\d.]'), '');
      return hours.isEmpty ? '1.0' : hours;
    } else if (duration.contains('Min')) {
      final minutes =
          int.tryParse(duration.replaceAll(RegExp(r'[^\d]'), '')) ?? 30;
      return (minutes / 60.0).toString();
    }
    return '1.0';
  }
}
