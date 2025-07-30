import 'package:dartz/dartz.dart';
import '../../../../core/network/error/failure.dart';
import '../../data/models/api/create_pal_request.dart';
import '../../data/models/api/create_pal_response.dart';

abstract class PalRepository {
  Future<Either<Failure, CreatePalResponse>> createPal(
      CreatePalRequest request);
}
