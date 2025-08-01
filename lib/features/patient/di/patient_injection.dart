import '../../../core/network/http_api_services.dart';
import '../../../core/services/token_manager.dart';
import '../data/datasources/remote/patient_remote_datasource.dart';
import '../data/repositories/patient_repository_impl.dart';
import '../domain/repositories/patient_repository.dart';
import '../domain/usecases/get_patients_use_case.dart';
import '../presentation/view_models/patient_view_model.dart';

class PatientDependencyManager {
  static Future<PatientViewModel> createPatientViewModel() async {
    try {
      // Initialize TokenManager
      final tokenManager = await TokenManager.getInstance();

      // Initialize ApiService
      final apiService = HttpApiService(tokenManager: tokenManager);

      // Initialize Remote DataSource
      final patientRemoteDataSource = PatientRemoteDataSourceImpl(
        apiService: apiService,
      );

      // Initialize Repository
      final patientRepository = PatientRepositoryImpl(
        patientRemoteDataSource: patientRemoteDataSource,
      );

      // Initialize Use Case
      final getPatientsUseCase = GetPatientsUseCase(
        patientRepository: patientRepository,
      );

      // Initialize ViewModel
      final patientViewModel = PatientViewModel(
        getPatientsUseCase: getPatientsUseCase,
      );

      return patientViewModel;
    } catch (e) {
      print('❌ Error creating PatientViewModel: $e');
      rethrow;
    }
  }
}
