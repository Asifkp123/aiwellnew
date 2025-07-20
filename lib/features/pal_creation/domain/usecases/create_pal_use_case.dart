import 'package:dartz/dartz.dart';
import '../../../../core/network/error/failure.dart';
import '../../data/repositories/pal_repository.dart';
import '../../data/models/api/create_pal_request.dart';
import '../../data/models/api/create_pal_response.dart';
import '../repositories/pal_repository.dart';

abstract class CreatePalUseCaseBase {
  Future<Either<Failure, CreatePalResponse>> execute(CreatePalRequest request);
}

class CreatePalUseCase implements CreatePalUseCaseBase {
  final PalRepository palRepository;

  CreatePalUseCase({required this.palRepository});

  @override
  Future<Either<Failure, CreatePalResponse>> execute(CreatePalRequest request) async {
    return await palRepository.createPal(request);
  }
} 