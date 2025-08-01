import 'package:dartz/dartz.dart';
import '../../../../core/network/error/failure.dart';
import '../entities/patient.dart';
import '../repositories/patient_repository.dart';

class GetPatientsUseCase {
  final PatientRepository patientRepository;

  GetPatientsUseCase({required this.patientRepository});

  Future<Either<Failure, List<Patient>>> execute() async {
    return await patientRepository.getPatients();
  }
}
