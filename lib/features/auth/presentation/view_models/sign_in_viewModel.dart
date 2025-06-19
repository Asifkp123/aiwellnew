import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../../../core/constants/strings.dart';
import '../../../../core/network/error/failure.dart';
import '../../data/datasources/local/auth_local_datasource.dart';
import '../../data/models/api/otp_request_success.dart';
import '../../data/models/api/verify_otp_response.dart';
import '../../domain/usecases/request_otp_use_case.dart';
import '../../domain/usecases/verify_otp_use_case.dart';

// Enum for sign-in status
enum SignInStatus { idle, loading, otpSent, verifyingOtp, success, error }

// Encapsulates the state of the sign-in process
class SignInState {
  final SignInStatus status;
  final String? errorMessage;
  final String? token;
  final String? feedbackMessage;
  final int countdownSeconds;
  final String? selectedMood; // Add selected mood to state

  SignInState({
    required this.status,
    this.errorMessage,
    this.token,
    this.feedbackMessage,
    this.countdownSeconds = 0,
    this.selectedMood,
  });

  bool get isLoading => status == SignInStatus.loading || status == SignInStatus.verifyingOtp;
  bool get isOtpSent => status == SignInStatus.otpSent || status == SignInStatus.verifyingOtp || status == SignInStatus.success;
}

// Abstract interface for the SignInViewModel
abstract class SignInViewModelBase {
  TextEditingController get emailController;
  TextEditingController get otpController;
  Stream<SignInState> get stateStream;

  Future<Either<Failure, OtpRequestSuccess>> requestOtp();
  Future<Either<Failure, VerifyOtpResponse>> verifyOtp();
  void clearInputs();
  void clearError();
  void dispose();
  void clearFeedback();
  void clearOtpSentFlag();
  void startCountdown();
  void resetCountdown();
  void startAnimation();
  GlobalKey<AnimatedListState> get listKey;
  List<String> get displayedMoods;
  void selectMood(String mood);
}

// ViewModel for the sign-in feature, using streams for state management
class SignInViewModel implements SignInViewModelBase {
  final RequestOtpUseCase requestOtpUseCase;
  final VerifyOtpUseCaseBase verifyOtpUseCaseBase;
  final AuthLocalDataSourceImpl authLocalDataSourceImpl;

  // Controllers for input fields
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();

  // StreamController to emit state changes
  final StreamController<SignInState> _stateController = StreamController<SignInState>.broadcast();

  // Current state variables
  SignInStatus _status = SignInStatus.idle;
  String? _errorMessage;
  String? _token;
  String? _feedbackMessage;
  String? _selectedMood; // Track selected mood
  // Countdown variables
  int _countdown = 60; // Initial countdown time in seconds
  Timer? _timer; // Timer for countdown

  // Mood animation variables
  final GlobalKey<AnimatedListState> listKey = GlobalKey();
  final List<String> moodOptions = [
    'Happy', 'Sad', 'Angry', 'Anxious', 'Calm', 'Confused', 'Tired', 'Excited'
  ];
  final List<String> displayedMoods = [];

  SignInViewModel({
    required this.requestOtpUseCase,
    required this.verifyOtpUseCaseBase,
    required this.authLocalDataSourceImpl,
  }) {
    _emitState(); // Emit initial state
    startAnimation(); // Start mood animation
  }

  @override
  TextEditingController get emailController => _emailController;

  @override
  TextEditingController get otpController => _otpController;

  @override
  Stream<SignInState> get stateStream => _stateController.stream;

  // Emit the current state to the stream
  void _emitState() {
    print(
        'Emitting state: status=$_status, errorMessage=$_errorMessage, token=$_token, countdown=$_countdown');
    _stateController.add(SignInState(
      status: _status,
      errorMessage: _errorMessage,
      token: _token,
      feedbackMessage: _feedbackMessage,
      countdownSeconds: _countdown,
      selectedMood: _selectedMood,
    ));
  }

  @override
  Future<Either<Failure, OtpRequestSuccess>> requestOtp() async {
    final identifier = _emailController.text.trim();

    if (identifier.isEmpty) {
      _errorMessage = Strings.emptyEmailMessage;
      _status = SignInStatus.error;
      _emitState();
      return Left(Failure(_errorMessage!));
    }

    final isEmail = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(identifier);
    final isPhone = RegExp(r'^\+?[1-9]\d{9,14}$').hasMatch(identifier);
    if (!isEmail && !isPhone) {
      _errorMessage = Strings.invalidEmailMessage;
      _status = SignInStatus.error;
      _emitState();
      return Left(Failure(_errorMessage!));
    }

    _status = SignInStatus.loading;
    _errorMessage = null;
    _emitState();

    final result = await requestOtpUseCase.execute(
      email: isEmail ? identifier : null,
      phoneNumber: isPhone ? identifier : null,
    );

    return result.fold(
          (failure) {
        _errorMessage = failure.message;
        _status = SignInStatus.error;
        _emitState();
        return Left(failure);
      },
          (success) {
        _otpController.clear();
        _status = SignInStatus.otpSent;
        _feedbackMessage = "OTP sent successfully!";
        startCountdown();
        _emitState();
        return Right(success);
      },
    );
  }

  @override
  Future<Either<Failure, VerifyOtpResponse>> verifyOtp() async {
    final otp = _otpController.text.trim();
    if (otp.isEmpty) {
      _errorMessage = Strings.emptyOtpMessage;
      _status = SignInStatus.error;
      _emitState();
      return Left(Failure(_errorMessage!));
    }

    if (otp.length != 6) {
      _errorMessage = Strings.invalidOtpMessage;
      _status = SignInStatus.error;
      _emitState();
      return Left(Failure(_errorMessage!));
    }

    _status = SignInStatus.verifyingOtp;
    _errorMessage = null;
    _emitState();

    try {
      final response = await verifyOtpUseCaseBase.execute(
        _emailController.text.trim(),
        otp,
      );
      return response.fold(
            (failure) {
          _errorMessage = failure.message.isNotEmpty
              ? failure.message
              : Strings.failedOtpVerificationMessage;
          _status = SignInStatus.error;
          _emitState();
          return Left(failure);
        },
            (success) {
          _status = SignInStatus.success;
          _feedbackMessage = "Sign-in successful!";
          resetCountdown();
          _emitState();
          clearInputs();
          return Right(success);
        },
      );
    } catch (e) {
      _errorMessage = Strings.failedOtpVerificationMessage;
      _status = SignInStatus.error;
      _emitState();
      return Left(Failure(_errorMessage!));
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
    _token = null;
    _status = SignInStatus.idle;
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
  void dispose() {
    _emailController.dispose();
    _otpController.dispose();
    _stateController.close();
    resetCountdown();
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
    _status = SignInStatus.idle;
    _emitState();
  }

  @override
  void startAnimation() async {
    for (int i = 0; i < moodOptions.length; i++) {
      await Future.delayed(Duration(milliseconds: 150));
      displayedMoods.insert(i, moodOptions[i]);
      listKey.currentState?.insertItem(i);
    }
  }

  @override
  void selectMood(String mood) {
    _selectedMood = mood;
    _feedbackMessage = "Selected: $mood";
    _emitState();
  }


}