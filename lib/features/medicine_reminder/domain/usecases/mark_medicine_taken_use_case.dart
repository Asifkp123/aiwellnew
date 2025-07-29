import 'package:dartz/dartz.dart';
import '../../../../core/network/error/failure.dart';
import '../repositories/medicine_repository.dart';

class MarkMedicineTakenParams {
  final String id;

  MarkMedicineTakenParams({required this.id});
}

abstract class MarkMedicineTakenUseCaseBase {
  Future<Either<Failure, bool>> execute(MarkMedicineTakenParams params);
}

class MarkMedicineTakenUseCase implements MarkMedicineTakenUseCaseBase {
  final MedicineRepository _repository;

  MarkMedicineTakenUseCase({required MedicineRepository repository})
      : _repository = repository;

  @override
  Future<Either<Failure, bool>> execute(MarkMedicineTakenParams params) async {
    // Domain validation
    if (params.id.trim().isEmpty) {
      return Left(Failure('Schedule ID cannot be empty'));
    }

    return await _repository.markMedicineTaken(params.id);
  }
}
