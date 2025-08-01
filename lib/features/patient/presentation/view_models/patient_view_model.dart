import 'dart:async';
import 'package:flutter/material.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/network/error/failure.dart';
import '../../domain/entities/patient.dart';
import '../../domain/usecases/get_patients_use_case.dart';

enum PatientStateStatus { idle, loading, success, error }

class PatientState {
  final PatientStateStatus status;
  final List<Patient> patients;
  final String? errorMessage;

  PatientState({
    required this.status,
    this.patients = const [],
    this.errorMessage,
  });

  PatientState copyWith({
    PatientStateStatus? status,
    List<Patient>? patients,
    String? errorMessage,
  }) {
    return PatientState(
      status: status ?? this.status,
      patients: patients ?? this.patients,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  String toString() {
    return 'PatientState(status: $status, patients: ${patients.length}, errorMessage: $errorMessage)';
  }
}

class PatientViewModel {
  final GetPatientsUseCase getPatientsUseCase;

  PatientViewModel({required this.getPatientsUseCase}) {
    _currentState = PatientState(status: PatientStateStatus.idle);
    _stateController.add(_currentState);
  }

  final StreamController<PatientState> _stateController =
      StreamController<PatientState>.broadcast();
  PatientState _currentState = PatientState(status: PatientStateStatus.idle);

  Stream<PatientState> get stateStream => _stateController.stream;

  void _updateState(PatientState newState) {
    _currentState = newState;
    _stateController.add(newState);
    print('PatientViewModel State Updated: $newState');
  }

  Future<void> loadPatients() async {
    print("🏥 Loading patients...");
    try {
      _updateState(_currentState.copyWith(status: PatientStateStatus.loading));

      final result = await getPatientsUseCase.execute();
      result.fold(
        (failure) {
          _updateState(_currentState.copyWith(
            status: PatientStateStatus.error,
            errorMessage: failure.message,
          ));
        },
        (patients) {
          _updateState(_currentState.copyWith(
            status: PatientStateStatus.success,
            patients: patients,
            errorMessage: null,
          ));
        },
      );
    } catch (e) {
      _updateState(_currentState.copyWith(
        status: PatientStateStatus.error,
        errorMessage: 'An unexpected error occurred: $e',
      ));
    }
  }

  void clearError() {
    _updateState(_currentState.copyWith(errorMessage: null));
  }

  void dispose() {
    _stateController.close();
  }
}
