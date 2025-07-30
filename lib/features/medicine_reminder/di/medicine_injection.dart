import '../data/datasources/local/medicine_local_datasource.dart';
import '../data/repositories/medicine_repository_impl.dart';
import '../domain/repositories/medicine_repository.dart';
import '../domain/usecases/add_schedule_use_case.dart';
import '../domain/usecases/get_schedules_use_case.dart';
import '../domain/usecases/mark_medicine_taken_use_case.dart';
import '../presentation/view_models/medicine_reminder_view_model.dart';

class MedicineInjection {
  static MedicineLocalDataSourceBase get medicineLocalDataSource {
    return MedicineLocalDataSource();
  }

  static MedicineRepository get medicineRepository {
    return MedicineRepositoryImpl(
      localDataSource: medicineLocalDataSource,
    );
  }

  static GetSchedulesUseCaseBase get getSchedulesUseCase {
    return GetSchedulesUseCase(
      repository: medicineRepository,
    );
  }

  static AddScheduleUseCaseBase get addScheduleUseCase {
    return AddScheduleUseCase(
      repository: medicineRepository,
    );
  }

  static MarkMedicineTakenUseCaseBase get markMedicineTakenUseCase {
    return MarkMedicineTakenUseCase(
      repository: medicineRepository,
    );
  }

  static MedicineReminderViewModelBase get medicineReminderViewModel {
    return MedicineReminderViewModel(
      getSchedulesUseCase: getSchedulesUseCase,
      addScheduleUseCase: addScheduleUseCase,
      markMedicineTakenUseCase: markMedicineTakenUseCase,
    );
  }
}
