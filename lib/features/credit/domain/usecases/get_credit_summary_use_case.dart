import 'package:dartz/dartz.dart';
import '../../../../core/network/error/failure.dart';
import '../entities/credit_summary.dart';
import '../repositories/credit_summary_repository.dart';

abstract class GetCreditSummaryUseCaseBase {
  Future<Either<Failure, CreditSummary>> execute();
}

class GetCreditSummaryUseCase implements GetCreditSummaryUseCaseBase {
  final CreditSummaryRepository repository;

  GetCreditSummaryUseCase({required this.repository});

  @override
  Future<Either<Failure, CreditSummary>> execute() async {
    return await repository.getCreditSummary();
  }
}
