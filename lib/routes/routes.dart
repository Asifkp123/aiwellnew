import 'package:aiwel/features/auth/presentation/screens/profile_screens/profile_screen.dart';
import 'package:aiwel/features/home/home_screen.dart';
import 'package:aiwel/features/pal_creation/presentation/screens/add_pal_completion_congrats_screen.dart';
import 'package:aiwel/features/medicine_reminder/presentation/screens/medicine_reminder_screen.dart';
import 'package:aiwel/features/patient/presentation/view_models/patient_view_model.dart';
import 'package:flutter/material.dart';

import '../features/auth/presentation/screens/otp_screen.dart';
import '../features/auth/presentation/screens/profile_screens/emotion_screen.dart';
import '../features/auth/presentation/screens/profile_screens/sleep_quality_screen.dart';
import '../features/auth/presentation/screens/profile_screens/workout_screen.dart';
import '../features/auth/presentation/screens/signin_signup_screen.dart';
import '../features/pal_creation/presentation/screens/add_pal_able_to_walk_screen.dart';
import '../features/pal_creation/presentation/screens/add_pal_confirmation_submit_screen.dart';
import '../features/pal_creation/presentation/screens/add_pal_diagnosis_screen.dart';
import '../features/pal_creation/presentation/screens/add_pal_discomfort_pain_screen.dart';
import '../features/pal_creation/presentation/screens/add_pal_down_quite_screen.dart';
import '../features/pal_creation/presentation/screens/add_pal_memory_changes_confution_screen.dart';
import '../features/pal_creation/presentation/screens/add_pal_mood_selection_screen.dart';
import '../features/pal_creation/presentation/screens/add_pal_need_walker_stick_screen.dart';
import '../features/pal_creation/presentation/screens/add_pal_profile_creation_screen.dart';
import '../features/pal_creation/presentation/screens/add_pal_resting_bed_screen.dart';
import '../features/pal_creation/presentation/screens/add_pal_sensitive_rest_less_screen.dart';
import '../features/pal_creation/presentation/screens/add_pal_sleep_pattern_screen.dart';
import '../features/pal_creation/presentation/screens/add_pal_sleepbeen_screen.dart';
import '../features/pal_creation/presentation/screens/add_pal_splash_screen.dart';

Future<Widget> routeNavigator(String routeName,
    {Map<String, dynamic>? viewModels, Map<String, dynamic>? arguments}) async {
  print("🧭 Navigating to route: '$routeName'");
  print("📦 Arguments: $arguments");
  print("🗂️ Available viewModels: ${viewModels?.keys.toList()}");

  // Get appropriate ViewModels
  dynamic authViewModel = arguments?['viewModelBase'] ??
      viewModels?['AuthViewModel'] ??
      viewModels?[SigninSignupScreen.routeName];

  dynamic profileViewModel = arguments?['viewModelBase'] ??
      viewModels?['ProfileViewModel'] ??
      viewModels?[ProfileScreen.routeName];

  print("🔐 AuthViewModel: ${authViewModel != null ? 'OK' : 'NULL'}");
  print("👤 ProfileViewModel: ${profileViewModel != null ? 'OK' : 'NULL'}");

  dynamic addPalVeiewModel = arguments?['viewModelBase'] ??
      viewModels?["AddPalViewModel"] ??
      viewModels?[AddPalProfileCreationScreen.routeName];

  PatientViewModel? patientViewModel =
      viewModels?['PatientViewModel'] as PatientViewModel?;
  print("🏥 PatientViewModel: ${patientViewModel != null ? 'OK' : 'NULL'}");

  dynamic logsViewModel = viewModels?['LogsViewModel'];
  print("📝 LogsViewModel: ${logsViewModel != null ? 'OK' : 'NULL'}");

  switch (routeName) {
    // Auth screens - use AuthViewModel
    case SigninSignupScreen.routeName:
      return SigninSignupScreen(viewModelBase: authViewModel);
    case OtpScreen.routeName:
      return OtpScreen(viewModelBase: authViewModel);

    // Profile screens - use ProfileViewModel
    case EmotionScreen.routeName:
      return EmotionScreen(viewModelBase: profileViewModel);
    case WorkoutScreen.routeName:
      return WorkoutScreen(viewModelBase: profileViewModel);
    case SleepQualityScreen.routeName:
      return SleepQualityScreen(viewModelBase: profileViewModel);
    case ProfileScreen.routeName:
      return ProfileScreen(viewModelBase: profileViewModel);
    case HomeScreen.routeName:
      return HomeScreen(
        patientViewModel: patientViewModel,
        logsViewModel: logsViewModel,
      );
    case AddPalProfileCreationScreen.routeName:
      return AddPalProfileCreationScreen(viewModelBase: addPalVeiewModel);
    case AddPalSplashScreen.routeName:
      return AddPalSplashScreen(viewModelBase: addPalVeiewModel);

    case AddPalDiagnosisScreen.routeName:
      return AddPalDiagnosisScreen(viewModelBase: addPalVeiewModel);

    case AddPalAbleToWalkScreen.routeName:
      return AddPalAbleToWalkScreen(viewModelBase: addPalVeiewModel);

    case AddPalNeedWalkerStickScreen.routeName:
      return AddPalNeedWalkerStickScreen(viewModelBase: addPalVeiewModel);
    case AddPalRestingBedScreen.routeName:
      return AddPalRestingBedScreen(viewModelBase: addPalVeiewModel);
    case AddPalMemoryChangesConfutionScreen.routeName:
      return AddPalMemoryChangesConfutionScreen(
          viewModelBase: addPalVeiewModel);

    case AddPalSensitiveRestLessScreen.routeName:
      return AddPalSensitiveRestLessScreen(viewModelBase: addPalVeiewModel);
    case AddPalDownQuiteScreen.routeName:
      return AddPalDownQuiteScreen(viewModelBase: addPalVeiewModel);

    case AddPalMoodSelectionScreen.routeName:
      return AddPalMoodSelectionScreen(viewModelBase: addPalVeiewModel);

    case AddPalSleepPatternScreen.routeName:
      return AddPalSleepPatternScreen(viewModelBase: addPalVeiewModel);
    case AddPalSleepbeenScreen.routeName:
      return AddPalSleepbeenScreen(viewModelBase: addPalVeiewModel);

    case AddPalDiscomfortOrPainScreen.routeName:
      return AddPalDiscomfortOrPainScreen(viewModelBase: addPalVeiewModel);
    case AddPalConfirmationSubmitScreen.routeName:
      return AddPalConfirmationSubmitScreen(viewModelBase: addPalVeiewModel);
    case AddPalCompletionCongratsScreen.routeName:
      return AddPalCompletionCongratsScreen(viewModelBase: addPalVeiewModel);
    case MedicineReminderScreen.routeName:
      return MedicineReminderScreen();
    default:
      // return AddPalProfileCreationScreen(viewModelBase: addPalVeiewModel);
      return MedicineReminderScreen();
  }
}
