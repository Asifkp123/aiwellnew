import 'dart:convert';

class CreatePalResponse {
  final bool success;
  final String message;
  final String? patientId;
  final String? guardianId;

  CreatePalResponse({
    required this.success,
    required this.message,
    this.patientId,
    this.guardianId,
  });

  factory CreatePalResponse.fromJson(Map<String, dynamic> json) {
    return CreatePalResponse(
      success: json['success'] as bool,
      message: json['message'] as String,
      patientId: json['patient_id'] as String?,
      guardianId: json['guardian_id'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'patient_id': patientId,
      'guardian_id': guardianId,
    };
  }

  @override
  String toString() {
    return 'CreatePalResponse(success: $success, message: $message, patientId: $patientId, guardianId: $guardianId)';
  }
}
