import 'package:dartz/dartz.dart';
import '../../../../core/network/error/failure.dart';
import '../entities/credit_summary.dart';

abstract class CreditSummaryRepository {
  Future<Either<Failure, CreditSummary>> getCreditSummary();
}
