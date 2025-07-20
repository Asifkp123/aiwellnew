import 'package:dartz/dartz.dart';
import '../../../../core/network/error/failure.dart';
import '../../data/datasources/remote/pal_remote_datasource.dart';
import '../../data/models/api/create_pal_request.dart';
import '../../data/models/api/create_pal_response.dart';

abstract class PalRepository {
  Future<Either<Failure, CreatePalResponse>> createPal(
      CreatePalRequest request);
}

class PalRepositoryImpl implements PalRepository {
  final PalRemoteDataSource palRemoteDataSource;

  PalRepositoryImpl({required this.palRemoteDataSource});

  @override
  Future<Either<Failure, CreatePalResponse>> createPal(
      CreatePalRequest request) async {
    try {
      return await palRemoteDataSource.createPal(request);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }
}
