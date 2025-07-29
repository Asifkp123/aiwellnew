import 'package:aiwel/features/auth/presentation/screens/profile_screens/profile_screen.dart';
import 'package:aiwel/features/home/home_screen.dart';
import 'package:aiwel/features/pal_creation/presentation/screens/add_pal_completion_congrats_screen.dart';
import 'package:aiwel/features/medicine_reminder/presentation/screens/medicine_reminder_screen.dart';
import 'package:aiwel/features/medicine_reminder/di/medicine_injection.dart';
import 'package:flutter/material.dart';

import '../features/auth/presentation/screens/otp_screen.dart';
import '../features/auth/presentation/screens/profile_screens/emotian_screen.dart';
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
import '../features/pal_creation/presentation/screens/add_pal_congratulations_screen.dart';

Future<Widget> routeNavigator(String routeName,
    {Map<String, dynamic>? viewModels, Map<String, dynamic>? arguments}) async {
  dynamic viewModel = arguments?['viewModelBase'] ??
      viewModels?[routeName] ??
      viewModels?[SigninSignupScreen.routeName];
  dynamic addPalVeiewModel = arguments?['viewModelBase'] ??
      viewModels?["AddPalViewModel"] ??
      viewModels?[AddPalProfileCreationScreen.routeName];

  switch (routeName) {
    case SigninSignupScreen.routeName:
      return SigninSignupScreen(viewModelBase: viewModel);
    case OtpScreen.routeName:
      return OtpScreen(viewModelBase: viewModel);
    case EmotianScreen.routeName:
      return EmotianScreen(viewModelBase: viewModel);
    case WorkoutScreen.routeName:
      return WorkoutScreen(viewModelBase: viewModel);
    case SleepQualityScreen.routeName:
      return SleepQualityScreen(viewModelBase: viewModel);
    case ProfileScreen.routeName:
      return ProfileScreen(viewModelBase: viewModel);
    case HomeScreen.routeName:
      return HomeScreen();
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
