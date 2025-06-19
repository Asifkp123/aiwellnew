import 'package:aiwel/features/auth/presentation/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'app.dart';
import 'components/theme/light_theme.dart';
import 'di/auth_injection.dart';
import 'features/auth/presentation/screens/otp_screen.dart';
import 'features/auth/presentation/screens/sign_in_screen.dart';
import 'features/auth/presentation/screens/signin_signup_screen.dart';
import 'features/auth/presentation/view_models/sign_in_viewModel.dart';

final getIt = GetIt.instance;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
    await setupAuthDependencies();

  runApp( MyApp());
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