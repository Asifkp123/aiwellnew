import 'package:shared_preferences/shared_preferences.dart';
import 'package:dartz/dartz.dart';
import '../network/error/failure.dart';

class TokenManager {
  static const String _accessTokenKey = 'access_token';
  static const String _accessTokenExpiryKey = 'access_token_expiry';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _refreshTokenExpiryKey = 'refresh_token_expiry';
  static const String _isLoggedInKey = 'is_logged_in';
  static const String _approvalStatusKey = 'approval_status';

  static TokenManager? _instance;
  static bool _initialized = false;

  static TokenManager get instance {
    if (_instance == null) {
      _instance = TokenManager._();
    }
    return _instance!;
  }

  static Future<TokenManager> getInstance() async {
    if (_instance == null) {
      _instance = TokenManager._();
      await _instance!._initialize();
    }
    return _instance!;
  }

  TokenManager._();

  Future<void> _initialize() async {
    if (!_initialized) {
      await SharedPreferences.getInstance(); // Initialize SharedPreferences
      _initialized = true;
    }
  }

  // Save tokens
  Future<void> saveTokens({
    required String accessToken,
    required int accessTokenExpiry,
    required String refreshToken,
    required int refreshTokenExpiry,
  }) async {
    await _initialize();
    final prefs = await SharedPreferences.getInstance();
    print("access token saved");
    await prefs.setString(_accessTokenKey, accessToken);
    print(prefs.getString(_accessTokenKey));
    print("prefs.getString(_accessTokenKey)");
    await prefs.setInt(_accessTokenExpiryKey, accessTokenExpiry);
    await prefs.setString(_refreshTokenKey, refreshToken);
    await prefs.setInt(_refreshTokenExpiryKey, refreshTokenExpiry);
    await prefs.setBool(_isLoggedInKey, true);

    print("access token saved1111");
    print("access token saved1111");
  }

  // Save approval status
  Future<void> saveApprovalStatus(bool approvalStatus) async {
    await _initialize();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_approvalStatusKey, approvalStatus);
  }

  // Get approval status
  Future<bool?> getApprovalStatus() async {
    await _initialize();
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_approvalStatusKey);
  }

  // Get access token
  Future<String?> getAccessToken() async {
    await _initialize();
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_accessTokenKey);
    print(
        "🔍 TokenManager.getAccessToken: ${token != null ? 'Token found' : 'No token'}");

    print(
        "🔍 TokenManager.getAccessToken second timeeee33333333333: ${token != null ? 'Token found' : 'No token'}");

    // Additional debug prints
    print("🔍 TokenManager.getAccessToken - Token value: ${token ?? 'NULL'}");
    print(
        "🔍 TokenManager.getAccessToken - Token length: ${token?.length ?? 0}");
    print(
        "🔍 TokenManager.getAccessToken - Token is empty: ${token?.isEmpty ?? true}");

    return token;
  }

  // Get access token expiry
  Future<int?> getAccessTokenExpiry() async {
    await _initialize();
    final prefs = await SharedPreferences.getInstance();
    final expiry = prefs.getInt(_accessTokenExpiryKey);
    print(
        "🔍 TokenManager.getAccessTokenExpiry: ${expiry != null ? 'Expiry: $expiry' : 'No expiry'}");

    // Additional debug prints
    print("🔍 TokenManager.getAccessTokenExpiry - Raw expiry value: $expiry");
    print(
        "🔍 TokenManager.getAccessTokenExpiry - Current time: ${DateTime.now().millisecondsSinceEpoch ~/ 1000}");
    print(
        "🔍 TokenManager.getAccessTokenExpiry - Is expiry null: ${expiry == null}");
    print("🔍 TokenManager.getAccessTokenExpiry - Is expiry 0: ${expiry == 0}");

    return expiry;
  }

  // Get refresh token
  Future<String?> getRefreshToken() async {
    await _initialize();
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_refreshTokenKey);
    print(
        "🔍 TokenManager.getRefreshToken: ${token != null ? 'Token found' : 'No token'}");
    return token;
  }

  // Get refresh token expiry
  Future<int?> getRefreshTokenExpiry() async {
    await _initialize();
    final prefs = await SharedPreferences.getInstance();
    final expiry = prefs.getInt(_refreshTokenExpiryKey);
    print(
        "🔍 TokenManager.getRefreshTokenExpiry: ${expiry != null ? 'Expiry: $expiry' : 'No expiry'}");
    return expiry;
  }

  // Check if user is logged in
  Future<bool> isLoggedIn() async {
    await _initialize();
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool(_isLoggedInKey) ?? false;
    print("🔍 TokenManager.isLoggedIn: $isLoggedIn");
    return isLoggedIn;
  }

  // Check if access token is valid
  Future<bool> isAccessTokenValid() async {
    await _initialize();
    final token = await getAccessToken();
    final expiry = await getAccessTokenExpiry();

    if (token == null || expiry == null) {
      print("❌ TokenManager.isAccessTokenValid: Token or expiry is null");
      return false;
    }

    final currentTime = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    final isValid = currentTime < expiry - 60; // 1 minute buffer
    print(
        "🔍 TokenManager.isAccessTokenValid: $isValid (current: $currentTime, expiry: $expiry)");
    return isValid;
  }

  // Check if refresh token is valid
  Future<bool> isRefreshTokenValid() async {
    await _initialize();
    final token = await getRefreshToken();
    final expiry = await getRefreshTokenExpiry();

    if (token == null || expiry == null) {
      print("❌ TokenManager.isRefreshTokenValid: Token or expiry is null");
      return false;
    }

    final currentTime = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    final isValid = currentTime < expiry;
    print(
        "🔍 TokenManager.isRefreshTokenValid: $isValid (current: $currentTime, expiry: $expiry)");
    return isValid;
  }

  // Clear all tokens (logout)
  Future<void> clearTokens() async {
    await _initialize();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_accessTokenKey);
    await prefs.remove(_accessTokenExpiryKey);
    await prefs.remove(_refreshTokenKey);
    await prefs.remove(_refreshTokenExpiryKey);
    await prefs.setBool(_isLoggedInKey, false);
  }

  // Get valid access token (with refresh if needed)
  Future<Either<Failure, String>> getValidAccessToken() async {
    await _initialize();
    if (await isAccessTokenValid()) {
      final token = await getAccessToken();
      return Right(token!);
    }

    if (await isRefreshTokenValid()) {
      // Token needs refresh - this should be handled by the HTTP service
      return Left(Failure('Token expired, refresh needed'));
    }

    return Left(Failure('No valid tokens available'));
  }
}
