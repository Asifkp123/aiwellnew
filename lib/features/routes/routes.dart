import 'package:aiwel/features/auth/presentation/screens/profile_screens/profile_screen.dart';
import 'package:aiwel/features/auth/presentation/view_models/sign_in_viewModel.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../test.dart';
import '../auth/presentation/screens/otp_screen.dart';
import '../auth/presentation/screens/profile_screens/emotian_screen.dart';
import '../auth/presentation/screens/signin_signup_screen.dart';
import '../auth/presentation/screens/splash_screen.dart';




Widget routeNavigator(String routeName) {
  final getIt = GetIt.instance; // Access GetIt instance
  print('Navigating to: $routeName'); // Debug print
  switch (routeName) {

    case SigninSignupScreen.routeName:
      return SigninSignupScreen(
        viewModelBase: getIt<SignInViewModelBase>(),
      );
    case OtpScreen.routeName:
      return OtpScreen(
        viewModelBase: getIt<SignInViewModelBase>(),
      );
    default:
      // return ProfileScreen(viewModelBase:getIt<SignInViewModelBase>() ,);
      return EmotianScreen(viewModelBase:getIt<SignInViewModelBase>());
  }
}



// Widget routeNavigator(String routeName) {
//
//   SignInViewModelBase viewModelBase = SignInViewModelBase();
//   switch (routeName) {
//     case SigninSignupScreen.routeName:
//       return const SigninSignupScreen();
//     case OtpScreen.routeName:
//       return OtpScreen(viewModelBase: null,);
//
//     default:
//       return  SplashScreen();
//   }
// }