import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../components/snackbars/custom_snackbar.dart';
import '../../domain/usecases/log_mood_use_case.dart';
import '../../domain/usecases/log_workout_use_case.dart';
import '../../domain/usecases/log_sleep_use_case.dart';
import '../../data/models/mood_option.dart';
import '../../data/models/workout_option.dart';
import '../../data/models/sleep_option.dart';
import '../../../credit/presentation/view_models/credit_view_model.dart';

enum LogsStatus { idle, loading, success, error }

class LogsState {
  final LogsStatus status;
  final String? errorMessage;
  final String? successMessage;
  final String? selectedMood;

  LogsState({
    required this.status,
    this.errorMessage,
    this.successMessage,
    this.selectedMood,
  });

  bool get isLoading => status == LogsStatus.loading;
}

abstract class LogsViewModelBase {
  Stream<LogsState> get stateStream;
  Future<bool> logMood(String mood, BuildContext context);
  Future<void> logWorkout(
      Map<String, String> workoutData, BuildContext context);
  bool isWorkoutFormValid(Map<String, String> workoutData);
  Future<void> logSleep(Map<String, String> sleepData, BuildContext context);
  bool isSleepFormValid(Map<String, String> sleepData);
  void clearMessages();
  void dispose();
}

class LogsViewModel implements LogsViewModelBase {
  final LogMoodUseCaseBase logMoodUseCase;
  final LogWorkoutUseCaseBase logWorkoutUseCase;
  final LogSleepUseCaseBase logSleepUseCase;
  final CreditViewModel? creditViewModel; // ← ADD THIS

  final StreamController<LogsState> _stateController =
      StreamController<LogsState>.broadcast();

  // ✅ Domain data belongs in ViewModel, not View!
  static const List<MoodOption> moodOptions = [
    MoodOption(name: 'Happy', emoji: '😊', color: Colors.green),
    MoodOption(name: 'Sad', emoji: '😢', color: Colors.blue),
    MoodOption(name: 'Angry', emoji: '😠', color: Colors.red),
    MoodOption(name: 'Anxious', emoji: '😰', color: Colors.orange),
    MoodOption(name: 'Calm', emoji: '😌', color: Colors.teal),
    MoodOption(name: 'Confused', emoji: '😕', color: Colors.grey),
    MoodOption(name: 'Tired', emoji: '😴', color: Colors.indigo),
    MoodOption(name: 'Excited', emoji: '🤩', color: Colors.purple),
  ];

  // ✅ Workout options for UI
  static const List<WorkoutRating> workoutRatings = [
    WorkoutRating(name: 'Excellent', intensity: 'intense', color: Colors.green),
    WorkoutRating(name: 'Good', intensity: 'moderate', color: Colors.blue),
    WorkoutRating(name: 'Average', intensity: 'moderate', color: Colors.orange),
    WorkoutRating(name: 'Poor', intensity: 'mild', color: Colors.red),
  ];

  static const List<WorkoutType> workoutTypes = [
    WorkoutType(
        name: 'Running', category: 'Cardio', icon: Icons.directions_run),
    WorkoutType(
        name: 'Cycling', category: 'Cardio', icon: Icons.directions_bike),
    WorkoutType(name: 'Swimming', category: 'Cardio', icon: Icons.pool),
    WorkoutType(
        name: 'Weight Training',
        category: 'Strength',
        icon: Icons.fitness_center),
    WorkoutType(
        name: 'Bodyweight',
        category: 'Strength',
        icon: Icons.accessibility_new),
    WorkoutType(
        name: 'Yoga', category: 'Flexibility', icon: Icons.self_improvement),
    WorkoutType(
        name: 'Stretching', category: 'Flexibility', icon: Icons.accessibility),
    WorkoutType(name: 'Dancing', category: 'Activity', icon: Icons.music_note),
  ];

  static const List<String> workoutTimes = [
    '6:00 AM',
    '7:00 AM',
    '8:00 AM',
    '9:00 AM',
    '10:00 AM',
    '12:00 PM',
    '1:00 PM',
    '2:00 PM',
    '4:00 PM',
    '6:00 PM',
    '8:00 PM'
  ];

  static const List<String> workoutDurations = [
    '30 Min',
    '45 Min',
    '1 Hr',
    '1.5 Hr',
    '2 Hr',
    '2.5 Hr',
    '3 Hr'
  ];

  // ✅ Sleep options for UI
  static const List<SleepQuality> sleepQualities = [
    SleepQuality(
        name: 'Excellent',
        value: 'excellent',
        color: Colors.green,
        icon: Icons.sentiment_very_satisfied),
    SleepQuality(
        name: 'Good',
        value: 'good',
        color: Colors.blue,
        icon: Icons.sentiment_satisfied),
    SleepQuality(
        name: 'Average',
        value: 'average',
        color: Colors.orange,
        icon: Icons.sentiment_neutral),
    SleepQuality(
        name: 'Poor',
        value: 'poor',
        color: Colors.red,
        icon: Icons.sentiment_dissatisfied),
    SleepQuality(
        name: 'Terrible',
        value: 'terrible',
        color: Colors.red,
        icon: Icons.sentiment_very_dissatisfied),
  ];

