import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import '../../../../../core/config/api_config.dart';
import '../../../../../core/network/error/failure.dart';
import '../../../../../core/network/model/api_response.dart';
import '../../../../../core/network/api_service.dart';
import '../../../../../core/services/token_manager.dart';
import '../../models/api/create_pal_request.dart';
import '../../models/api/create_pal_response.dart';

abstract class PalRemoteDataSource {
  Future<Either<Failure, ApiResponse>> createPal(CreatePalRequest request);
}

class PalRemoteDataSourceImpl implements PalRemoteDataSource {
  final IApiService apiService;

  PalRemoteDataSourceImpl({required this.apiService});

  @override
  Future<Either<Failure, ApiResponse>> createPal(CreatePalRequest request) async {
    try {
      final apiResponse = await apiService.post(
        ApiConfig.patientCreationEndPoint,
        body: request.toJson(),
      );
      
      if (apiResponse.isSuccess) {
        return Right(apiResponse);
      } else {
        return Left(Failure(apiResponse.errorMessage ?? 'Failed to create PAL'));
      }
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }
}
