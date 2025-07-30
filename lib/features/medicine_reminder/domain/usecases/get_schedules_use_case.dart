import 'package:dartz/dartz.dart';
import '../../../../core/network/error/failure.dart';
import '../entities/medicine_schedule.dart';
import '../repositories/medicine_repository.dart';

abstract class GetSchedulesUseCaseBase {
  Future<Either<Failure, List<MedicineSchedule>>> execute();
}

class GetSchedulesUseCase implements GetSchedulesUseCaseBase {
  final MedicineRepository _repository;

  GetSchedulesUseCase({required MedicineRepository repository})
      : _repository = repository;

  @override
  Future<Either<Failure, List<MedicineSchedule>>> execute() async {
    return await _repository.getSchedules();
  }
}
