import 'package:aiwel/routes/routes.dart';
import 'package:flutter/material.dart';
import 'app.dart';
import 'components/theme/light_theme.dart';
import 'core/state/app_state_manager.dart';
import 'core/managers/credit_manager.dart';
import 'di/auth_injection.dart';
import 'features/auth/presentation/screens/splash_screen.dart';
import 'features/auth/presentation/screens/signin_signup_screen.dart';
import 'features/auth/presentation/screens/profile_screens/profile_screen.dart';
import 'features/patient/di/patient_injection.dart';
import 'features/logs/di/logs_injection.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await AppStateManager.instance.restoreAppState();

    // Initialize credit manager with default credits (can be updated from user profile later)
    CreditManager.instance.setTotalCredits(120);

    final authViewModel = await DependencyManager.createAuthViewModel();
    final profileViewModel = await DependencyManager.createProfileViewModel();
    final addPalViewModel = await DependencyManager.createAddPalViewModel();
    final splashViewModel = await DependencyManager.createSplashViewModel();
    final patientViewModel =
        await PatientDependencyManager.createPatientViewModel();
    final logsViewModel = await LogsDependencyManager.createLogsViewModel();

    runApp(MyApp(
      viewModels: {
        SigninSignupScreen.routeName: authViewModel,
        ProfileScreen.routeName: profileViewModel,
        'AuthViewModel': authViewModel,
        'ProfileViewModel': profileViewModel,
        'AddPalViewModel': addPalViewModel,
        'SplashViewModel': splashViewModel,
        'PatientViewModel': patientViewModel,
        'LogsViewModel': logsViewModel,
      },
    ));
  } catch (e) {
    print('❌ Error initializing app: $e');
    runApp(const MaterialApp(
      home: Scaffold(body: Center(child: Text('Error initializing app'))),
    ));
  }
}

class MyApp extends StatelessWidget {
  final Map<String, dynamic> viewModels;
  const MyApp({Key? key, required this.viewModels}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aiwel',
      theme: lightTheme,
      themeMode: ThemeMode.light,
      debugShowCheckedModeBanner: false,
      scaffoldMessengerKey: rootScaffoldMessengerKey,
      navigatorKey: navigatorKey,
      home: SplashScreen(viewModels: viewModels),
      // home: ProfileScreen(viewModelBase: viewModels['ProfileViewModel'],),

      onGenerateRoute: (RouteSettings routeSettings) => PageRouteBuilder<void>(
        settings: routeSettings,
        pageBuilder: (BuildContext context, Animation<double> animation,
            Animation<double> secondaryAnimation) {
          return FutureBuilder<Widget>(
            future: routeNavigator(routeSettings.name ?? '/',
                viewModels: viewModels),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return SplashScreen(viewModels: viewModels);
              }
              if (snapshot.hasError) {
                print(
                    "❌ Route error for '${routeSettings.name}': ${snapshot.error}");
                print("📍 Available viewModels: ${viewModels.keys.toList()}");
                return Scaffold(
                  body: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Error loading route: ${routeSettings.name}'),
                        SizedBox(height: 10),
                        Text('Error: ${snapshot.error}'),
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () => Navigator.pushReplacementNamed(
                              context, '/signinSignup'),
                          child: Text('Go to Sign In'),
                        ),
                      ],
                    ),
                  ),
                );
              }
              return snapshot.data ?? SplashScreen(viewModels: viewModels);
            },
          );
        },
        transitionsBuilder: (BuildContext context, Animation<double> animation,
            Animation<double> secondaryAnimation, Widget child) {
          return child; // No transition animation
        },
      ),
    );
  }
}
