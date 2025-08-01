import 'package:dartz/dartz.dart';
import '../../../../core/network/error/failure.dart';
import '../datasources/remote/patient_remote_datasource.dart';
import '../models/api/patient_response.dart';
import '../../domain/entities/patient.dart';
import '../../domain/repositories/patient_repository.dart';

class PatientRepositoryImpl implements PatientRepository {
  final PatientRemoteDataSource patientRemoteDataSource;

  PatientRepositoryImpl({required this.patientRemoteDataSource});

  @override
  Future<Either<Failure, List<Patient>>> getPatients() async {
    final result = await patientRemoteDataSource.getPatients();

    return result.fold(
      (failure) => Left(failure),
      (apiResponse) {
        try {
          final List<dynamic> patientsJson = apiResponse.data as List<dynamic>;
          final List<Patient> patients = patientsJson
              .map((patientJson) =>
                  PatientResponse.fromJson(patientJson).toEntity())
              .toList();

          print("🏥 Successfully parsed ${patients.length} patients");
          return Right(patients);
        } catch (e) {
          return Left(Failure('Failed to parse patients data: $e'));
        }
      },
    );
  }
}
