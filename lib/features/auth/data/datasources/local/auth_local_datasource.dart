import 'package:shared_preferences/shared_preferences.dart';




abstract class AuthLocalDataSourceBase {
  Future<void> saveToken(String token);
  Future<String?> getToken();
  Future<void> clearToken();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSourceBase {
  static const _tokenKey = 'auth_token';
  final SharedPreferences _prefs; // Store the injected instance

  // Add constructor to accept SharedPreferences
  AuthLocalDataSourceImpl(this._prefs);

  @override
  Future<void> saveToken(String token) async {
    try {
      await _prefs.setString(_tokenKey, token);
    } catch (e) {
      throw Exception('Failed to save token: $e');
    }
  }

  @override
  Future<String?> getToken() async {
    try {
      return _prefs.getString(_tokenKey);
    } catch (e) {
      throw Exception('Failed to retrieve token: $e');
    }
  }

  @override
  Future<void> clearToken() async {
    try {
      await _prefs.remove(_tokenKey);
    } catch (e) {
      throw Exception('Failed to clear token: $e');
    }
  }
}