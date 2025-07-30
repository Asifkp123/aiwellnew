import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/network/error/failure.dart';
import '../../domain/entities/medicine_schedule.dart';
import '../../domain/usecases/add_schedule_use_case.dart';
import '../../domain/usecases/get_schedules_use_case.dart';
import '../../domain/usecases/mark_medicine_taken_use_case.dart';

enum MedicineReminderStatus { idle, loading, success, error }

class MedicineReminderState {
  final MedicineReminderStatus status;
  final List<MedicineSchedule> schedules;
  final String? errorMessage;
  final bool isLoading;

  MedicineReminderState({
    required this.status,
    required this.schedules,
    this.errorMessage,
    required this.isLoading,
  });

  MedicineReminderState copyWith({
    MedicineReminderStatus? status,
    List<MedicineSchedule>? schedules,
    String? errorMessage,
    bool? isLoading,
  }) {
    return MedicineReminderState(
      status: status ?? this.status,
      schedules: schedules ?? this.schedules,
      errorMessage: errorMessage,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

abstract class MedicineReminderViewModelBase {
  Stream<MedicineReminderState> get stateStream;
  TextEditingController get medicineController;
  DateTime? get startDate;
  DateTime? get endDate;
  TimeOfDay? get selectedTime;

  Future<void> loadSchedules();
  Future<void> addSchedule();
  Future<void> markMedicineTaken(String id);
  Future<void> selectStartDate(BuildContext context);
  Future<void> selectEndDate(BuildContext context);
  Future<void> selectTime(BuildContext context);
  void clearInputs();
  void dispose();
}

class MedicineReminderViewModel implements MedicineReminderViewModelBase {
  final GetSchedulesUseCaseBase _getSchedulesUseCase;
  final AddScheduleUseCaseBase _addScheduleUseCase;
  final MarkMedicineTakenUseCaseBase _markMedicineTakenUseCase;

  final StreamController<MedicineReminderState> _stateController =
      StreamController<MedicineReminderState>.broadcast();
  final MethodChannel _channel = MethodChannel('com.qurig.aiwel/notifications');

  final TextEditingController _medicineController = TextEditingController();
  DateTime? _startDate;
  DateTime? _endDate;
  TimeOfDay? _selectedTime;

  MedicineReminderViewModel({
    required GetSchedulesUseCaseBase getSchedulesUseCase,
    required AddScheduleUseCaseBase addScheduleUseCase,
    required MarkMedicineTakenUseCaseBase markMedicineTakenUseCase,
  })  : _getSchedulesUseCase = getSchedulesUseCase,
        _addScheduleUseCase = addScheduleUseCase,
        _markMedicineTakenUseCase = markMedicineTakenUseCase {
    _initializeMethodChannel();
  }

  void _initializeMethodChannel() {
    print('Initializing method channel: $_channel');
    _channel.setMethodCallHandler((call) async {
      print('Received method call: ${call.method}');
      if (call.method == 'markMedicineTaken') {
        final String id = call.arguments['id'];
        await markMedicineTaken(id);
        await loadSchedules(); // Reload schedules after marking as taken
      }
    });

    // Test the method channel
    _testMethodChannel();
  }

  Future<void> _testMethodChannel() async {
    try {
      print('Testing method channel...');
      final result = await _channel.invokeMethod('test');
      print('Test method channel result: $result');
      if (result == 'Test successful') {
        print('✅ Method channel is working correctly!');
      } else {
        print('❌ Method channel returned unexpected result: $result');
      }
    } catch (e) {
      print('❌ Test method channel error: $e');
      print('This means the method channel is not set up properly.');
    }
  }

  @override
  Stream<MedicineReminderState> get stateStream => _stateController.stream;

  @override
  TextEditingController get medicineController => _medicineController;

  @override
  DateTime? get startDate => _startDate;

  @override
  DateTime? get endDate => _endDate;

  @override
  TimeOfDay? get selectedTime => _selectedTime;

  void _emitState(MedicineReminderState state) {
    _stateController.add(state);
  }

  @override
  Future<void> loadSchedules() async {
    _emitState(MedicineReminderState(
      status: MedicineReminderStatus.loading,
      schedules: [],
      isLoading: true,
    ));

    final result = await _getSchedulesUseCase.execute();
    result.fold(
      (failure) {
        _emitState(MedicineReminderState(
          status: MedicineReminderStatus.error,
          schedules: [],
          errorMessage: failure.message,
          isLoading: false,
        ));
      },
      (schedules) {
        _emitState(MedicineReminderState(
          status: MedicineReminderStatus.success,
          schedules: schedules,
          isLoading: false,
        ));
      },
    );
  }

  @override
  Future<void> addSchedule() async {
    if (_medicineController.text.trim().isEmpty ||
        _startDate == null ||
        _endDate == null ||
        _selectedTime == null) {
      _emitState(MedicineReminderState(
        status: MedicineReminderStatus.error,
        schedules: [],
        errorMessage: 'Please fill all fields',
        isLoading: false,
      ));
      return;
    }

    _emitState(MedicineReminderState(
      status: MedicineReminderStatus.loading,
      schedules: [],
      isLoading: true,
    ));

    final id = DateTime.now().millisecondsSinceEpoch.toString();
    // Combine startDate with the selected time
    final scheduledDateTime = DateTime(
      _startDate!.year,
      _startDate!.month,
      _startDate!.day,
      _selectedTime!.hour,
      _selectedTime!.minute,
    );

    final params = AddScheduleParams(
      medicineName: _medicineController.text.trim(),
      startDate: _startDate!,
      endDate: _endDate!,
      time: _selectedTime!,
    );

    final result = await _addScheduleUseCase.execute(params);
    result.fold(
      (failure) {
        _emitState(MedicineReminderState(
          status: MedicineReminderStatus.error,
          schedules: [],
          errorMessage: failure.message,
          isLoading: false,
        ));
      },
      (schedule) async {
        // Schedule notification via platform channel
        try {
          print('Scheduling notification at: $scheduledDateTime');
          print('Method channel: $_channel');
          print('Calling scheduleNotification with arguments: ${{
            'id': id,
            'medicine': _medicineController.text.trim(),
            'startDate': scheduledDateTime.toIso8601String(),
            'endDate': _endDate!.toIso8601String(),
            'hour': _selectedTime!.hour,
            'minute': _selectedTime!.minute,
          }}');

          // Add a small delay to ensure the method channel is ready
          await Future.delayed(Duration(milliseconds: 100));

          await _channel.invokeMethod('scheduleNotification', {
            'id': id,
            'medicine': _medicineController.text.trim(),
            'startDate': '${_startDate!.year}-${_startDate!.month.toString().padLeft(2, '0')}-${_startDate!.day.toString().padLeft(2, '0')}T${_selectedTime!.hour.toString().padLeft(2, '0')}:${_selectedTime!.minute.toString().padLeft(2, '0')}:00',
            'endDate': '${_endDate!.year}-${_endDate!.month.toString().padLeft(2, '0')}-${_endDate!.day.toString().padLeft(2, '0')}T23:59:59',
            'hour': _selectedTime!.hour,
            'minute': _selectedTime!.minute,
          });

          print('Successfully scheduled notification');
          await loadSchedules(); // Reload schedules
        } catch (e) {
          print('Error scheduling notification: $e');
          _emitState(MedicineReminderState(
            status: MedicineReminderStatus.error,
            schedules: [],
            errorMessage: 'Failed to schedule notification: $e',
            isLoading: false,
          ));
        }
      },
    );
  }

  @override
  Future<void> markMedicineTaken(String id) async {
    final params = MarkMedicineTakenParams(id: id);
    final result = await _markMedicineTakenUseCase.execute(params);

    result.fold(
      (failure) {
        _emitState(MedicineReminderState(
          status: MedicineReminderStatus.error,
          schedules: [],
          errorMessage: failure.message,
          isLoading: false,
        ));
      },
      (success) async {
        await loadSchedules(); // Reload schedules
      },
    );
  }

  @override
  Future<void> selectStartDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      _startDate = picked;
      _emitState(MedicineReminderState(
        status: MedicineReminderStatus.idle,
        schedules: [],
        isLoading: false,
      ));
    }
  }

  @override
  Future<void> selectEndDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _startDate ?? DateTime.now(),
      firstDate: _startDate ?? DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      _endDate = picked;
      _emitState(MedicineReminderState(
        status: MedicineReminderStatus.idle,
        schedules: [],
        isLoading: false,
      ));
    }
  }

  @override
  Future<void> selectTime(BuildContext context) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      _selectedTime = picked;
      _emitState(MedicineReminderState(
        status: MedicineReminderStatus.idle,
        schedules: [],
        isLoading: false,
      ));
    }
  }

  @override
  void clearInputs() {
    _medicineController.clear();
    _startDate = null;
    _endDate = null;
    _selectedTime = null;
    _emitState(MedicineReminderState(
      status: MedicineReminderStatus.idle,
      schedules: [],
      isLoading: false,
    ));
  }

  @override
  void dispose() {
    _medicineController.dispose();
    _stateController.close();
  }
}
