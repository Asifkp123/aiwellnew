import 'package:dartz/dartz.dart';
import '../../../../core/network/error/failure.dart';
import '../../domain/repositories/credit_summary_repository.dart';
import '../../domain/entities/credit_summary.dart';
import '../datasources/remote/credit_remote_datasource.dart';
import '../models/credit_summary_response.dart';

class CreditSummaryRepositoryImpl implements CreditSummaryRepository {
  final CreditRemoteDataSource remoteDataSource;

  CreditSummaryRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, CreditSummary>> getCreditSummary() async {
    try {
      print('📦 CreditRepository: Processing credit summary request');

      final apiResponse = await remoteDataSource.getCreditSummary();

      if (apiResponse.isSuccess && apiResponse.data != null) {
        final creditResponse =
            CreditSummaryResponse.fromJson(apiResponse.data!);
        print('✅ CreditRepository: Successfully converted response to model');
        return Right(creditResponse.toDomainEntity());
      } else {
        final errorMessage =
            apiResponse.errorMessage ?? 'Failed to fetch credit summary';
        print('❌ CreditRepository: API error - $errorMessage');
        return Left(Failure(errorMessage));
      }
    } catch (e) {
      print('❌ CreditRepository: Exception - $e');
      return Left(Failure('Repository error: $e'));
    }
  }
}
