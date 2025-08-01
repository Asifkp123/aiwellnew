class MoodLogRequest {
  final Emotion emotion;

  MoodLogRequest({required this.emotion});

  Map<String, dynamic> toJson() {
    return {
      'emotion': emotion.toJson(),
    };
  }
}

class Emotion {
  final String state;
  final String time;

  Emotion({
    required this.state,
    required this.time,
  });

  Map<String, dynamic> toJson() {
    return {
      'state': state,
      'time': time,
    };
  }
}
