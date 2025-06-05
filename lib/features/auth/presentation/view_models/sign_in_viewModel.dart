import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/strings.dart';
import '../../../../core/network/error/failure.dart';
import '../../data/datasources/local/auth_local_datasource.dart';
import '../../data/models/api/otp_request_success.dart';
import '../../data/models/api/verify_otp_response.dart';
import '../../domain/usecases/request_otp_use_case.dart';
import '../../domain/usecases/verify_otp_use_case.dart';


/// Enum for sign-in status.
enum SignInStatus { idle, loading, otpSent, verifyingOtp, success, error }

/// Encapsulates the state of the sign-in process.
class SignInState {
  final SignInStatus status;
  final String? errorMessage;
  final String? token;
  final String? feedbackMessage; // For success or info messages

  SignInState({
    required this.status,
    this.errorMessage,
    this.token,
    this.feedbackMessage,
  });

  bool get isLoading => status == SignInStatus.loading || status == SignInStatus.verifyingOtp;
  bool get isOtpSent => status == SignInStatus.otpSent || status == SignInStatus.verifyingOtp || status == SignInStatus.success;
}

/// Abstract interface for the SignInViewModel.
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
}

/// ViewModel for the sign-in feature, using streams for state management.
class SignInViewModel implements SignInViewModelBase {
  final RequestOtpUseCase requestOtpUseCase;
  final VerifyOtpUseCase verifyOtpUseCase;
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
  SignInViewModel({
    required this.requestOtpUseCase,
    required this.verifyOtpUseCase,
    required this.authLocalDataSourceImpl,
  }) {
    _emitState(); // Emit initial state
  }

  @override
  TextEditingController get emailController => _emailController;

  @override
  TextEditingController get otpController => _otpController;

  @override
  Stream<SignInState> get stateStream => _stateController.stream;

  // Emit the current state to the stream
  void _emitState() {
    print('Emitting state: status=$_status, errorMessage=$_errorMessage, token=$_token');
    _stateController.add(SignInState(
      status: _status,
      errorMessage: _errorMessage,
      token: _token,
      feedbackMessage: _feedbackMessage,
    ));
  }



  @override
  Future<Either<Failure, OtpRequestSuccess>> requestOtp() async {
    final identifier = _emailController.text.trim();

    // Validate empty input
    if (identifier.isEmpty) {
      _errorMessage = 'Email or phone number cannot be empty'; // Replace with Strings.emptyEmailMessage
      _status = SignInStatus.error;
      _emitState();
      return Left(Failure(_errorMessage!));
    }

    // Validate email or phone format
    final isEmail = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(identifier);
    final isPhone = RegExp(r'^\+?[1-9]\d{9,14}$').hasMatch(identifier);
    if (!isEmail && !isPhone) {
      _errorMessage = 'Invalid email or phone number format'; // Replace with Strings.invalidEmailMessage
      _status = SignInStatus.error;
      _emitState();
      return Left(Failure(_errorMessage!));
    }

    // Set loading state
    _status = SignInStatus.loading;
    _errorMessage = null;
    _emitState();

    // Call UseCase and handle Either result
    final result = await requestOtpUseCase.execute(
      email: isEmail ? identifier : null,
      phoneNumber: isPhone ? identifier : null,
    );

    return result.fold(
          (failure) {
        _errorMessage = failure.message; // Replace with Strings.failedOtpRequestMessage

        _status = SignInStatus.error;
        _emitState();
        return Left(failure);
      },
          (success) {
            _otpController.clear();

            _status = SignInStatus.otpSent;
        _feedbackMessage= "OTP sent successfully!";
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
      final response = await verifyOtpUseCase.execute(
        _emailController.text.trim(),
        otp,
      );
      return response.fold(
              (failure) {
            _errorMessage = failure.message.isNotEmpty ? failure.message : Strings.failedOtpVerificationMessage;
            _status = SignInStatus.error;
            _emitState();
            return Left(failure);
          },
              (success) async {
            _status = SignInStatus.success;
            // final token = await authLocalDataSourceImpl.getToken();
            // print(token);
            // print("token");
            _feedbackMessage = "Sign-in successful!";
            _emitState();
            return Right(VerifyOtpResponse(success.response,  success.token));
          },
      );

    } catch (e) {
      _errorMessage = Strings.failedOtpVerificationMessage;
      _status = SignInStatus.error;
      return Left(Failure(_errorMessage!));
    }

  }

  @override
  void clearInputs() {
    _emailController.clear();
    _otpController.clear();
    _errorMessage = null;
    _token = null;
    _status = SignInStatus.idle;
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
  }

  @override

  void clearFeedback() {
    if (_feedbackMessage != null) {
      _feedbackMessage = null;
      _emitState();
    }
  }


}