import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import '../../../../../core/config/api_config.dart';
import '../../../../../core/network/error/failure.dart';
import '../../../../../core/services/token_manager.dart';
import '../../models/api/create_pal_request.dart';
import '../../models/api/create_pal_response.dart';

abstract class PalRemoteDataSource {
  Future<Either<Failure, CreatePalResponse>> createPal(
      CreatePalRequest request);
}

class PalRemoteDataSourceImpl implements PalRemoteDataSource {
  final TokenManager tokenManager;

  PalRemoteDataSourceImpl({required this.tokenManager});

  @override
  Future<Either<Failure, CreatePalResponse>> createPal(
      CreatePalRequest request) async {
    // Get the access token
    final accessToken = await tokenManager.getAccessToken();
    if (accessToken == null) {
      return Left(
          Failure('Authentication token is missing. Please log in again.'));
    }

    final response = await http.post(
      Uri.parse(ApiConfig.patientCreationEndPoint),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final responseBody = jsonDecode(response.body) as Map<String, dynamic>;
      return Right(CreatePalResponse.fromJson(responseBody));
    } else {
      final responseBody = jsonDecode(response.body) as Map<String, dynamic>;
      final errorMessage = responseBody['detail'] ?? 'Failed to create PAL';

      return Left(Failure(errorMessage));
    }
  }
}
