import 'dart:async';
import 'dart:convert';
import 'package:aiwel/features/auth/presentation/screens/signin_signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/services/token_manager.dart';
import '../../../auth/domain/usecases/get_access_token_use_case.dart';
import '../../../auth/domain/usecases/refresh_token_use_case.dart';
import '../../../../core/constants/strings.dart';
import '../../../../core/network/error/failure.dart';
import '../../domain/usecases/create_pal_use_case.dart';
import '../../data/models/api/create_pal_request.dart';
import '../screens/add_pal_completion_congrats_screen.dart';
import '../../../../components/snackbars/custom_snackbar.dart';

enum AddPalStateStatus { idle, loading, success, error }

class AddPalState {
  final AddPalStateStatus status;
  final String? name;
  final String? lastName;
  final DateTime? dob;
  final String? selectedAbleToWalk;
  final String? gender;
  final String? primary_diagnosis;
  final String? errorMessage;
  final String? successMessage;
  final bool? can_walk;
  final bool? needs_walking_aid;
  final bool? is_bedridden;
  final bool? has_dementia;
  final bool? is_agitated;
  final bool? is_depressed;
  final String? dominant_emotion;
  final String? sleep_pattern;
  final String? sleep_quality;
  final String? pain_status;
  final TextEditingController? primaryDiagnosisController;

  AddPalState({
    required this.status,
    this.name,
    this.lastName,
    this.dob,
    this.selectedAbleToWalk,
    this.gender,
    this.primary_diagnosis,
    this.errorMessage,
    this.successMessage,
    this.can_walk,
    this.needs_walking_aid,
    this.is_bedridden,
    this.has_dementia,
    this.is_agitated,
    this.is_depressed,
    this.dominant_emotion,
    this.sleep_pattern,
    this.sleep_quality,
    this.pain_status,
    this.primaryDiagnosisController,
  });

  AddPalState copyWith({
    AddPalStateStatus? status,
    String? name,
    String? lastName,
    DateTime? dob,
    String? selectedAbleToWalk,
    String? gender,
    String? primary_diagnosis,
    String? errorMessage,
    String? successMessage,
    bool? can_walk,
    bool? needs_walking_aid,
    bool? is_bedridden,
    bool? has_dementia,
    bool? is_agitated,
    bool? is_depressed,
    String? dominant_emotion,
    String? sleep_pattern,
    String? sleep_quality,
    String? pain_status,
  }) {
    return AddPalState(
      status: status ?? this.status,
      name: name ?? this.name,
      lastName: lastName ?? this.lastName,
      dob: dob ?? this.dob,
      selectedAbleToWalk: selectedAbleToWalk ?? this.selectedAbleToWalk,
      gender: gender ?? this.gender,
      primary_diagnosis: primary_diagnosis ?? this.primary_diagnosis,
      errorMessage: errorMessage ?? this.errorMessage,
      successMessage: successMessage ?? this.successMessage,
      can_walk: can_walk ?? this.can_walk,
      needs_walking_aid: needs_walking_aid ?? this.needs_walking_aid,
      is_bedridden: is_bedridden ?? this.is_bedridden,
      has_dementia: has_dementia ?? this.has_dementia,
      is_agitated: is_agitated ?? this.is_agitated,
      is_depressed: is_depressed ?? this.is_depressed,
      dominant_emotion: dominant_emotion ?? this.dominant_emotion,
      sleep_pattern: sleep_pattern ?? this.sleep_pattern,
      sleep_quality: sleep_quality ?? this.sleep_quality,
      pain_status: pain_status ?? this.pain_status,
    );
  }

  @override
  String toString() {
    return 'AddPalState(status: $status, name: $name, lastName: $lastName, gender: $gender, can_walk: $can_walk, '
        'needs_walking_aid: $needs_walking_aid, is_bedridden: $is_bedridden, has_dementia: $has_dementia, '
        'is_agitated: $is_agitated, is_depressed: $is_depressed, dominant_emotion: $dominant_emotion, '
        'sleep_pattern: $sleep_pattern, sleep_quality: $sleep_quality, pain_status: $pain_status, '
        'errorMessage: $errorMessage)';
  }
}

