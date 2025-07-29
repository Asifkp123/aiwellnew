import 'package:dartz/dartz.dart';
import '../../../../core/network/error/failure.dart';
import '../datasources/remote/pal_remote_datasource.dart';
import '../models/api/create_pal_request.dart';
import '../models/api/create_pal_response.dart';
import '../../domain/repositories/pal_repository.dart';

class PalRepositoryImpl implements PalRepository {
  final PalRemoteDataSource palRemoteDataSource;

  PalRepositoryImpl({required this.palRemoteDataSource});

  @override
  Future<Either<Failure, CreatePalResponse>> createPal(CreatePalRequest request) async {
    final result = await palRemoteDataSource.createPal(request);
    
    return result.fold(
      (failure) => Left(failure),
      (apiResponse) {
        try {
          // Extract model from ApiResponse data
          final createPalResponse = CreatePalResponse.fromJson(apiResponse.data as Map<String, dynamic>);
          return Right(createPalResponse);
        } catch (e) {
          return Left(Failure('Failed to parse response: $e'));
        }
      },
    );
  }
}
