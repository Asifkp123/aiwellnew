class SleepLogRequest {
  final Sleep sleep;

  SleepLogRequest({required this.sleep});

  Map<String, dynamic> toJson() {
    return {
      'sleep': sleep.toJson(),
    };
  }
}

class Sleep {
  final String sleepStart;
  final String timeOfDay;
  final String sleepHours;
  final String sleepQuality;

  Sleep({
    required this.sleepStart,
    required this.timeOfDay,
    required this.sleepHours,
    required this.sleepQuality,
  });

  Map<String, dynamic> toJson() {
    return {
      'sleep_start': sleepStart,
      'time_of_day': timeOfDay,
      'sleep_hours': sleepHours,
      'sleep_quality': sleepQuality,
    };
  }

  @override
  String toString() {
    return 'Sleep(sleepStart: $sleepStart, timeOfDay: $timeOfDay, sleepHours: $sleepHours, sleepQuality: $sleepQuality)';
  }
}