abstract class AddViewModelBase {
  List<String> get yesOrNoList;
  List<String> get addPalMoodList;
  List<String> get sleepPatternList;
  List<String> get sleepBeenList;
  List<String> get discomfortList;
  Stream<AddPalState> get stateStream;
  TextEditingController get emailController;
  TextEditingController get otpController;
  TextEditingController get nameController;
  TextEditingController get lastNameController;
  TextEditingController get dateOfBirthController;
  TextEditingController get genderController;
  TextEditingController get primaryDiagnosisController;
  void yesOrNoSelected(String value);
  void clearError();
  void selectDate(BuildContext context);
  void setNeedsWalkingAid(String value);
  void setIsBedridden(String value);
  void setHasDementia(String value);
  void setIsAgitated(String value);
  void setIsDepressed(String value);
  void setDominantEmotion(String value);
  void setSleepPattern(String value);
  void setSleepQuality(String value);
  void setPainStatus(String value);
  void updateStateWithControllers();
  Future<void> submitPalData(BuildContext context);
}

class AddPalViewModel extends AddViewModelBase {
  final TokenManager tokenManager;
  final CreatePalUseCase createPalUseCase;
  final GetAccessTokenUseCase getAccessTokenUseCase;
  final RefreshTokenUseCase refreshTokenUseCase;

  AddPalViewModel({
    required this.tokenManager,
    required this.createPalUseCase,
    required this.getAccessTokenUseCase,
    required this.refreshTokenUseCase,
  }) {
    // Initialize default state
    _currentState = AddPalState(
      status: AddPalStateStatus.idle,
      can_walk: null, // ✅ No auto-selection
      needs_walking_aid: null, // ✅ No auto-selection
      is_bedridden: null, // ✅ No auto-selection
      has_dementia: null, // ✅ No auto-selection
      is_agitated: null, // ✅ No auto-selection
      is_depressed: null, // ✅ No auto-selection
      dominant_emotion: null,
      sleep_pattern: null,
      sleep_quality: null,
      pain_status: null,
    );
    _stateController.add(_currentState);
  }

  String? _authToken;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _dateOfBirthController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _primaryDiagnosisController =
      TextEditingController();

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
  TextEditingController get primaryDiagnosisController =>
      _primaryDiagnosisController;

  final List<String> _yesOrNoList = ['Yes', 'No'];
  final List<String> _addPalMoodList = [
    "Happy",
    "Sad",
    "Angry",
    "Anxious",
    "Calm",
    "Tired",
    "Confused",
    "Excited",
    "Scared",
    "Neutral"
  ];
  final List<String> _sleepPatternList = [
    "Uninterrupted",
    "Fragmented",
    "Delayed",
    "Early Awakening",
    "Oversleeping",
    "Irregular",
    "No sleep"
  ];
  final List<String> _sleepBeenList = ["Excellent", "Good", "Fair", "Poor"];
  final List<String> _discomfortList = [
    "No Pain",
    "Mild",
    "Moderate",
    "Severe",
    "Very Severe",
    "Worst Possible",
    "Unknown"
  ];

  @override
  List<String> get yesOrNoList => _yesOrNoList;
  @override
  List<String> get addPalMoodList => _addPalMoodList;
  @override
  List<String> get sleepPatternList => _sleepPatternList;
  @override
  List<String> get sleepBeenList => _sleepBeenList;
  @override
  List<String> get discomfortList => _discomfortList;

  final StreamController<AddPalState> _stateController =
      StreamController<AddPalState>.broadcast();
  AddPalState _currentState = AddPalState(status: AddPalStateStatus.idle);

  @override
  Stream<AddPalState> get stateStream => _stateController.stream;

  void _updateState(AddPalState newState) {
    _currentState = newState;
    _stateController.add(newState);
    print('State Updated: $newState');
  }

  @override
  void yesOrNoSelected(String value) {
    _updateStateWithControllers(
      can_walk: value == 'Yes',
      selectedAbleToWalk: value,
    );
  }

  @override
  void setDominantEmotion(String value) {
    _updateStateWithControllers(dominant_emotion: value);
  }

  @override
  void setNeedsWalkingAid(String value) {
    _updateStateWithControllers(needs_walking_aid: value == 'Yes');
  }

  @override
  void setIsBedridden(String value) {
    _updateStateWithControllers(is_bedridden: value == 'Yes');
  }

  @override
  void setHasDementia(String value) {
    _updateStateWithControllers(has_dementia: value == 'Yes');
  }

  @override
  void setIsAgitated(String value) {
    _updateStateWithControllers(is_agitated: value == 'Yes');
  }

  @override
  void setIsDepressed(String value) {
    _updateStateWithControllers(is_depressed: value == 'Yes');
  }

