import 'package:dartz/dartz.dart';
import '../../../../core/network/error/failure.dart';
import '../../data/repositories/pal_repository.dart';
import '../../data/models/api/create_pal_request.dart';
import '../../data/models/api/create_pal_response.dart';
import '../repositories/pal_repository.dart';

abstract class CreatePalUseCaseBase {
  Future<Either<String, String>> execute(CreatePalRequest request);
}

class CreatePalUseCase implements CreatePalUseCaseBase {
  final PalRepository palRepository;

  CreatePalUseCase({required this.palRepository});

  @override
  Future<Either<String, String>> execute(CreatePalRequest request) async {
    final result = await palRepository.createPal(request);
    
    return result.fold(
      (failure) => Left(failure.message), // Error message for snackbar
      (response) => Right(response.message), // Success message for snackbar
    );
  }
} 