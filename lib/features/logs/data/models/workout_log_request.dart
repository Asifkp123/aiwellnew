class WorkoutLogRequest {
  final Workout workout;

  WorkoutLogRequest({required this.workout});

  Map<String, dynamic> toJson() {
    return {
      'workout': workout.toJson(),
    };
  }
}

class Workout {
  final String type;
  final String startTime;
  final String timeOfDay;
  final String duration;
  final String intensity;

  Workout({
    required this.type,
    required this.startTime,
    required this.timeOfDay,
    required this.duration,
    required this.intensity,
  });

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'start_time': startTime,
      'time_of_day': timeOfDay,
      'Duration': duration,
      'Intensity': intensity,
    };
  }

  @override
  String toString() {
    return 'Workout(type: $type, startTime: $startTime, timeOfDay: $timeOfDay, duration: $duration, intensity: $intensity)';
  }
}
