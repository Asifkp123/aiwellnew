class VerifyOtpResponse {
  final String message;
  final bool isActive;
  final bool isDeleted;
  final bool approvalStatus;
  final String? accessToken;
  final int? accessTokenExpiry;
  final String? refreshToken;
  final int? refreshTokenExpiry;

  VerifyOtpResponse({
    required this.message,
    required this.isActive,
    required this.isDeleted,
    required this.approvalStatus,
    this.accessToken,
    this.accessTokenExpiry,
    this.refreshToken,
    this.refreshTokenExpiry,
  });

  /// Create from JSON only (no headers)
  factory VerifyOtpResponse.fromJson(Map<String, dynamic> json) {
    return VerifyOtpResponse(
      message: json['message'] as String? ?? '',
      isActive: json['is_active'] as bool? ?? false,
      isDeleted: json['is_deleted'] as bool? ?? false,
      approvalStatus: json['approval_status'] as bool? ?? false,
    );
  }

  /// Create from JSON and headers (for tokens)
  factory VerifyOtpResponse.fromJsonAndHeaders(
      Map<String, dynamic> json, Map<String, String> headers) {
    return VerifyOtpResponse(
      message: json['message'] as String? ?? '',
      isActive: json['is_active'] as bool? ?? false,
      isDeleted: json['is_deleted'] as bool? ?? false,
      approvalStatus: json['approval_status'] as bool? ?? false,
      accessToken: headers['authorization']?.replaceAll('Bearer ', ''),
      accessTokenExpiry: headers['x-token-expiry'] != null
          ? int.tryParse(headers['x-token-expiry']!)
          : null,
      refreshToken: headers['x-refresh-token'],
      refreshTokenExpiry: headers['x-refresh-expiry'] != null
          ? int.tryParse(headers['x-refresh-expiry']!)
          : null,
    );
  }

  /// Convert to JSON (for encoding, if needed)
  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'is_active': isActive,
      'is_deleted': isDeleted,
      'approval_status': approvalStatus,
      // Tokens are not included in the body JSON, only in headers
    };
  }

  @override
  String toString() {
    return 'VerifyOtpResponse(message: $message, isActive: $isActive, '
        'isDeleted: $isDeleted, approvalStatus: $approvalStatus, '
        'accessToken: $accessToken, accessTokenExpiry: $accessTokenExpiry, '
        'refreshToken: $refreshToken, refreshTokenExpiry: $refreshTokenExpiry)';
  }
}

/// VerifyOtpResponse is used to handle the response from the OTP verification API call.
// {
// "message": "User verified successfully.",
// "is_active": true,
// "is_deleted": false,
// "approval_status": true
// }