  static const List<String> sleepTimes = [
    '8:00 PM',
    '9:00 PM',
    '10:00 PM',
    '11:00 PM',
    '12:00 AM',
    '1:00 AM',
    '2:00 AM',
    '3:00 AM',
    '4:00 AM'
  ];

  static const List<String> sleepDurations = [
    '4 Hrs',
    '5 Hrs',
    '6 Hrs',
    '7 Hrs',
    '8 Hrs',
    '9 Hrs',
    '10 Hrs',
    '11 Hrs',
    '12 Hrs'
  ];

  LogsStatus _status = LogsStatus.idle;
  String? _errorMessage;
  String? _successMessage;
  String? _selectedMood;

  LogsViewModel({
    required this.logMoodUseCase,
    required this.logWorkoutUseCase,
    required this.logSleepUseCase,
    this.creditViewModel, // ← ADD THIS
  }) {
    _emitState();
  }

  @override
  Stream<LogsState> get stateStream => _stateController.stream;

  void _emitState() {
    _stateController.add(LogsState(
      status: _status,
      errorMessage: _errorMessage,
      successMessage: _successMessage,
      selectedMood: _selectedMood,
    ));
  }

  @override
  Future<bool> logMood(String mood, BuildContext context) async {
    _status = LogsStatus.loading;
    _errorMessage = null;
    _successMessage = null;
    _selectedMood = mood;
    _emitState();

    bool isSuccess = false;

    try {
      // Get current time in HH:mm format
      final now = DateTime.now();
      final timeString = DateFormat('HH:mm').format(now);

      final result = await logMoodUseCase.execute(mood, timeString);

      result.fold(
        (failure) {
          // ✅ ViewModel handles SnackBar directly - matches your existing pattern!
          ScaffoldMessenger.of(context).showSnackBar(
            commonSnackBarWidget(
              content: failure.message,
              type: SnackBarType.error,
            ),
          );

          _status = LogsStatus.error;
          _errorMessage = failure.message;
          isSuccess = false;
          print('❌ Mood logging failed: ${failure.message}');
        },
        (response) {
          // ✅ ViewModel handles SnackBar directly - matches your existing pattern!
          final successMsg = response.message.isNotEmpty
              ? response.message
              : 'Mood logged successfully! 🎉';

          ScaffoldMessenger.of(context).showSnackBar(
            commonSnackBarWidget(
              content: successMsg,
              type: SnackBarType.message,
            ),
          );

          _status = LogsStatus.success;
          _successMessage = successMsg;
          isSuccess = true;

          // Update credits using CreditViewModel
          if (response.totalCreditsAdded > 0 && creditViewModel != null) {
            creditViewModel!.addCreditsFromLog(response.totalCreditsAdded);
          }

          print('✅ Mood logged successfully: $_successMessage');
          print('💰 Credits added: ${response.totalCreditsAdded}');
        },
      );
    } catch (e) {
      // ✅ Handle unexpected errors with SnackBar
      ScaffoldMessenger.of(context).showSnackBar(
        commonSnackBarWidget(
          content: 'An unexpected error occurred',
          type: SnackBarType.error,
        ),
      );

      _status = LogsStatus.error;
      _errorMessage = 'An unexpected error occurred: $e';
      isSuccess = false;
      print('❌ Exception in logMood: $e');
    }

    _emitState();
    return isSuccess; // ✅ Return success/failure for navigation decision
  }

  @override
  bool isWorkoutFormValid(Map<String, String> workoutData) {
    return workoutData['rating']?.isNotEmpty == true &&
        workoutData['type']?.isNotEmpty == true &&
        workoutData['time']?.isNotEmpty == true &&
        workoutData['duration']?.isNotEmpty == true;
  }

