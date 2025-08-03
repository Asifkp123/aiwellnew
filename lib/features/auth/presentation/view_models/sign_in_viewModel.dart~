import 'dart:async';
import 'dart:ffi';
import 'package:aiwel/features/auth/domain/usecases/get_access_token_expiry_use_case.dart';
import 'package:aiwel/features/auth/presentation/screens/profile_screens/profile_screen.dart';
import 'package:aiwel/features/home/home_screen.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../../../../core/constants/strings.dart';
import '../../../../core/network/error/failure.dart';
import '../../../../core/state/app_state_manager.dart';
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
import '../../domain/usecases/check_auth_status_use_case.dart';
import '../../data/models/api/submit_profile_response.dart';
import '../../domain/entities/otp_verification.dart';
import '../screens/signin_signup_screen.dart';
import '../screens/otp_screen.dart';
import '../../../home/home_screen.dart';
import '../../../../../components/snackbars/custom_snackbar.dart';

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

  bool get isLoading =>
      status == SignInStatus.loading || status == SignInStatus.verifyingOtp;
  bool get isOtpSent =>
      status == SignInStatus.otpSent ||
      status == SignInStatus.verifyingOtp ||
      status == SignInStatus.success;
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
  Future<void> requestOtpWithNavigation(BuildContext context);
  Future<void> verifyOtp(BuildContext context);
  Future<SubmitProfileResult> submitProfile(BuildContext context);
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
  final VerifyOtpUseCase verifyOtpUseCaseBase;
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
  final StreamController<SignInState> _stateController =
      StreamController<SignInState>.broadcast();

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
    'Happy',
    'Sad',
    'Angry',
    'Anxious',
    'Calm',
    'Confused',
    'Tired',
    'Excited'
  ];
  final List<String> sleepOptions = ['Excellent', 'Good', 'Fair', 'Poor'];
  final List<String> workoutOptions = ['Excellent', 'Good', 'Average', 'Poor'];

  final List<String> displayedMoods = [
    'Happy',
    'Sad',
    'Angry',
    'Anxious',
    'Calm',
    'Confused',
    'Tired',
    'Excited'
  ];
  final List<String> displayedSleeps = ['Excellent', 'Good', 'Fair', 'Poor'];
  final List<String> displayedWorkouts = [
    'Excellent',
    'Good',
    'Average',
    'Poor'
  ];

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

    final isEmail =
        RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(identifier);
    print(identifier);

    final isPhone = RegExp(r'^\+?[1-9]\d{9,14}$').hasMatch(identifier);
    if (!isEmail && !isPhone) {
      print(_errorMessage);
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

        // Navigate to OTP screen
        Navigator.pushNamed(
          context,
          OtpScreen.routeName,
          arguments: {'viewModelBase': this},
        );
      },
    );
  }

  Future<void> verifyOtp(BuildContext context) async {
    final otp = _otpController.text.trim();
    if (otp.isEmpty) {
      _errorMessage = Strings.emptyOtpMessage;
      _status = SignInStatus.error;
      _emitState();
      return;
    }
    _status = SignInStatus.verifyingOtp;
    _emitState();

    final result = await verifyOtpUseCaseBase.execute(
      VerifyOtpParams(
        _emailController.text.trim(),
        otp,
      ),
    );
    if (result.error != null) {
      _errorMessage = result.error;
      _status = SignInStatus.error;
      _emitState();
      return;
    }

    _status = SignInStatus.success;
    _feedbackMessage = result.successMessage;
    _emitState();

    if (result.appState is HomeState) {
      Navigator.pushReplacementNamed(context, HomeScreen.routeName);
    } else if (result.appState is ProfileState) {
      Navigator.pushReplacementNamed(
        context,
        ProfileScreen.routeName,
        arguments: this, // Make sure ProfileScreen handles this correctly
      );
    } else {
      _status = SignInStatus.error;
      _errorMessage = "Unknown navigation state.";
      _emitState();
    }
  }

  @override
  Future<SubmitProfileResult> submitProfile(BuildContext context) async {
    if (!validateProfile()) {
      _errorMessage = Strings.invalidProfileMessage;
      _status = SignInStatus.error;
      _emitState();
      return SubmitProfileResult(
        error: _errorMessage,
        appState: null,
      );
    }

    // Ensure valid token before proceeding
    if (!await _ensureValidToken()) {
      return SubmitProfileResult(
        error: _errorMessage ?? Strings.noTokenAvailable,
        appState: null,
      );
    }

    _status = SignInStatus.loading;
    _emitState();

    String formattedDate;
    try {
      DateTime parsedDate =
          DateFormat('dd-MM-yyyy').parse(_dateOfBirthController.text.trim());
      formattedDate = DateFormat('yyyy-MM-dd').format(parsedDate);
    } catch (e) {
      _errorMessage = Strings.invalidDateFormatMessage;
      _status = SignInStatus.error;
      _emitState();
      return SubmitProfileResult(
        error: _errorMessage,
        appState: null,
      );
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

    // Handle the result with navigation and snackbar
    if (result.error != null) {
      // Show error snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        commonSnackBarWidget(
          content: result.error!,
          type: SnackBarType.error,
        ),
      );
    } else if (result.successMessage != null) {
      // Show success snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        commonSnackBarWidget(
          content: result.successMessage!,
          type: SnackBarType.message,
        ),
      );

      // Navigate to HomeScreen if appState is HomeState
      if (result.appState is HomeState) {
        Navigator.pushReplacementNamed(context, HomeScreen.routeName);
      }
    }

    return result;
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
          // final refreshUseCase = RefreshTokenUseCase(
          //   authRemoteDataSource: AuthRemoteDataSourceImpl(authLocalDataSource: authLocalDataSourceImpl),
          //   authLocalDataSource: authLocalDataSourceImpl,
          // );
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
              final newAccessTokenResult =
                  await getAccessTokenUseCase.execute();
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
        (_selectedMood != null ||
            _selectedSleep != null ||
            _selectedWorkout != null);
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
  void startAnimationForWorkout(
      GlobalKey<AnimatedListState> workoutListKey) async {
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
