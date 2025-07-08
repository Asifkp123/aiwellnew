class Strings {
  static const String emptyEmailMessage = 'Please enter an email or phone number.';
  static const String invalidEmailMessage = 'Please enter a valid email or phone number.';
  static const String emptyOtpMessage = 'Please enter the OTP.';
  static const String invalidOtpMessage = 'OTP must be 6 digits.';
  static const String failedOtpVerificationMessage = 'OTP verification failed. Please try again.';
  static const String tokenNotFoundMessage = 'Authentication token not found.';
  static const String invalidProfileMessage = 'Please complete all required fields and select at least one option (mood, sleep, or workout).';
  static const String invalidDateFormatMessage = 'Invalid date format. Please use dd-MM-yyyy.';
  static const String noTokenAvailable = 'Session not found. Please sign in again.';
  static const String noTokenAfterRefresh = 'Failed to refresh session. Please sign in again.';
  static const String sessionExpired = 'Your session has expired. Please sign in again.';
  static const String tokenRetrievalError = 'Failed to retrieve authentication token.';
  static const String storageError = 'Failed to access secure storage. Please try again.';
}