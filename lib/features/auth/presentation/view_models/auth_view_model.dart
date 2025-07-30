import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/strings.dart';
import '../../../../core/network/error/failure.dart';
import '../../../../core/state/app_state_manager.dart';
import '../../data/datasources/local/auth_local_datasource.dart';
import '../../data/models/api/otp_request_success.dart';
import '../../domain/usecases/request_otp_use_case.dart';
import '../../domain/usecases/verify_otp_use_case.dart';
import '../../domain/entities/otp_verification.dart';
import '../screens/otp_screen.dart';
import '../screens/profile_screens/profile_screen.dart';
import '../../../home/home_screen.dart';
import '../../../../../components/snackbars/custom_snackbar.dart';

// Enum for authentication status
enum AuthStatus { idle, loading, otpSent, verifyingOtp, success, error }

// Authentication state
class AuthState {
  final AuthStatus status;
  final String? errorMessage;
  final String? feedbackMessage;
  final int countdownSeconds;

  AuthState({
    required this.status,
    this.errorMessage,
    this.feedbackMessage,
    this.countdownSeconds = 0,
  });

  bool get isLoading =>
      status == AuthStatus.loading || status == AuthStatus.verifyingOtp;
  bool get isOtpSent =>
      status == AuthStatus.otpSent ||
      status == AuthStatus.verifyingOtp ||
      status == AuthStatus.success;
}

// Abstract interface
abstract class AuthViewModelBase {
  TextEditingController get emailController;
  TextEditingController get otpController;
  Stream<AuthState> get stateStream;
  Future<Either<Failure, OtpRequestSuccess>> requestOtp();
  Future<void> requestOtpWithNavigation(BuildContext context);
  Future<void> verifyOtp(BuildContext context);
  void clearInputs();
  void clearError();
  void clearFeedback();
  void clearOtpSentFlag();
  void startCountdown();
  void resetCountdown();
  void clearErrorMessage();
  void dispose();
}

// AuthViewModel - Only for signin/signup and OTP screens
class AuthViewModel implements AuthViewModelBase {
  final RequestOtpUseCase requestOtpUseCase;
  final VerifyOtpUseCase verifyOtpUseCaseBase;
  final AuthLocalDataSourceImpl authLocalDataSourceImpl;

  // Controllers
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();

  // StreamController
  final StreamController<AuthState> _stateController =
      StreamController<AuthState>.broadcast();

  // State variables
  AuthStatus _status = AuthStatus.idle;
  String? _errorMessage;
  String? _feedbackMessage;
  int _countdown = 60;
  Timer? _timer;

  AuthViewModel({
    required this.requestOtpUseCase,
    required this.verifyOtpUseCaseBase,
    required this.authLocalDataSourceImpl,
  }) {
    _emitState();
  }

  @override
  TextEditingController get emailController => _emailController;
  @override
  TextEditingController get otpController => _otpController;
  @override
  Stream<AuthState> get stateStream => _stateController.stream;

  void _emitState() {
    _stateController.add(AuthState(
      status: _status,
      errorMessage: _errorMessage,
      feedbackMessage: _feedbackMessage,
      countdownSeconds: _countdown,
    ));
  }

  @override
  Future<Either<Failure, OtpRequestSuccess>> requestOtp() async {
    final identifier = _emailController.text.trim();

    if (identifier.isEmpty) {
      _errorMessage = Strings.emptyEmailMessage;
      _status = AuthStatus.error;
      _emitState();
      return Left(Failure(_errorMessage!));
    }

    final isEmail =
        RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(identifier);
    final isPhone = RegExp(r'^\+?[1-9]\d{9,14}$').hasMatch(identifier);

    if (!isEmail && !isPhone) {
      _errorMessage = "Please enter a valid email or phone number";
      _status = AuthStatus.error;
      _emitState();
      return Left(Failure(_errorMessage!));
    }

    _status = AuthStatus.loading;
    _errorMessage = null;
    _emitState();

    final result = await requestOtpUseCase.execute(
      email: isEmail ? identifier : null,
      phoneNumber: isPhone ? identifier : null,
    );

    return result.fold(
      (failure) {
        _errorMessage = failure.message;
        _status = AuthStatus.error;
        _emitState();
        return Left(failure);
      },
      (success) {
        _otpController.clear();
        _status = AuthStatus.otpSent;
        _feedbackMessage = "OTP sent successfully!";
        startCountdown();
        _emitState();
        return Right(success);
      },
    );
  }

  @override
  Future<void> requestOtpWithNavigation(BuildContext context) async {
    final result = await requestOtp();

    result.fold(
      (failure) {
        ScaffoldMessenger.of(context).showSnackBar(
          commonSnackBarWidget(
            content: failure.message,
            type: SnackBarType.error,
          ),
        );
      },
      (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          commonSnackBarWidget(
            content: "OTP sent successfully!",
            type: SnackBarType.message,
          ),
        );

        Navigator.pushNamed(
          context,
          OtpScreen.routeName,
          arguments: {'viewModelBase': this},
        );
      },
    );
  }

  @override
  Future<void> verifyOtp(BuildContext context) async {
    final otp = _otpController.text.trim();
    if (otp.isEmpty) {
      _errorMessage = Strings.emptyOtpMessage;
      _status = AuthStatus.error;
      _emitState();
      return;
    }

    _status = AuthStatus.verifyingOtp;
    _emitState();

    final result = await verifyOtpUseCaseBase.execute(
      VerifyOtpParams(_emailController.text.trim(), otp),
    );

    if (result.error != null) {
      _errorMessage = result.error;
      _status = AuthStatus.error;
      _emitState();
      return;
    }

    _status = AuthStatus.success;
    _feedbackMessage = result.successMessage;
    _emitState();

    if (result.appState is HomeState) {
      Navigator.pushReplacementNamed(context, HomeScreen.routeName);
    } else if (result.appState is ProfileState) {
      Navigator.pushReplacementNamed(context, ProfileScreen.routeName);
    } else {
      _status = AuthStatus.error;
      _errorMessage = "Unknown navigation state.";
      _emitState();
    }
  }

  @override
  void startCountdown() {
    _countdown = 60;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_countdown > 0) {
        _countdown--;
        _emitState();
      } else {
        timer.cancel();
        _timer = null;
        _emitState();
      }
    });
  }

  @override
  void resetCountdown() {
    _timer?.cancel();
    _timer = null;
    _countdown = 0;
    _emitState();
  }

  @override
  void clearInputs() {
    _emailController.clear();
    _otpController.clear();
    _errorMessage = null;
    _status = AuthStatus.idle;
    resetCountdown();
    _emitState();
  }

  @override
  void clearError() {
    if (_errorMessage != null) {
      _errorMessage = null;
      _emitState();
    }
  }

  @override
  void clearFeedback() {
    if (_feedbackMessage != null) {
      _feedbackMessage = null;
      _emitState();
    }
  }

  @override
  void clearOtpSentFlag() {
    _status = AuthStatus.idle;
    _emitState();
  }

  @override
  void clearErrorMessage() {
    if (_errorMessage != null) {
      _errorMessage = null;
      _emitState();
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _otpController.dispose();
    _stateController.close();
    resetCountdown();
  }
}