  @override
  Future<void> logWorkout(
      Map<String, String> workoutData, BuildContext context) async {
    // ✅ ViewModel handles form validation
    if (!isWorkoutFormValid(workoutData)) {
      ScaffoldMessenger.of(context).showSnackBar(
        commonSnackBarWidget(
          content: 'Please fill all fields',
          type: SnackBarType.error,
        ),
      );
      return;
    }
    _status = LogsStatus.loading;
    _errorMessage = null;
    _successMessage = null;
    _emitState();

    try {
      final result = await logWorkoutUseCase.execute(
        type: workoutData['type'] ?? '',
        rating: workoutData['rating'] ?? '',
        time: workoutData['time'] ?? '',
        duration: workoutData['duration'] ?? '',
      );

      result.fold(
        (failure) {
          // ✅ ViewModel handles SnackBar directly - matches your existing pattern!
          ScaffoldMessenger.of(context).showSnackBar(
            commonSnackBarWidget(
              content: failure.message,
              type: SnackBarType.error,
            ),
          );

          _status = LogsStatus.error;
          _errorMessage = failure.message;
          print('❌ Workout logging failed: ${failure.message}');
        },
        (response) {
          // ✅ ViewModel handles SnackBar directly - matches your existing pattern!
          final successMsg = response.message.isNotEmpty
              ? response.message
              : 'Workout logged successfully! 🏋️‍♂️';

          ScaffoldMessenger.of(context).showSnackBar(
            commonSnackBarWidget(
              content: successMsg,
              type: SnackBarType.message,
            ),
          );

          _status = LogsStatus.success;
          _successMessage = successMsg;

          // Update credits using CreditViewModel
          if (response.totalCreditsAdded > 0 && creditViewModel != null) {
            creditViewModel!.addCreditsFromLog(response.totalCreditsAdded);
          }

          print('✅ Workout logged successfully: $_successMessage');
          print('💰 Credits added: ${response.totalCreditsAdded}');

          // ✅ ViewModel handles navigation on success
          Navigator.pop(context);
        },
      );
    } catch (e) {
      // ✅ Handle unexpected errors with SnackBar
      ScaffoldMessenger.of(context).showSnackBar(
        commonSnackBarWidget(
          content: 'An unexpected error occurred',
          type: SnackBarType.error,
        ),
      );

      _status = LogsStatus.error;
      _errorMessage = 'An unexpected error occurred: $e';
      print('❌ Exception in logWorkout: $e');
    }

    _emitState();
  }

  @override
  bool isSleepFormValid(Map<String, String> sleepData) {
    return sleepData['quality']?.isNotEmpty == true &&
        sleepData['startTime']?.isNotEmpty == true &&
        sleepData['duration']?.isNotEmpty == true;
  }

  @override
  Future<void> logSleep(
      Map<String, String> sleepData, BuildContext context) async {
    // ✅ ViewModel handles form validation
    if (!isSleepFormValid(sleepData)) {
      ScaffoldMessenger.of(context).showSnackBar(
        commonSnackBarWidget(
          content: 'Please fill all fields',
          type: SnackBarType.error,
        ),
      );
      return;
    }

    _status = LogsStatus.loading;
    _errorMessage = null;
    _successMessage = null;
    _emitState();

    try {
      final result = await logSleepUseCase.execute(
        quality: sleepData['quality'] ?? '',
        startTime: sleepData['startTime'] ?? '',
        duration: sleepData['duration'] ?? '',
      );

      result.fold(
        (failure) {
          // ✅ ViewModel handles SnackBar directly - matches your existing pattern!
          ScaffoldMessenger.of(context).showSnackBar(
            commonSnackBarWidget(
              content: failure.message,
              type: SnackBarType.error,
            ),
          );

          _status = LogsStatus.error;
          _errorMessage = failure.message;
          print('❌ Sleep logging failed: ${failure.message}');
        },
        (response) {
          // ✅ ViewModel handles SnackBar directly - matches your existing pattern!
          final successMsg = response.message.isNotEmpty
              ? response.message
              : 'Sleep logged successfully! 😴';

          ScaffoldMessenger.of(context).showSnackBar(
            commonSnackBarWidget(
              content: successMsg,
              type: SnackBarType.message,
            ),
          );

          _status = LogsStatus.success;
          _successMessage = successMsg;

          // Update credits using CreditViewModel
          if (response.totalCreditsAdded > 0 && creditViewModel != null) {
            creditViewModel!.addCreditsFromLog(response.totalCreditsAdded);
          }

          print('✅ Sleep logged successfully: $_successMessage');
          print('💰 Credits added: ${response.totalCreditsAdded}');

          // ✅ ViewModel handles navigation on success
          Navigator.pop(context);
        },
      );
    } catch (e) {
      // ✅ Handle unexpected errors with SnackBar
      ScaffoldMessenger.of(context).showSnackBar(
        commonSnackBarWidget(
          content: 'An unexpected error occurred',
          type: SnackBarType.error,
        ),
      );

      _status = LogsStatus.error;
      _errorMessage = 'An unexpected error occurred: $e';
      print('❌ Exception in logSleep: $e');
    }

    _emitState();
  }

  @override
  void clearMessages() {
    _errorMessage = null;
    _successMessage = null;
    _status = LogsStatus.idle;
    _emitState();
  }

  @override
  void dispose() {
    _stateController.close();
  }

  // Getter methods for easy access
  String? get selectedMood => _selectedMood;
  String? get errorMessage => _errorMessage;
  String? get successMessage => _successMessage;
  LogsStatus get status => _status;
}
