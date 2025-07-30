import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/strings.dart';
import '../../domain/usecases/submit_profile_use_case.dart';
import '../../domain/usecases/get_access_token_use_case.dart';
import '../../domain/usecases/refresh_token_use_case.dart';
import '../../data/datasources/local/auth_local_datasource.dart';
import '../../data/models/api/submit_profile_response.dart';
import '../../../../core/state/app_state_manager.dart';
import '../../../home/home_screen.dart';
import '../../../../../components/snackbars/custom_snackbar.dart';

// Enum for profile status
enum ProfileStatus { idle, loading, success, error }

// Profile state
class ProfileState {
  final ProfileStatus status;
  final String? errorMessage;
  final String? successMessage;
  final String? selectedMood;
  final String? selectedSleep;
  final String? selectedWorkout;
  final String? name;
  final String? dateOfBirth;
  final String? gender;

  ProfileState({
    required this.status,
    this.errorMessage,
    this.successMessage,
    this.selectedMood,
    this.selectedSleep,
    this.selectedWorkout,
    this.name,
    this.dateOfBirth,
    this.gender,
  });

  bool get isLoading => status == ProfileStatus.loading;
}

// Abstract interface
abstract class ProfileViewModelBase {
  TextEditingController get nameController;
  TextEditingController get lastNameController;
  TextEditingController get dateOfBirthController;
  TextEditingController get genderController;

  Stream<ProfileState> get stateStream;

  // Profile data methods
  bool validateProfile();
  Future<SubmitProfileResult> submitProfile(BuildContext context);
  void selectDate(BuildContext context);

  // Preference methods
  void selectMood(String mood);
  void selectSleep(String sleep);
  void selectWorkout(String workout);

  // Getters for options
  List<String> get displayedMoods;
  List<String> get displayedSleeps;
  List<String> get displayedWorkouts;

  // Utility methods
  void clearInputs();
  void clearError();
  void dispose();
}

// ProfileViewModel - Handles all profile screens
class ProfileViewModel implements ProfileViewModelBase {
  final SubmitProfileUseCaseBase submitProfileUseCaseBase;
  final GetAccessTokenUseCase getAccessTokenUseCase;
  final RefreshTokenUseCase refreshUseCase;
  final AuthLocalDataSourceImpl authLocalDataSourceImpl;

  // Controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _dateOfBirthController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();

  // StreamController
  final StreamController<ProfileState> _stateController =
      StreamController<ProfileState>.broadcast();

  // State variables
  ProfileStatus _status = ProfileStatus.idle;
  String? _errorMessage;
  String? _successMessage;
  String? _selectedMood;
  String? _selectedSleep;
  String? _selectedWorkout;

  // Options for preferences (without animation lists, just the static options)
  final List<String> _moodOptions = [
    'Happy',
    'Sad',
    'Angry',
    'Anxious',
    'Calm',
    'Confused',
    'Tired',
    'Excited'
  ];
  final List<String> _sleepOptions = ['Excellent', 'Good', 'Fair', 'Poor'];
  final List<String> _workoutOptions = ['Excellent', 'Good', 'Average', 'Poor'];

  ProfileViewModel({
    required this.submitProfileUseCaseBase,
    required this.getAccessTokenUseCase,
    required this.refreshUseCase,
    required this.authLocalDataSourceImpl,
  }) {
    _emitState();
  }

  @override
  TextEditingController get nameController => _nameController;
  @override
  TextEditingController get lastNameController => _lastNameController;
  @override
  TextEditingController get dateOfBirthController => _dateOfBirthController;
  @override
  TextEditingController get genderController => _genderController;
  @override
  Stream<ProfileState> get stateStream => _stateController.stream;
  @override
  List<String> get displayedMoods => _moodOptions;
  @override
  List<String> get displayedSleeps => _sleepOptions;
  @override
  List<String> get displayedWorkouts => _workoutOptions;

