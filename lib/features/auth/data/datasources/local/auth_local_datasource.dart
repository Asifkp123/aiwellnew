import 'package:flutter/services.dart';
import '../../../../../core/constants/strings.dart';
import '../../../../../core/network/error/failure.dart';
import '../../../../../core/services/token_manager.dart';

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
  final TokenManager _tokenManager;

  AuthLocalDataSourceImpl(this._tokenManager);

  @override
  Future<void> saveTokens({
    required String accessToken,
    required int accessTokenExpiry,
    required String refreshToken,
    required int refreshTokenExpiry,
  }) async {
    await _tokenManager.saveTokens(
      accessToken: accessToken,
      accessTokenExpiry: accessTokenExpiry,
      refreshToken: refreshToken,
      refreshTokenExpiry: refreshTokenExpiry,
    );
  }

  @override
  Future<String?> getAccessToken() async => _tokenManager.getAccessToken();

  @override
  Future<int?> getAccessTokenExpiry() async =>
      _tokenManager.getAccessTokenExpiry();

  @override
  Future<String?> getRefreshToken() async => _tokenManager.getRefreshToken();

  @override
  Future<int?> getRefreshTokenExpiry() async =>
      _tokenManager.getRefreshTokenExpiry();

  @override
  Future<void> clearTokens() async => _tokenManager.clearTokens();

  @override
  Future<String?> getToken() async => getAccessToken();

  @override
  Future<void> saveApprovalStatus(bool approvalStatus) async =>
      _tokenManager.saveApprovalStatus(approvalStatus);

  @override
  Future<bool?> getApprovalStatus() async => _tokenManager.getApprovalStatus();
}
