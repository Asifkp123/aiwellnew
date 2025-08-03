import '../../../../../core/network/api_service.dart';
import '../../../../../core/network/model/api_response.dart';

abstract class CreditRemoteDataSource {
  Future<ApiResponse<Map<String, dynamic>>> getCreditSummary();
}

class CreditRemoteDataSourceImpl implements CreditRemoteDataSource {
  final IApiService apiService;
  static const String _creditSummaryEndpoint =
      'http://api-test.aiwel.org/api/v1/credits/summary';

  CreditRemoteDataSourceImpl({required this.apiService});

  @override
  Future<ApiResponse<Map<String, dynamic>>> getCreditSummary() async {
    try {
      print('📡 CreditRemoteDataSource: Fetching credit summary');

      final response = await apiService.get<Map<String, dynamic>>(
        _creditSummaryEndpoint,
      );

      print(
          '📡 CreditRemoteDataSource: Response received - ${response.isSuccess}');
      return response;
    } catch (e) {
      print('❌ CreditRemoteDataSource: Error - $e');
      return ApiResponseImpl.error('Failed to fetch credit summary: $e');
    }
  }
}