  @override
  void setSleepPattern(String value) {
    _updateStateWithControllers(sleep_pattern: value);
  }

  @override
  void setSleepQuality(String value) {
    _updateStateWithControllers(sleep_quality: value);
  }

  @override
  void setPainStatus(String value) {
    _updateStateWithControllers(pain_status: value);
  }

  @override
  void clearError() {
    _updateStateWithControllers(errorMessage: null);
  }

  void resetStateStatus() {
    _updateStateWithControllers(status: AddPalStateStatus.idle);
  }

  @override
  void updateStateWithControllers() {
    _updateStateWithControllers();
  }

  void _updateStateWithControllers({
    AddPalStateStatus? status,
    String? selectedAbleToWalk,
    bool? can_walk,
    bool? needs_walking_aid,
    bool? is_bedridden,
    bool? has_dementia,
    bool? is_agitated,
    bool? is_depressed,
    String? dominant_emotion,
    String? sleep_pattern,
    String? sleep_quality,
    String? pain_status,
    String? errorMessage,
    String? successMessage,
  }) {
    print('_updateStateWithControllers called');
    print('_nameController.text: "${_nameController.text}"');
    print('_genderController.text: "${_genderController.text}"');
    print('DEBUG: errorMessage parameter: $errorMessage');

    _updateState(AddPalState(
      status: status ?? _currentState.status,
      name: _nameController.text.isNotEmpty ? _nameController.text : null,
      lastName:
          _lastNameController.text.isNotEmpty ? _lastNameController.text : null,
      selectedAbleToWalk:
          selectedAbleToWalk ?? _currentState.selectedAbleToWalk,
      gender: _genderController.text.isNotEmpty ? _genderController.text : null,
      errorMessage: errorMessage ?? _currentState.errorMessage,
      successMessage: successMessage ?? _currentState.successMessage,
      can_walk: can_walk ?? _currentState.can_walk,
      needs_walking_aid: needs_walking_aid ?? _currentState.needs_walking_aid,
      is_bedridden: is_bedridden ?? _currentState.is_bedridden,
      has_dementia: has_dementia ?? _currentState.has_dementia,
      is_agitated: is_agitated ?? _currentState.is_agitated,
      is_depressed: is_depressed ?? _currentState.is_depressed,
      dominant_emotion: dominant_emotion ?? _currentState.dominant_emotion,
      sleep_pattern: sleep_pattern ?? _currentState.sleep_pattern,
      sleep_quality: sleep_quality ?? _currentState.sleep_quality,
      pain_status: pain_status ?? _currentState.pain_status,
    ));
  }

