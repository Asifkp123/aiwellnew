import 'dart:async';
import 'dart:ffi';
import 'package:aiwel/features/auth/domain/usecases/get_access_token_expiry_use_case.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../../../../core/constants/strings.dart';
import '../../../../core/network/error/failure.dart';
import '../../data/datasources/local/auth_local_datasource.dart';
import '../../data/datasources/remote/auth_remote_datasource.dart';
import '../../data/models/api/otp_request_success.dart';
import '../../data/models/api/token_resonse.dart';
import '../../data/models/api/verify_otp_response.dart';
import '../../domain/usecases/get_access_token_use_case.dart';
import '../../domain/usecases/refresh_token_use_case.dart';
import '../../domain/usecases/request_otp_use_case.dart';
import '../../domain/usecases/submit_profile_use_case.dart';
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
  final String? selectedMood;
  final String? selectedSleep;
  final String? selectedWorkout;
  final String? name;
  final String? dateOfBirth;
  final String? gender;

  SignInState({
    required this.status,
    this.errorMessage,
    this.token,
    this.feedbackMessage,
    this.countdownSeconds = 0,
    this.selectedMood,
    this.selectedSleep,
    this.selectedWorkout,
    this.name,
    this.dateOfBirth,
    this.gender,
  });

  bool get isLoading => status == SignInStatus.loading || status == SignInStatus.verifyingOtp;
  bool get isOtpSent => status == SignInStatus.otpSent || status == SignInStatus.verifyingOtp || status == SignInStatus.success;
}

// Abstract interface for the SignInViewModel
abstract class SignInViewModelBase {
  TextEditingController get emailController;
  TextEditingController get otpController;
  TextEditingController get nameController;
  TextEditingController get lastNameController;
  TextEditingController get dateOfBirthController;
  TextEditingController get genderController;

  Stream<SignInState> get stateStream;
  Future<Either<Failure, OtpRequestSuccess>> requestOtp();
  Future<Either<Failure, VerifyOtpResponse>> verifyOtp();
  Future<Either<Failure, bool>> submitProfile();
  void clearInputs();
  void clearError();
  void dispose();
  void clearFeedback();
  void clearOtpSentFlag();
  void startCountdown();
  void resetCountdown();
  void startAnimationForEmotian(GlobalKey<AnimatedListState> listKey);
  void startAnimationForSleep(GlobalKey<AnimatedListState> sleepListKey);
  void startAnimationForWorkout(GlobalKey<AnimatedListState> workoutListKey);
  List<String> get displayedMoods;
  List<String> get displayedSleeps;
  List<String> get displayedWorkouts;
  void selectMood(String mood);
  void selectSleep(String sleep);
  void selectWorkout(String workout);
  bool validateProfile();
  void selectDate(BuildContext context);
  Future<String?> getToken();
  void clearErrorMessage();
}

// ViewModel for the sign-in feature
class SignInViewModel implements SignInViewModelBase {
  final RequestOtpUseCase requestOtpUseCase;
  final VerifyOtpUseCaseBase verifyOtpUseCaseBase;
  final SubmitProfileUseCaseBase submitProfileUseCaseBase;
  final AuthLocalDataSourceImpl authLocalDataSourceImpl;
  final GetAccessTokenUseCase getAccessTokenUseCase;
  final GetAccessTokenExpiryUseCase getAccessTokenExpiryUseCase;
  final RefreshTokenUseCase refreshUseCase;


  // Controllers for input fields
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _dateOfBirthController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();

  // StreamController to emit state changes
  final StreamController<SignInState> _stateController = StreamController<SignInState>.broadcast();

  // Current state variables
  SignInStatus _status = SignInStatus.idle;
  String? _errorMessage;
  String? _token;
  String? _feedbackMessage;
  String? _selectedMood;
  String? _selectedSleep;
  String? _selectedWorkout;
  String? _name;
  String? _dateOfBirth;
  String? _gender;

  // Countdown variables
  int _countdown = 60;
  Timer? _timer;

  // Mood, sleep, and workout options
  final List<String> moodOptions = [
    'Happy', 'Sad', 'Angry', 'Anxious', 'Calm', 'Confused', 'Tired', 'Excited'
  ];
  final List<String> sleepOptions = ['Excellent', 'Good', 'Fair', 'Poor'];
  final List<String> workoutOptions = ['Excellent', 'Good', 'Average', 'Poor'];

  final List<String> displayedMoods = [
    'Happy', 'Sad', 'Angry', 'Anxious', 'Calm', 'Confused', 'Tired', 'Excited'
  ];
  final List<String> displayedSleeps = ['Excellent', 'Good', 'Fair', 'Poor'];
  final List<String> displayedWorkouts = ['Excellent', 'Good', 'Average', 'Poor'];

  // Flags to prevent multiple animation calls
  bool _moodAnimationStarted = false;
  bool _sleepAnimationStarted = false;
  bool _workoutAnimationStarted = false;

