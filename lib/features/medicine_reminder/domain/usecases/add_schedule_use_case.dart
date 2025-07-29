import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import '../../../../core/network/error/failure.dart';
import '../entities/medicine_schedule.dart';
import '../repositories/medicine_repository.dart';

class AddScheduleParams {
  final String medicineName;
  final DateTime startDate;
  final DateTime endDate;
  final TimeOfDay time;

  AddScheduleParams({
    required this.medicineName,
    required this.startDate,
    required this.endDate,
    required this.time,
  });
}

abstract class AddScheduleUseCaseBase {
  Future<Either<Failure, MedicineSchedule>> execute(AddScheduleParams params);
}

class AddScheduleUseCase implements AddScheduleUseCaseBase {
  final MedicineRepository _repository;

  AddScheduleUseCase({required MedicineRepository repository})
      : _repository = repository;

  @override
  Future<Either<Failure, MedicineSchedule>> execute(
      AddScheduleParams params) async {
    // Domain validation
    if (params.medicineName.trim().isEmpty) {
      return Left(Failure('Medicine name cannot be empty'));
    }

    if (params.startDate.isAfter(params.endDate)) {
      return Left(Failure('Start date cannot be after end date'));
    }

    if (params.startDate.isBefore(DateTime.now().subtract(Duration(days: 1)))) {
      return Left(Failure('Start date cannot be in the past'));
    }

    final schedule = MedicineSchedule(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      medicineName: params.medicineName.trim(),
      startDate: params.startDate,
      endDate: params.endDate,
      time: params.time,
    );

    return await _repository.addSchedule(schedule);
  }
}
