import 'package:dartz/dartz.dart';
import '../../../../core/network/error/failure.dart';
import '../entities/patient.dart';

abstract class PatientRepository {
  Future<Either<Failure, List<Patient>>> getPatients();
}
