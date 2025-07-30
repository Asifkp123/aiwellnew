import 'dart:convert';
import 'package:aiwel/features/auth/data/repositories/auth_repository.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/network/error/failure.dart';
import '../../../../core/services/token_manager.dart';
import '../../../../core/state/app_state_manager.dart';
import '../repositories/auth_repository.dart';
import '../entities/otp_verification.dart';

class VerifyOtpParams {
  final String identifier;
  final String otp;
  VerifyOtpParams(this.identifier, this.otp);
}
class VerifyOtpResult {
  final String? error;
  final String? successMessage;
  final AppState? appState;

  VerifyOtpResult({
    this.error,
    this.successMessage,
    this.appState,
  });
}

abstract class VerifyOtpUseCase {
  Future<VerifyOtpResult> execute(VerifyOtpParams params);
}

class VerifyOtpUseCaseImpl implements VerifyOtpUseCase {
  final AuthRepositoryImpl _authRepository;
  final TokenManager _tokenManager;

  VerifyOtpUseCaseImpl(this._authRepository, this._tokenManager);

  bool _isValidIdentifier(String identifier) =>
      identifier.isNotEmpty; // Simplified for example
  bool _isValidOtp(String otp) =>
      otp.length == 6 && RegExp(r'^\d{6}$').hasMatch(otp);

  @override
  Future<VerifyOtpResult> execute(VerifyOtpParams params) async {
    if (!_isValidIdentifier(params.identifier)) {
      return VerifyOtpResult(
        error: 'Invalid identifier format',
        appState: null,
      );
    }
    if (!_isValidOtp(params.otp)) {
      return VerifyOtpResult(
        error: 'OTP must be exactly 6 digits',
        appState: null,
      );
    }

    final result =
        await _authRepository.verifyOtp(params.identifier, params.otp);

    if (result.isLeft()) {
      // Get the error string from Failure
      final failure = result.swap().getOrElse(() => Failure('Unknown error'));
      return VerifyOtpResult(
        error: failure.message,
        appState: null,
      );
    }

    final verification =
        result.getOrElse(() => throw Exception('Unexpected error'));

    // Store tokens if present
    if (verification.accessToken != null && verification.refreshToken != null) {
      await _tokenManager.saveTokens(
        accessToken: verification.accessToken!,
        accessTokenExpiry: verification.accessTokenExpiry ?? 0,
        refreshToken: verification.refreshToken!,
        refreshTokenExpiry: verification.refreshTokenExpiry ?? 0,
      );
    }

    if (verification.isApproved) {
      await AppStateManager.saveAppState(HomeState());
      return VerifyOtpResult(
        error: null,
        successMessage: verification.message,
        appState: HomeState(),
      );
    } else {
      await AppStateManager.saveAppState(ProfileState());
      return VerifyOtpResult(
        error: null,
        successMessage: verification.message,
        appState: ProfileState(),
      );
    }
  }
}
