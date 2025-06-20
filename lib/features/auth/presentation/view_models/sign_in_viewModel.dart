import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

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
}

// ViewModel for the sign-in feature
class SignInViewModel implements SignInViewModelBase {
  final RequestOtpUseCase requestOtpUseCase;
  final VerifyOtpUseCaseBase verifyOtpUseCaseBase;
  final AuthLocalDataSourceImpl authLocalDataSourceImpl;

  // Controllers for input fields
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
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
  Future<Either<Failure, bool>> submitProfile() async {
    if (!validateProfile()) {
      _errorMessage = "Please complete all required fields and select at least one option (mood, sleep, or workout).";
      _status = SignInStatus.error;
      _emitState();
      return Left(Failure(_errorMessage!));
    }

    _status = SignInStatus.loading;
    _emitState();

    try {
      final response = await http.post(
        Uri.parse('https://your-api-endpoint.com/profile'), // Replace with your API endpoint
        headers: {'Content-Type': 'application/json'},
        body: '''
        {
          "first_name": "${_nameController.text.trim()}",
          "gender": "${_genderController.text.trim()}",
          "date_of_birth": "${_dateOfBirthController.text.trim()}",
          "dominant_emotion": "${_selectedMood ?? ''}",
          "sleep_quality": "${_selectedSleep ?? ''}",
          "physical_activity": "${_selectedWorkout ?? ''}"
        }
        ''',
      );

      if (response.statusCode == 200) {
        _status = SignInStatus.success;
        _feedbackMessage = "Profile submitted successfully!";
        _emitState();
        return Right(true);
      } else {
        _errorMessage = "Failed to submit profile: ${response.reasonPhrase}";
        _status = SignInStatus.error;
        _emitState();
        return Left(Failure(_errorMessage!));
      }
    } catch (e) {
      _errorMessage = "Error submitting profile: $e";
      _status = SignInStatus.error;
      _emitState();
      return Left(Failure(_errorMessage!));
    }
  }

  @override
  bool validateProfile() {
    return _nameController.text.trim().isNotEmpty &&
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
    _feedbackMessage = "Selected: $mood";
    _emitState();
  }

  @override
  void selectSleep(String sleep) {
    _selectedSleep = sleep;
    _feedbackMessage = "Selected: $sleep";
    _emitState();
  }

  @override
  void selectWorkout(String workout) {
    _selectedWorkout = workout;
    _feedbackMessage = "Selected: $workout";
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
              onPrimary: Colors.white, // Controls the selected date background text color
            ),
            textTheme: const TextTheme(
              bodyLarge: TextStyle(
                color: Colors.black, // Default day text color
                fontWeight: FontWeight.normal,
              ),
              labelLarge: TextStyle(
                color: Colors.white, // Selected date text color
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
      dateOfBirthController.text = DateFormat('yyyy-MM-dd').format(picked);
    }
  }
  // @override
  // List<String> get displayedMoods => displayedMoods;
  //
  // @override
  // List<String> get displayedSleeps => displayedSleeps;
  //
  // @override
  // List<String> get displayedWorkouts => displayedWorkouts;
}