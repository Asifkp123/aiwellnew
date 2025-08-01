import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/managers/credit_manager.dart';
import '../../../../components/snackbars/custom_snackbar.dart';
import '../../domain/usecases/log_mood_use_case.dart';
import '../../data/models/mood_option.dart';

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
  Future<bool> logMood(String mood,
      BuildContext context); // ✅ Return success/failure for navigation
  void clearMessages();
  void dispose();
}

class LogsViewModel implements LogsViewModelBase {
  final LogMoodUseCaseBase logMoodUseCase;
  final CreditManager creditManager;

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

  LogsStatus _status = LogsStatus.idle;
  String? _errorMessage;
  String? _successMessage;
  String? _selectedMood;

  LogsViewModel({
    required this.logMoodUseCase,
    CreditManager? creditManager,
  }) : creditManager = creditManager ?? CreditManager.instance {
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

          // Update credits using the credit manager
          if (response.totalCreditsAdded > 0) {
            creditManager.addCredits(response.totalCreditsAdded);
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
