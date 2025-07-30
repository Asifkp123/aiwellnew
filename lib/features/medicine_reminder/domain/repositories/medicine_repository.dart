import 'package:dartz/dartz.dart';
import '../../../../core/network/error/failure.dart';
import '../entities/medicine_schedule.dart';

abstract class MedicineRepository {
  Future<Either<Failure, List<MedicineSchedule>>> getSchedules();
  Future<Either<Failure, MedicineSchedule>> addSchedule(
      MedicineSchedule schedule);
  Future<Either<Failure, MedicineSchedule>> updateSchedule(
      MedicineSchedule schedule);
  Future<Either<Failure, bool>> deleteSchedule(String id);
  Future<Either<Failure, bool>> markMedicineTaken(String id);
}