  @override
  void selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) => Theme(
        data: ThemeData.light().copyWith(
          primaryColor: Colors.purple,
          colorScheme: const ColorScheme.light(
              primary: Colors.purple, onPrimary: Colors.white),
          textTheme: const TextTheme(
            bodyLarge:
                TextStyle(color: Colors.black, fontWeight: FontWeight.normal),
            labelLarge: TextStyle(color: Colors.white),
          ),
          buttonTheme:
              const ButtonThemeData(textTheme: ButtonTextTheme.primary),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      _dateOfBirthController.text = DateFormat('dd-MM-yyyy').format(picked);
      _updateStateWithControllers();
    }
  }

  AddPalState getCurrentStateWithControllers() {
    return _currentState.copyWith(
      name: _nameController.text.isNotEmpty ? _nameController.text : null,
      lastName:
          _lastNameController.text.isNotEmpty ? _lastNameController.text : null,
      gender: _genderController.text.isNotEmpty ? _genderController.text : null,
    );
  }

  Future<void> _initializeAuthToken() async {
    try {
      final accessToken = await tokenManager.getAccessToken();
      final expiry = await tokenManager.getAccessTokenExpiry();
      final currentTime = DateTime.now().millisecondsSinceEpoch ~/ 1000;

      if (accessToken != null && expiry != null && currentTime < expiry) {
        _authToken = accessToken;
      } else {
        _updateStateWithControllers(
          errorMessage: 'Access token invalid or expired. Please log in again.',
          status: AddPalStateStatus.error,
        );
        await tokenManager.clearTokens();
      }
    } catch (e) {
      _updateStateWithControllers(
        errorMessage: 'Failed to retrieve access token: $e',
        status: AddPalStateStatus.error,
      );
    }
  }

  Future<bool> _ensureValidToken() async {
    print("🔍 _ensureValidToken called");

    final tokenResult = await getAccessTokenUseCase.execute();
    return tokenResult.fold(
      (failure) async {
        print("❌ Token validation failed: ${failure.message}");
        // Try to refresh token if access token is expired
        print("🔄 Attempting token refresh...");
        final refreshResult = await refreshTokenUseCase.execute();
        return refreshResult.fold(
          (refreshFailure) async {
            print("❌ Token refresh failed: ${refreshFailure.message}");
            _updateStateWithControllers(
              errorMessage: 'Session expired. Please sign in again.',
              status: AddPalStateStatus.error,
            );
            await _logout();
            return false;
          },
          (refreshSuccess) async {
            print("✅ Token refresh successful: $refreshSuccess");
            if (refreshSuccess) {
              // Get the new token after refresh
              print("🔄 Getting new token after refresh...");
              final newTokenResult = await getAccessTokenUseCase.execute();
              return newTokenResult.fold(
                (newFailure) async {
                  print("❌ Failed to get new token: ${newFailure.message}");
                  _updateStateWithControllers(
                    errorMessage: 'Session expired. Please sign in again.',
                    status: AddPalStateStatus.error,
                  );
                  await _logout();
                  return false;
                },
                (newTokenData) async {
                  final newAccessToken = newTokenData.$1;
                  print(
                      "🔑 New access token: ${newAccessToken != null ? 'Present' : 'Null'}");
                  if (newAccessToken == null) {
                    print("❌ New access token is null");
                    _updateStateWithControllers(
                      errorMessage: 'Session expired. Please sign in again.',
                      status: AddPalStateStatus.error,
                    );
                    await _logout();
                    return false;
                  }
                  _authToken = newAccessToken;
                  print("✅ Token validation successful after refresh");
                  return true;
                },
              );
            }
            print("❌ Token refresh returned false");
            return false;
          },
        );
      },
      (tokenData) async {
        final accessToken = tokenData.$1;
        print("🔑 Access token: ${accessToken != null ? 'Present' : 'Null'}");
        if (accessToken == null) {
          print("❌ Access token is null");
          _updateStateWithControllers(
            errorMessage: 'Session expired. Please sign in again.',
            status: AddPalStateStatus.error,
          );
          await _logout();
          return false;
        }
        _authToken = accessToken;
        print("✅ Token validation successful");
        return true;
      },
    );
  }

  Future<void> _logout() async {
    await tokenManager.clearTokens();
    _authToken = null;
    _updateStateWithControllers(
      errorMessage: 'Session expired. Please sign in again.',
      status: AddPalStateStatus.error,
    );
  }

  @override
  Future<void> submitPalData(BuildContext context) async {
    try {
      final currentState = getCurrentStateWithControllers();
      print('Submitting PAL data: $currentState');

      // Check for missing fields first
      final missingFields = _getMissingFields(currentState);
      if (missingFields.isNotEmpty) {
        print('Missing fields: ${missingFields.join(', ')}');
        ScaffoldMessenger.of(context).showSnackBar(
          commonSnackBarWidget(
            content: 'Please complete: ${missingFields.join(', ')}',
            type: SnackBarType.error,
          ),
        );
        return;
      }

      // Validate required fields
      if (!_validateRequiredFields(currentState)) {
        return;
      }

      _updateStateWithControllers(status: AddPalStateStatus.loading);

      // Format date
      final formattedDate = _formatDate(_dateOfBirthController.text.trim());
      if (formattedDate == null) {
        _showError('Invalid date format. Please use DD-MM-YYYY format.');
        return;
      }

      // Create request object
      final request = CreatePalRequest(
        firstName: currentState.name?.trim() ?? '',
        lastName: currentState.lastName?.trim() ?? '',
        dob: formattedDate,
        gender: currentState.gender!,
        primaryDiagnosis: _primaryDiagnosisController.text.isNotEmpty
            ? _primaryDiagnosisController.text
            : null,
        canWalk: currentState.can_walk,
        needsWalkingAid: currentState.needs_walking_aid,
        isBedridden: currentState.is_bedridden,
        hasDementia: currentState.has_dementia,
        isAgitated: currentState.is_agitated,
        isDepressed: currentState.is_depressed,
        dominantEmotion: _mapEnum(currentState.dominant_emotion, _emotionMap),
        sleepPattern: _mapEnum(currentState.sleep_pattern, _sleepPatternMap),
        sleepQuality: _mapEnum(currentState.sleep_quality, _sleepQualityMap),
        painStatus: _mapEnum(currentState.pain_status, _painStatusMap),
      );

      print('Request payload: ${request.toJson()}');

      final result = await createPalUseCase.execute(request);
      result.fold(
        (errorMessage) {
          // Show ERROR snackbar
          ScaffoldMessenger.of(context).showSnackBar(
            commonSnackBarWidget(
              content: errorMessage,
              type: SnackBarType.error,
            ),
          );
          _updateStateWithControllers(
            status: AddPalStateStatus.error,
            errorMessage: errorMessage,
          );
        },
        (successMessage) {
          print('PAL created successfully: $successMessage');

          _updateStateWithControllers(
            status: AddPalStateStatus.success,
            successMessage: successMessage,
          );

          // Navigate to AddPalCompletionCongratsScreen on success
          Future.delayed(const Duration(milliseconds: 500), () {
            if (context.mounted) {
              Navigator.pushNamed(
                context,
                AddPalCompletionCongratsScreen.routeName,
                arguments: {'viewModelBase': this},
              );
            }
          });
        },
      );
    } catch (e) {
      final errorMessage = _getErrorMessage(e);

      // Show ERROR snackbar for exceptions
      ScaffoldMessenger.of(context).showSnackBar(
        commonSnackBarWidget(
          content: errorMessage,
          type: SnackBarType.error,
        ),
      );

      _updateStateWithControllers(
        status: AddPalStateStatus.error,
        errorMessage: errorMessage,
      );
    }
  }

  // Helper method to check for missing fields
  List<String> _getMissingFields(AddPalState state) {
    List<String> missingFields = [];

    if (state.name?.trim().isEmpty ?? true || state.name == null) {
      missingFields.add('First Name');
    }
    if (state.lastName?.trim().isEmpty ?? true || state.lastName == null) {
      missingFields.add('Last Name');
    }
    if (state.gender?.trim().isEmpty ?? true || state.gender == null) {
      missingFields.add('Gender');
    }
    if (_dateOfBirthController.text.trim().isEmpty) {
      missingFields.add('Date of Birth');
    }

    return missingFields;
  }

  bool _validateRequiredFields(AddPalState state) {
    if (state.name?.trim().isEmpty ??
        true ??
        true || state.gender!.isEmpty ??
        true || _dateOfBirthController.text.trim().isEmpty) {
      _showError(
          'First name, last name, gender, and date of birth are required.');
      return false;
    }
    return true;
  }

  String? _formatDate(String date) {
    try {
      final parsedDate = DateFormat('dd-MM-yyyy').parse(date);
      return DateFormat('yyyy-MM-dd').format(parsedDate);
    } catch (e) {
      return null;
    }
  }

  String? _mapEnum(String? value, Map<String, String> mapping) {
    return value != null ? mapping[value] ?? value.toLowerCase() : null;
  }

  void _showError(String message) {
    _updateStateWithControllers(
      errorMessage: message,
      status: AddPalStateStatus.error,
    );
  }

  String _getErrorMessage(dynamic e) {
    if (e is http.Response) {
      try {
        final errorJson = jsonDecode(e.body);
        return errorJson['detail']?.toString() ?? 'An error occurred.';
      } catch (_) {}
    }
    return e is TypeError || e is NoSuchMethodError
        ? e.toString()
        : 'An error occurred. Please try again later.';
  }

  final _emotionMap = {
    'Happy': 'happy',
    'Sad': 'sad',
    'Angry': 'angry',
    'Anxious': 'anxious',
    'Calm': 'calm',
    'Confused': 'confused',
    'Tired': 'tired',
    'Excited': 'excited',
    'Scared': 'scared',
    'Neutral': 'neutral',
  };

  final _sleepPatternMap = {
    'Uninterrupted': 'uninterrupted',
    'Fragmented': 'fragmented',
    'Delayed': 'delayed_onset',
    'Early Awakening': 'early_awakening',
    'Oversleeping': 'oversleeping',
    'Irregular': 'irregular',
    'No sleep': 'no_sleep',
  };

  final _sleepQualityMap = {
    'Excellent': 'excellent',
    'Good': 'good',
    'Fair': 'fair',
    'Poor': 'poor',
  };

  final _painStatusMap = {
    'No Pain': 'no_pain',
    'Mild': 'mild',
    'Moderate': 'moderate',
    'Severe': 'severe',
    'Very Severe': 'very_severe',
    'Worst Possible': 'worst_possible',
    'Unknown': 'unknown',
  };
}