  SignInViewModel({
    required this.requestOtpUseCase,
    required this.verifyOtpUseCaseBase,
    required this.authLocalDataSourceImpl,
    required this.submitProfileUseCaseBase,
    required this.getAccessTokenUseCase,
    required this.getAccessTokenExpiryUseCase,
    required this.refreshUseCase,
  }) {
    _emitState();
  }

  @override
  TextEditingController get emailController => _emailController;
  @override
  TextEditingController get otpController => _otpController;
  @override
  TextEditingController get nameController => _nameController;
  @override
  TextEditingController get lastNameController => _lastNameController;
  @override
  TextEditingController get dateOfBirthController => _dateOfBirthController;
  @override
  TextEditingController get genderController => _genderController;

  @override
  Stream<SignInState> get stateStream => _stateController.stream;

  // Emit the current state to the stream
  void _emitState() {
    _stateController.add(SignInState(
      status: _status,
      errorMessage: _errorMessage,
      token: _token,
      feedbackMessage: _feedbackMessage,
      countdownSeconds: _countdown,
      selectedMood: _selectedMood,
      selectedSleep: _selectedSleep,
      selectedWorkout: _selectedWorkout,
      name: _name,
      dateOfBirth: _dateOfBirth,
      gender: _gender,
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
            (success) async {
          if (success is TokenResponse) {
            if (success.accessToken.isEmpty || success.refreshToken.isEmpty) {
              _errorMessage = Strings.tokenNotFoundMessage;
              _status = SignInStatus.error;
              _emitState();
              return Left(Failure(_errorMessage!));
            }
            await authLocalDataSourceImpl.saveTokens(
              accessToken: success.accessToken,
              accessTokenExpiry: success.accessTokenExpiry,
              refreshToken: success.refreshToken,
              refreshTokenExpiry: success.refreshTokenExpiry,
            );
            _status = SignInStatus.success;
            _feedbackMessage = "Sign-in successful!";
            _token = success.accessToken;
            resetCountdown();
            _emitState();
            clearInputs();
            return Right(success);
          } else {
            _errorMessage = Strings.tokenNotFoundMessage;
            _status = SignInStatus.error;
            _emitState();
            return Left(Failure(_errorMessage!));
          }
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
  Future<Either<Failure, bool>> submitProfile() async {
    if (!validateProfile()) {
      _errorMessage = Strings.invalidProfileMessage;
      _status = SignInStatus.error;
      _emitState();
      return Left(Failure(_errorMessage!));
    }

    // Ensure valid token before proceeding
    if (!await _ensureValidToken()) {
      return Left(Failure(_errorMessage ?? Strings.noTokenAvailable));
    }

    _status = SignInStatus.loading;
    _emitState();

    String formattedDate;
    try {
      DateTime parsedDate = DateFormat('dd-MM-yyyy').parse(_dateOfBirthController.text.trim());
      formattedDate = DateFormat('yyyy-MM-dd').format(parsedDate);
    } catch (e) {
      _errorMessage = Strings.invalidDateFormatMessage;
      _status = SignInStatus.error;
      _emitState();
      return Left(Failure(_errorMessage!));
    }

    final result = await submitProfileUseCaseBase.execute(
      firstName: _nameController.text.trim(),
      lastName: _lastNameController.text.trim(),
      gender: _genderController.text.trim(),
      dateOfBirth: formattedDate,
      dominantEmotion: _selectedMood?.toLowerCase() ?? '',
      sleepQuality: _selectedSleep?.toLowerCase() ?? '',
      physicalActivity: _selectedWorkout?.toLowerCase() ?? '',
    );

    return result.fold(
          (failure) {
        _errorMessage = failure.message;
        _status = SignInStatus.error;
        _emitState();
        return Left(failure);
      },
          (success) {
        _status = SignInStatus.success;
        _feedbackMessage = success ? "Profile submitted successfully!" : "Profile submission failed.";
        _emitState();
        return Right(success);
      },
    );
  }

  @override
  Future<String?> getToken() async {
    try {
      final token = await authLocalDataSourceImpl.getAccessToken();
      if (token == null) {
        _errorMessage = Strings.noTokenAvailable;
        _status = SignInStatus.error;
      } else {
        _status = SignInStatus.idle;
      }
      _token = token;
      _emitState();
      return token;
    } catch (e) {
      _errorMessage = Strings.tokenRetrievalError;
      _status = SignInStatus.error;
      _emitState();
      return null;
    }
  }

  Future<bool> _ensureValidToken() async {

    final result = await getAccessTokenUseCase.execute();
    return result.fold(
          (failure) async {
        _errorMessage = failure.message;
        _status = SignInStatus.error;
        _emitState();
        await logout();
        return false;
      },
          (tokenData) async {
        final accessToken = tokenData.$1;
        final accessTokenExpiry = tokenData.$2;

        if (accessToken == null || accessTokenExpiry == null) {
          _errorMessage = Strings.noTokenAvailable;
          _status = SignInStatus.error;
          _emitState();
          await logout();
          return false;
        }

        final currentTime = DateTime.now().millisecondsSinceEpoch ~/ 1000;
        const buffer = 300; // 5-minute buffer before expiry

        if (currentTime >= accessTokenExpiry - buffer) {
          final refreshUseCase = RefreshTokenUseCase(
            authRemoteDataSource: AuthRemoteDataSourceImpl(authLocalDataSource: authLocalDataSourceImpl),
            authLocalDataSource: authLocalDataSourceImpl,
          );
          final refreshResult = await refreshUseCase.execute();
          return refreshResult.fold(
                (failure) {
              _errorMessage = failure.message;
              _status = SignInStatus.error;
              _emitState();
              return false;
            },
                (success) async {
              if (!success) {
                _errorMessage = Strings.noTokenAfterRefresh;
                _status = SignInStatus.error;
                _emitState();
                await logout();
                return false;
              }
              final newAccessTokenResult = await getAccessTokenUseCase.execute();
              return newAccessTokenResult.fold(
                    (failure) async {
                  _errorMessage = failure.message;
                  _status = SignInStatus.error;
                  _emitState();
                  await logout();
                  return false;
                },
                    (newTokenData) async {
                  final newAccessToken = newTokenData.$1;
                  if (newAccessToken == null) {
                    _errorMessage = Strings.noTokenAfterRefresh;
                    _status = SignInStatus.error;
                    _emitState();
                    await logout();
                    return false;
                  }
                  _token = newAccessToken;
                  return true;
                },
              );
            },
          );
        }

        _token = accessToken;
        return true;
      },
    );
  }
  @override
  Future<void> logout() async {
    await authLocalDataSourceImpl.clearTokens();
    _token = null;
    _status = SignInStatus.idle;
    _errorMessage = Strings.sessionExpired;
    clearInputs();
    _emitState();
  }

  @override
  bool validateProfile() {
    return _nameController.text.trim().isNotEmpty &&
        _lastNameController.text.trim().isNotEmpty &&
        _dateOfBirthController.text.trim().isNotEmpty &&
        _genderController.text.trim().isNotEmpty &&
        (_selectedMood != null || _selectedSleep != null || _selectedWorkout != null);
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
    _nameController.clear();
    _lastNameController.clear();
    _dateOfBirthController.clear();
    _genderController.clear();
    _errorMessage = null;
    _token = null;
    _status = SignInStatus.idle;
    _selectedMood = null;
    _selectedSleep = null;
    _selectedWorkout = null;
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
    _nameController.dispose();
    _lastNameController.dispose();
    _dateOfBirthController.dispose();
    _genderController.dispose();
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
  void startAnimationForEmotian(GlobalKey<AnimatedListState> listKey) async {
    if (_moodAnimationStarted) return;
    _moodAnimationStarted = true;
    displayedMoods.clear();
    for (int i = 0; i < moodOptions.length; i++) {
      await Future.delayed(Duration(milliseconds: 150));
      displayedMoods.insert(i, moodOptions[i]);
      listKey.currentState?.insertItem(i);
    }
  }

  @override
  void startAnimationForSleep(GlobalKey<AnimatedListState> sleepListKey) async {
    if (_sleepAnimationStarted) return;
    _sleepAnimationStarted = true;
    displayedSleeps.clear();
    for (int i = 0; i < sleepOptions.length; i++) {
      await Future.delayed(Duration(milliseconds: 150));
      displayedSleeps.insert(i, sleepOptions[i]);
      sleepListKey.currentState?.insertItem(i);
    }
  }

  @override
  void startAnimationForWorkout(GlobalKey<AnimatedListState> workoutListKey) async {
    if (_workoutAnimationStarted) return;
    _workoutAnimationStarted = true;
    displayedWorkouts.clear();
    for (int i = 0; i < workoutOptions.length; i++) {
      await Future.delayed(Duration(milliseconds: 150));
      displayedWorkouts.insert(i, workoutOptions[i]);
      workoutListKey.currentState?.insertItem(i);
    }
  }

  @override
  void selectMood(String mood) {
    _selectedMood = mood;
    _emitState();
  }

  @override
  void selectSleep(String sleep) {
    _selectedSleep = sleep;
    _emitState();
  }

  @override
  void selectWorkout(String workout) {
    _selectedWorkout = workout;
    _emitState();
  }

  @override
  void selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Colors.purple,
            colorScheme: const ColorScheme.light(
              primary: Colors.purple,
              onPrimary: Colors.white,
            ),
            textTheme: const TextTheme(
              bodyLarge: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.normal,
              ),
              labelLarge: TextStyle(
                color: Colors.white,
              ),
            ),
            buttonTheme: const ButtonThemeData(
              textTheme: ButtonTextTheme.primary,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      dateOfBirthController.text = DateFormat('dd-MM-yyyy').format(picked);
    }
  }

  @override
  void clearErrorMessage() {
    if (_errorMessage != null) {
      _errorMessage = null;
      _emitState();
    }
  }
}