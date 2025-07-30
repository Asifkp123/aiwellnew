import '../../../../core/state/app_state_manager.dart';
import '../../data/repositories/auth_repository.dart';

class SubmitProfileResult {
  final String? error;
  final String? successMessage;
  final AppState? appState;

  SubmitProfileResult({
    this.error,
    this.successMessage,
    this.appState,
  });
}

abstract class SubmitProfileUseCaseBase {
  Future<SubmitProfileResult> execute({
    required String firstName,
    required String lastName,
    required String gender,
    required String dateOfBirth,
    required String dominantEmotion,
    required String sleepQuality,
    required String physicalActivity,
  });
}

class SubmitProfileUseCase implements SubmitProfileUseCaseBase {
  final AuthRepositoryImpl authRepository;

  SubmitProfileUseCase({required this.authRepository});

  @override
  Future<SubmitProfileResult> execute({
    required String firstName,
    required String lastName,
    required String gender,
    required String dateOfBirth,
    required String dominantEmotion,
    required String sleepQuality,
    required String physicalActivity,
  }) async {
    final result = await authRepository.submitProfile(
      firstName: firstName,
      lastName: lastName,
      gender: gender,
      dateOfBirth: dateOfBirth,
      dominantEmotion: dominantEmotion,
      sleepQuality: sleepQuality,
      physicalActivity: physicalActivity,
    );

    return result.fold(
      (failure) => SubmitProfileResult(
        error: failure.message,
        appState: null,
      ),
      (response) {
        // If profile submission is successful, change app state to HomeState
        if (response.success) {
          // Save the app state to HomeState
          AppStateManager.saveAppState(HomeState());
          return SubmitProfileResult(
            successMessage: response.message ?? "Profile updated successfully.",
            appState: HomeState(),
          );
        } else {
          return SubmitProfileResult(
            error: response.message ?? "Profile update failed.",
            appState: null,
          );
        }
      },
    );
  }
}
