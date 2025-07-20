import 'package:flutter/services.dart';
import '../../../../../core/constants/strings.dart';
import '../../../../../core/network/error/failure.dart';

abstract class AuthLocalDataSourceBase {
  Future<void> saveTokens({
    required String accessToken,
    required int accessTokenExpiry,
    required String refreshToken,
    required int refreshTokenExpiry,
  });
  Future<String?> getAccessToken();
  Future<int?> getAccessTokenExpiry();
  Future<String?> getRefreshToken();
  Future<int?> getRefreshTokenExpiry();
  Future<void> clearTokens();
  Future<String?> getToken();
  Future<void> saveApprovalStatus(bool approvalStatus);
  Future<bool?> getApprovalStatus();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSourceBase {
  static const MethodChannel _channel =
      MethodChannel('com.qurig.aiwel/secure_storage');

  static const String _accessTokenKey = 'access_token';
  static const String _accessTokenExpiryKey = 'access_token_expiry';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _refreshTokenExpiryKey = 'refresh_token_expiry';

  @override
  Future<void> saveTokens({
    required String accessToken,
    required int accessTokenExpiry,
    required String refreshToken,
    required int refreshTokenExpiry,
  }) async {
    try {
      await _channel.invokeMethod('saveTokens', {
        _accessTokenKey: accessToken,
        _accessTokenExpiryKey: accessTokenExpiry.toString(),
        _refreshTokenKey: refreshToken,
        _refreshTokenExpiryKey: refreshTokenExpiry.toString(),
      });
    } on PlatformException catch (e) {
      throw Failure('${Strings.storageError}: ${e.message}');
    } catch (e) {
      throw Failure(Strings.storageError);
    }
  }

  @override
  Future<String?> getAccessToken() async {
    try {
      return await _channel.invokeMethod('getToken', {'key': _accessTokenKey});
    } catch (e) {
      throw Failure('Failed to retrieve access token: $e');
    }
  }

  @override
  Future<int?> getAccessTokenExpiry() async {
    try {
      final expiry = await _channel
          .invokeMethod('getToken', {'key': _accessTokenExpiryKey});
      return expiry != null ? int.tryParse(expiry) : null;
    } catch (e) {
      throw Failure('Failed to retrieve access token expiry: $e');
    }
  }

  @override
  Future<String?> getRefreshToken() async {
    try {
      return await _channel.invokeMethod('getToken', {'key': _refreshTokenKey});
    } catch (e) {
      throw Failure('Failed to retrieve refresh token: $e');
    }
  }

  @override
  Future<int?> getRefreshTokenExpiry() async {
    try {
      final expiry = await _channel
          .invokeMethod('getToken', {'key': _refreshTokenExpiryKey});
      return expiry != null ? int.tryParse(expiry) : null;
    } catch (e) {
      throw Failure('Failed to retrieve refresh token expiry: $e');
    }
  }

  @override
  Future<void> clearTokens() async {
    try {
      await _channel.invokeMethod('clearTokens');
    } catch (e) {
      throw Failure('Failed to clear tokens: $e');
    }
  }

  @override
  Future<String?> getToken() async => getAccessToken();

  @override
  Future<void> saveApprovalStatus(bool approvalStatus) async {
    try {
      await _channel.invokeMethod(
          'saveApprovalStatus', {'approval_status': approvalStatus.toString()});
    } catch (e) {
      throw Failure('Failed to save approval status: $e');
    }
  }

  @override
  Future<bool?> getApprovalStatus() async {
    try {
      final status = await _channel.invokeMethod('getApprovalStatus');
      if (status == null) return null;
      if (status is bool) return status;
      if (status is String) return status.toLowerCase() == 'true';
      return null;
    } catch (e) {
      throw Failure('Failed to retrieve approval status: $e');
    }
  }
}
