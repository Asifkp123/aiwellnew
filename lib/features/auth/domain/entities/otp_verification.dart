import '../../data/models/api/verify_otp_response.dart';

class OtpVerification {
  final String identifier;
  final String message;
  final String otp;
  final bool isApproved;
  final String? accessToken;
  final String? refreshToken;
  final int? accessTokenExpiry;
  final int? refreshTokenExpiry;

  OtpVerification({
    required this.message,
    required this.identifier,
    required this.otp,
    required this.isApproved,
    this.accessToken,
    this.refreshToken,
    this.accessTokenExpiry,
    this.refreshTokenExpiry,
  });

  factory OtpVerification.fromResponse(VerifyOtpResponse response) {
    return OtpVerification(
      message: response.message,
      identifier: '', // Set from request
      otp: '', // Set from request
      isApproved: response.approvalStatus,
      accessToken: response.accessToken,
      refreshToken: response.refreshToken,
      accessTokenExpiry: response.accessTokenExpiry,
      refreshTokenExpiry: response.refreshTokenExpiry,
    );
  }
}
