class Patient {
  final String id;
  final String firstName;
  final String lastName;
  final DateTime dateOfBirth;
  final String gender;
  final String? primaryDiagnosis;
  final bool? canWalk;
  final bool? needsWalkingAid;
  final bool? isBedridden;
  final bool? hasDementia;
  final bool? isAgitated;
  final bool? isDepressed;
  final String? dominantEmotion;
  final String? sleepPattern;
  final String? sleepQuality;
  final String? painStatus;
  final DateTime createdAt;
  final DateTime updatedAt;

  Patient({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.dateOfBirth,
    required this.gender,
    this.primaryDiagnosis,
    this.canWalk,
    this.needsWalkingAid,
    this.isBedridden,
    this.hasDementia,
    this.isAgitated,
    this.isDepressed,
    this.dominantEmotion,
    this.sleepPattern,
    this.sleepQuality,
    this.painStatus,
    required this.createdAt,
    required this.updatedAt,
  });

  String get fullName => '$firstName $lastName';

  int get age {
    final now = DateTime.now();
    int age = now.year - dateOfBirth.year;
    if (now.month < dateOfBirth.month ||
        (now.month == dateOfBirth.month && now.day < dateOfBirth.day)) {
      age--;
    }
    return age;
  }

  bool get needsAttention {
    return hasDementia == true ||
        isAgitated == true ||
        isDepressed == true ||
        painStatus == 'severe' ||
        painStatus == 'very_severe' ||
        painStatus == 'worst_possible';
  }
}
