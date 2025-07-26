class OtpRequestSuccess {
  final bool success;
  final String message;
  final bool isActive;
  final bool isDeleted;

  OtpRequestSuccess({
    required this.success,
    required this.message,
    required this.isActive,
    required this.isDeleted,
  });

  factory OtpRequestSuccess.fromJson(Map<String, dynamic> json) {
    return OtpRequestSuccess(
      success: json['success'] as bool,
      message: json['message'] as String,
      isActive: json['is_active'] as bool,
      isDeleted: json['is_deleted'] as bool,
    );
  }
}