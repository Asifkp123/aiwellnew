import 'dart:convert';
import 'package:dartz/dartz.dart';
import '../../../../../core/config/api_config.dart';
import '../../../../../core/network/error/failure.dart';
import '../../../../../core/network/model/api_response.dart';
import '../../../../../core/network/api_service.dart';

abstract class PatientRemoteDataSource {
  Future<Either<Failure, ApiResponse>> getPatients();
}

class PatientRemoteDataSourceImpl implements PatientRemoteDataSource {
  final IApiService apiService;

  PatientRemoteDataSourceImpl({required this.apiService});

  @override
  Future<Either<Failure, ApiResponse>> getPatients() async {
    try {
      final apiResponse = await apiService.get(
        ApiConfig.patientListEndpoint,
      );

      if (apiResponse.isSuccess) {
        return Right(apiResponse);
      } else {
        return Left(
            Failure(apiResponse.errorMessage ?? 'Failed to get patients'));
      }
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }
}
