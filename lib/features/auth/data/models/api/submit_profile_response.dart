import 'dart:convert';

class SubmitProfileResponse {
  final bool success;
  final String message;
  final String userId;
  final String role;
  final bool approvalStatus;
  final List<String> updatedFields;

  SubmitProfileResponse({
    required this.success,
    required this.message,
    required this.userId,
    required this.role,
    required this.approvalStatus,
    required this.updatedFields,
  });

  factory SubmitProfileResponse.fromJson(Map<String, dynamic> json) {
    return SubmitProfileResponse(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      userId: json['user_id'] as String? ?? '',
      role: json['role'] as String? ?? '',
      approvalStatus: json['approval_status'] as bool? ?? false,
      updatedFields: (json['updated_fields'] as List<dynamic>?)
              ?.map((field) => field.toString())
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'user_id': userId,
      'role': role,
      'approval_status': approvalStatus,
      'updated_fields': updatedFields,
    };
  }

  @override
  String toString() {
    return 'SubmitProfileResponse(success: $success, message: $message, userId: $userId, role: $role, approvalStatus: $approvalStatus, updatedFields: $updatedFields)';
  }
}
