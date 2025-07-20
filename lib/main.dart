import 'package:aiwel/features/auth/presentation/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'app.dart';
import 'components/theme/light_theme.dart';
import 'di/auth_injection.dart';
import 'features/auth/presentation/screens/otp_screen.dart';
import 'features/auth/presentation/screens/sign_in_screen.dart';
import 'features/auth/presentation/screens/signin_signup_screen.dart';
import 'features/auth/presentation/view_models/sign_in_viewModel.dart';
import 'features/auth/presentation/view_models/splash_viewModel.dart' as splash;
import 'features/auth/domain/usecases/check_auth_status_use_case.dart';
import 'core/services/auth_service.dart';

// final getIt = GetIt.instance;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    // Check authentication status on app startup
    final authService = AuthService.instance;
    final authStatus = await authService.getAuthStatus();

    print('App startup - Auth status: $authStatus');

    final signInViewModel = await DependencyManager.createSignInViewModel();
    final addPalViewModel = await DependencyManager.createAddPalViewModel();

    final authRepository = await DependencyManager.createAuthRepository();
    final checkAuthStatusUseCase = CheckAuthStatusUseCase(authRepository);
    final splashViewModel = splash.SplashViewModel(checkAuthStatusUseCase);

    runApp(MyApp(
      viewModels: {
        SigninSignupScreen.routeName: signInViewModel,
        "AddPalViewModel": addPalViewModel,
        "SplashViewModel": splashViewModel,
      },
      initialAuthStatus: authStatus,
    ));
  } catch (e) {
    print('Error initializing app: $e');
    runApp(const MaterialApp(home: Text('Error initializing app')));
  }
}
// class MyApp extends StatefulWidget {
//   const MyApp({super.key});
//
//   @override
//   State<MyApp> createState() => _MyAppState();
// }
//
// class _MyAppState extends State<MyApp> {
//   late final SignInViewModelBase _signInViewModel;
//
//   @override
//   void initState() {
//     super.initState();
//     _signInViewModel = getIt<SignInViewModelBase>();
//   }
//
//   @override
//   void dispose() {
//     _signInViewModel.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Aiwel',
//       theme: lightTheme,
//       themeMode: ThemeMode.light,
//       // home: SignInScreen(viewModelBase: _signInViewModel),
//       home: OtpScreen(),
//     );
//   }
// }
