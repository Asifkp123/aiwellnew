import 'package:flutter/material.dart';
import 'core/state/app_state_manager.dart';
import 'features/auth/presentation/screens/signin_signup_screen.dart';
import 'features/home/home_screen.dart';
import 'features/auth/presentation/screens/profile_screens/profile_screen.dart';

class AppWrapper extends StatelessWidget {
  final Map<String, dynamic> viewModels;
  const AppWrapper({Key? key, required this.viewModels}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final signInViewModel = viewModels[SigninSignupScreen.routeName];
    return ValueListenableBuilder<AppState>(
      valueListenable: AppStateManager.instance.appStateNotifier,
      builder: (context, state, _) {
        if (state is HomeState) {
          return HomeScreen();
        } else if (state is ProfileState) {
          return ProfileScreen(viewModelBase: signInViewModel);
        } else {
          return SigninSignupScreen(viewModelBase: signInViewModel);
        }
      },
    );
  }
}
