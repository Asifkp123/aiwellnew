import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../../core/network/error/failure.dart';
import '../../models/medicine_schedule_model.dart';

abstract class MedicineLocalDataSourceBase {
  Future<Either<Failure, List<MedicineScheduleModel>>> getSchedules();
  Future<Either<Failure, MedicineScheduleModel>> saveSchedule(
      MedicineScheduleModel schedule);
  Future<Either<Failure, MedicineScheduleModel>> updateSchedule(
      MedicineScheduleModel schedule);
  Future<Either<Failure, bool>> deleteSchedule(String id);
  Future<Either<Failure, bool>> markMedicineTaken(String id);
}

class MedicineLocalDataSource implements MedicineLocalDataSourceBase {
  static const String _schedulesKey = 'schedules';

  @override
  Future<Either<Failure, List<MedicineScheduleModel>>> getSchedules() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final schedulesJson = prefs.getString(_schedulesKey) ?? '[]';
      final List<dynamic> schedulesList = jsonDecode(schedulesJson);

      final schedules = schedulesList
          .map((json) => MedicineScheduleModel.fromJson(json))
          .toList();

      return Right(schedules);
    } catch (e) {
      return Left(Failure('Failed to load schedules: $e'));
    }
  }

  @override
  Future<Either<Failure, MedicineScheduleModel>> saveSchedule(
      MedicineScheduleModel schedule) async {
    try {
      final result = await getSchedules();
      return await result.fold(
        (failure) async => Left(failure),
        (schedules) async {
          schedules.add(schedule);
          await _saveSchedules(schedules);
          return Right(schedule);
        },
      );
    } catch (e) {
      return Left(Failure('Failed to save schedule: $e'));
    }
  }

  @override
  Future<Either<Failure, MedicineScheduleModel>> updateSchedule(
      MedicineScheduleModel schedule) async {
    try {
      final result = await getSchedules();
      return await result.fold(
        (failure) async => Left(failure),
        (schedules) async {
          final index = schedules.indexWhere((s) => s.id == schedule.id);
          if (index != -1) {
            schedules[index] = schedule;
            await _saveSchedules(schedules);
            return Right(schedule);
          } else {
            return Left(Failure('Schedule not found'));
          }
        },
      );
    } catch (e) {
      return Left(Failure('Failed to update schedule: $e'));
    }
  }

  @override
  Future<Either<Failure, bool>> deleteSchedule(String id) async {
    try {
      final result = await getSchedules();
      return await result.fold(
        (failure) async => Left(failure),
        (schedules) async {
          schedules.removeWhere((schedule) => schedule.id == id);
          await _saveSchedules(schedules);
          return Right(true);
        },
      );
    } catch (e) {
      return Left(Failure('Failed to delete schedule: $e'));
    }
  }

  @override
  Future<Either<Failure, bool>> markMedicineTaken(String id) async {
    try {
      final result = await getSchedules();
      return await result.fold(
        (failure) async => Left(failure),
        (schedules) async {
          final index = schedules.indexWhere((s) => s.id == id);
          if (index != -1) {
            schedules[index] = schedules[index].copyWith(isTaken: true);
            await _saveSchedules(schedules);
            return Right(true);
          } else {
            return Left(Failure('Schedule not found'));
          }
        },
      );
    } catch (e) {
      return Left(Failure('Failed to mark medicine as taken: $e'));
    }
  }

  Future<void> _saveSchedules(List<MedicineScheduleModel> schedules) async {
    final prefs = await SharedPreferences.getInstance();
    final schedulesJson = jsonEncode(schedules.map((s) => s.toJson()).toList());
    await prefs.setString(_schedulesKey, schedulesJson);
  }
}
