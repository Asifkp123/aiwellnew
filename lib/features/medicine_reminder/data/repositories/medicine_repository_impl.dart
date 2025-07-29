import 'package:dartz/dartz.dart';
import '../../../../core/network/error/failure.dart';
import '../../domain/entities/medicine_schedule.dart';
import '../../domain/repositories/medicine_repository.dart';
import '../datasources/local/medicine_local_datasource.dart';
import '../models/medicine_schedule_model.dart';

class MedicineRepositoryImpl implements MedicineRepository {
  final MedicineLocalDataSourceBase _localDataSource;

  MedicineRepositoryImpl({required MedicineLocalDataSourceBase localDataSource})
      : _localDataSource = localDataSource;

  @override
  Future<Either<Failure, List<MedicineSchedule>>> getSchedules() async {
    final result = await _localDataSource.getSchedules();
    return result.fold(
      (failure) => Left(failure),
      (models) => Right(models.map((model) => model.toEntity()).toList()),
    );
  }

  @override
  Future<Either<Failure, MedicineSchedule>> addSchedule(
      MedicineSchedule schedule) async {
    final model = MedicineScheduleModel.fromEntity(schedule);
    final result = await _localDataSource.saveSchedule(model);
    return result.fold(
      (failure) => Left(failure),
      (savedModel) => Right(savedModel.toEntity()),
    );
  }

  @override
  Future<Either<Failure, MedicineSchedule>> updateSchedule(
      MedicineSchedule schedule) async {
    final model = MedicineScheduleModel.fromEntity(schedule);
    final result = await _localDataSource.updateSchedule(model);
    return result.fold(
      (failure) => Left(failure),
      (updatedModel) => Right(updatedModel.toEntity()),
    );
  }

  @override
  Future<Either<Failure, bool>> deleteSchedule(String id) async {
    return await _localDataSource.deleteSchedule(id);
  }

  @override
  Future<Either<Failure, bool>> markMedicineTaken(String id) async {
    return await _localDataSource.markMedicineTaken(id);
  }
}
