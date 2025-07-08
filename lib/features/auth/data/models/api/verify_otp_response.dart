class VerifyOtpResponse {
  final String message;
  final String token;

  VerifyOtpResponse(this.message, this.token);
}

class TokenResponse extends VerifyOtpResponse {
  final String accessToken;
  final int accessTokenExpiry;
  final String refreshToken;
  final int refreshTokenExpiry;

  TokenResponse({
    required this.accessToken,
    required this.accessTokenExpiry,
    required this.refreshToken,
    required this.refreshTokenExpiry,
  }) : super('Success', accessToken);
}