import 'package:aiwel/features/auth/presentation/screens/profile_screens/profile_screen.dart';
import 'package:aiwel/features/home/home_screen.dart';
import 'package:flutter/material.dart';

import '../features/auth/presentation/screens/otp_screen.dart';
import '../features/auth/presentation/screens/profile_screens/emotian_screen.dart';
import '../features/auth/presentation/screens/profile_screens/sleep_quality_screen.dart';
import '../features/auth/presentation/screens/profile_screens/workout_screen.dart';
import '../features/auth/presentation/screens/signin_signup_screen.dart';



// Future<Widget> routeNavigator(String routeName, {Map<String, dynamic>? viewModels}) async {
//
//   print("hrerere");
//   print('Navigating to: $routeName');
//
//   // Initialize dependencies using DependencyManager
//   final prefs = await SharedPreferences.getInstance();
//   final authLocalDataSource = AuthLocalDataSourceImpl(prefs);
//   final authRemoteDataSource = AuthRemoteDataSourceImpl(authLocalDataSource: authLocalDataSource);
//   final authRepository = AuthRepositoryImpl(
//     authRemoteDataSource: authRemoteDataSource,
//     authLocalDataSource: authLocalDataSource,
//   );
//
//   // Default viewModel
//   dynamic viewModel = viewModels?[routeName] ?? await DependencyManager.createSignInViewModel();
//
//   // Handle navigation for app start (SplashScreen)
//   if (routeName == SplashScreen.routeName) {
//     final token = await authLocalDataSource.getToken();
// print(token);
// print("token");
//     if (token == null || token.isEmpty) {
//       // No token found, navigate to SigninSignupScreen
//       // return SigninSignupScreen(viewModelBase: viewModel);
//       return HomeScreen();
//     }else{
//
//     return HomeScreen() ;
//
//
//     }
//
//
//
//
//     // // Verify token validity
//     // final tokenVerificationResult = await authRepository.verifyToken(token);
//     // return tokenVerificationResult.fold(
//     //       (failure) async {
//     //     // Token is invalid or expired, clear token and profile status
//     //     await authLocalDataSource.clearToken();
//     //     await authLocalDataSource.saveProfileCompletion(false);
//     //     return SigninSignupScreen(viewModelBase: viewModel);
//     //   },
//     //       (isValid) async {
//     //     if (!isValid) {
//     //       // Token is invalid, clear token and profile status
//     //       await authLocalDataSource.clearToken();
//     //       // await authLocalDataSource.saveProfileCompletion(false);
//     //       return SigninSignupScreen(viewModelBase: viewModel);
//     //     }
//     //
//     //     // Token is valid, check profile completion
//     //     // final isProfileComplete = await authLocalDataSource.isProfileComplete();
//     //     if (isProfileComplete) {
//     //       // Profile is complete, navigate to HomeScreen
//     //       return SigninSignupScreen(viewModelBase: viewModel);
//     //       return HomeScreen(viewModelBase: viewModel);
//     //     } else {
//     //       // Profile is not complete, navigate to ProfileScreen
//     //       return ProfileScreen(viewModelBase: viewModel);
//     //     }
//     //   },
//     // );
//   }
//
//
//   // Handle specific routes
//   switch (routeName) {
//     case SigninSignupScreen.routeName:
//       return SigninSignupScreen(viewModelBase: viewModel);
//     case OtpScreen.routeName:
//       return OtpScreen(viewModelBase: viewModel);
//     case EmotianScreen.routeName:
//       return EmotianScreen(viewModelBase: viewModel);
//     case WorkoutScreen.routeName:
//       return WorkoutScreen(viewModelBase: viewModel);
//     case SleepQualityScreen.routeName:
//       return SleepQualityScreen(viewModelBase: viewModel);
//     case ProfileScreen.routeName:
//       return ProfileScreen(viewModelBase: viewModel);
//       case HomeScreen.routeName:
//       return HomeScreen();
//     // case HomeScreen.routeName:
//     //   return HomeScreen(viewModelBase: viewModel);
//     default:
//       return SplashScreen();
//   }
// }
Future<Widget> routeNavigator(String routeName, {Map<String, dynamic>? viewModels}) async {
  print('Navigating to000: $routeName');
  // Default to SignInViewModel if viewModels is null or no match is found
  dynamic viewModel = viewModels?[routeName] ?? viewModels?[SigninSignupScreen.routeName];

  switch (routeName) {
    case SigninSignupScreen.routeName:
      return SigninSignupScreen(viewModelBase: viewModel);
    case OtpScreen.routeName:
      return OtpScreen(viewModelBase: viewModel);
    case EmotianScreen.routeName:
      return EmotianScreen(viewModelBase: viewModel);
    case WorkoutScreen.routeName:
      return WorkoutScreen(viewModelBase: viewModel); // Keep only this case
    case SleepQualityScreen.routeName:
      return SleepQualityScreen(viewModelBase: viewModel);
    case ProfileScreen.routeName:
      return ProfileScreen(viewModelBase: viewModel);
    case HomeScreen.routeName:
      return HomeScreen();
    default:
      return ProfileScreen(viewModelBase: viewModel);
  }
}