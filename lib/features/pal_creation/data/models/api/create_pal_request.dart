class CreatePalRequest {
  final String firstName;
  final String lastName;
  final String dob;
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

  CreatePalRequest({
    required this.firstName,
    required this.lastName,
    required this.dob,
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
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'first_name': firstName,
      'last_name': lastName,
      'dob': dob,
      'gender': gender,
    };
    if (primaryDiagnosis != null) data['primary_diagnosis'] = primaryDiagnosis;
    if (canWalk != null) data['can_walk'] = canWalk;
    if (needsWalkingAid != null) data['needs_walking_aid'] = needsWalkingAid;
    if (isBedridden != null) data['is_bedridden'] = isBedridden;
    if (hasDementia != null) data['has_dementia'] = hasDementia;
    if (isAgitated != null) data['is_agitated'] = isAgitated;
    if (isDepressed != null) data['is_depressed'] = isDepressed;
    if (dominantEmotion != null) data['dominant_emotion'] = dominantEmotion;
    if (sleepPattern != null) data['sleep_pattern'] = sleepPattern;
    if (sleepQuality != null) data['sleep_quality'] = sleepQuality;
    if (painStatus != null) data['pain_status'] = painStatus;
    return data;
  }

  @override
  String toString() {
    return 'CreatePalRequest(name: $firstName $lastName, dob: $dob, gender: $gender, primaryDiagnosis: $primaryDiagnosis, canWalk: $canWalk, needsWalkingAid: $needsWalkingAid, isBedridden: $isBedridden, hasDementia: $hasDementia, isAgitated: $isAgitated, isDepressed: $isDepressed, dominantEmotion: $dominantEmotion, sleepPattern: $sleepPattern, sleepQuality: $sleepQuality, painStatus: $painStatus)';
  }
}
