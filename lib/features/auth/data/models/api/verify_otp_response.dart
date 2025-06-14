class VerifyOtpResponse {
  final String response;
  final String? token;

  VerifyOtpResponse(this.response,this.token);

  @override
  String toString() => 'VerifyOtpResponse(response: $response, token: $token)';
}