  void _emitState() {
    _stateController.add(ProfileState(
      status: _status,
      errorMessage: _errorMessage,
      successMessage: _successMessage,
      selectedMood: _selectedMood,
      selectedSleep: _selectedSleep,
      selectedWorkout: _selectedWorkout,
      name: _nameController.text.trim(),
      dateOfBirth: _dateOfBirthController.text.trim(),
      gender: _genderController.text.trim(),
    ));
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

  // Internal method to ensure valid token
  Future<bool> _ensureValidToken() async {
    final result = await getAccessTokenUseCase.execute();
    return result.fold(
      (failure) async {
        _errorMessage = failure.message;
        _status = ProfileStatus.error;
        _emitState();
        await _logout();
        return false;
      },
      (tokenData) async {
        final accessToken = tokenData.$1;
        final accessTokenExpiry = tokenData.$2;

        if (accessToken == null || accessTokenExpiry == null) {
          _errorMessage = Strings.noTokenAvailable;
          _status = ProfileStatus.error;
          _emitState();
          await _logout();
          return false;
        }

        final currentTime = DateTime.now().millisecondsSinceEpoch ~/ 1000;
        const buffer = 300; // 5-minute buffer

        if (currentTime >= accessTokenExpiry - buffer) {
          final refreshResult = await refreshUseCase.execute();
          return refreshResult.fold(
            (failure) {
              _errorMessage = failure.message;
              _status = ProfileStatus.error;
              _emitState();
              return false;
            },
            (success) async {
              if (!success) {
                _errorMessage = Strings.noTokenAfterRefresh;
                _status = ProfileStatus.error;
                _emitState();
                await _logout();
                return false;
              }
              return true;
            },
          );
        }
        return true;
      },
    );
  }

  // Internal logout method
  Future<void> _logout() async {
    await authLocalDataSourceImpl.clearTokens();
    _errorMessage = Strings.sessionExpired;
    clearInputs();
    _emitState();
  }

  @override
  Future<SubmitProfileResult> submitProfile(BuildContext context) async {
    if (!validateProfile()) {
      _errorMessage = Strings.invalidProfileMessage;
      _status = ProfileStatus.error;
      _emitState();
      return SubmitProfileResult(
        error: _errorMessage,
        appState: null,
      );
    }

    // Ensure valid token before proceeding
    if (!await _ensureValidToken()) {
      return SubmitProfileResult(
        error: _errorMessage ?? "Authentication failed",
        appState: null,
      );
    }

    _status = ProfileStatus.loading;
    _emitState();

    String formattedDate;
    try {
      DateTime parsedDate =
          DateFormat('dd-MM-yyyy').parse(_dateOfBirthController.text.trim());
      formattedDate = DateFormat('yyyy-MM-dd').format(parsedDate);
    } catch (e) {
      _errorMessage = Strings.invalidDateFormatMessage;
      _status = ProfileStatus.error;
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

    // Handle the result
    if (result.error != null) {
      _errorMessage = result.error;
      _status = ProfileStatus.error;
      _emitState();

      ScaffoldMessenger.of(context).showSnackBar(
        commonSnackBarWidget(
          content: result.error!,
          type: SnackBarType.error,
        ),
      );
    } else if (result.successMessage != null) {
      _successMessage = result.successMessage;
      _status = ProfileStatus.success;
      _emitState();

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
              bodyLarge:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.normal),
              labelLarge: TextStyle(color: Colors.white),
            ),
            buttonTheme:
                const ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      _dateOfBirthController.text = DateFormat('dd-MM-yyyy').format(picked);
      _emitState();
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
  void clearInputs() {
    _nameController.clear();
    _lastNameController.clear();
    _dateOfBirthController.clear();
    _genderController.clear();
    _errorMessage = null;
    _successMessage = null;
    _selectedMood = null;
    _selectedSleep = null;
    _selectedWorkout = null;
    _status = ProfileStatus.idle;
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
    _nameController.dispose();
    _lastNameController.dispose();
    _dateOfBirthController.dispose();
    _genderController.dispose();
    _stateController.close();
  }
}
