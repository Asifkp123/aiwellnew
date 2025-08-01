import '../../../domain/entities/patient.dart';

class PatientResponse {
  final String id;
  final String firstName;
  final String lastName;
  final String dateOfBirth;
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
  final String createdAt;
  final String updatedAt;

  PatientResponse({
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

  factory PatientResponse.fromJson(Map<String, dynamic> json) {
    return PatientResponse(
      id: json['id']?.toString() ?? '',
      firstName: json['first_name']?.toString() ?? '',
      lastName: json['last_name']?.toString() ?? '',
      dateOfBirth: json['date_of_birth']?.toString() ?? '',
      gender: json['gender']?.toString() ?? '',
      primaryDiagnosis: json['primary_diagnosis']?.toString(),
      canWalk: json['can_walk'] as bool?,
      needsWalkingAid: json['needs_walking_aid'] as bool?,
      isBedridden: json['is_bedridden'] as bool?,
      hasDementia: json['has_dementia'] as bool?,
      isAgitated: json['is_agitated'] as bool?,
      isDepressed: json['is_depressed'] as bool?,
      dominantEmotion: json['dominant_emotion']?.toString(),
      sleepPattern: json['sleep_pattern']?.toString(),
      sleepQuality: json['sleep_quality']?.toString(),
      painStatus: json['pain_status']?.toString(),
      createdAt: json['created_at']?.toString() ?? '',
      updatedAt: json['updated_at']?.toString() ?? '',
    );
  }

  Patient toEntity() {
    return Patient(
      id: id,
      firstName: firstName,
      lastName: lastName,
      dateOfBirth: DateTime.tryParse(dateOfBirth) ?? DateTime.now(),
      gender: gender,
      primaryDiagnosis: primaryDiagnosis,
      canWalk: canWalk,
      needsWalkingAid: needsWalkingAid,
      isBedridden: isBedridden,
      hasDementia: hasDementia,
      isAgitated: isAgitated,
      isDepressed: isDepressed,
      dominantEmotion: dominantEmotion,
      sleepPattern: sleepPattern,
      sleepQuality: sleepQuality,
      painStatus: painStatus,
      createdAt: DateTime.tryParse(createdAt) ?? DateTime.now(),
      updatedAt: DateTime.tryParse(updatedAt) ?? DateTime.now(),
    );
  }
}
