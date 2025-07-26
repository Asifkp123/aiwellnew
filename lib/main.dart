import 'package:aiwel/routes/routes.dart';
import 'package:flutter/material.dart';
import 'app.dart';
import 'components/theme/light_theme.dart';
import 'core/state/app_state_manager.dart';
import 'di/auth_injection.dart';
import 'features/auth/presentation/screens/splash_screen.dart';
import 'features/auth/presentation/screens/signin_signup_screen.dart';
import 'features/auth/presentation/screens/profile_screens/profile_screen.dart';
import 'features/home/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await AppStateManager.instance.restoreAppState();

    final signInViewModel = await DependencyManager.createSignInViewModel();
    final addPalViewModel = await DependencyManager.createAddPalViewModel();
    final splashViewModel = await DependencyManager.createSplashViewModel();

    runApp(MyApp(
      viewModels: {
        SigninSignupScreen.routeName: signInViewModel,
        ProfileScreen.routeName: signInViewModel,
        'AddPalViewModel': addPalViewModel,
        'SplashViewModel': splashViewModel,
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
    return
        MaterialApp(
          title: 'Aiwel',
          theme: lightTheme,
          themeMode: ThemeMode.light,
          debugShowCheckedModeBanner: false,
          scaffoldMessengerKey: rootScaffoldMessengerKey,
          navigatorKey: navigatorKey,
          home: SplashScreen(viewModels: viewModels),
          onGenerateRoute: (RouteSettings routeSettings) => PageRouteBuilder<void>(
            settings: routeSettings,
            pageBuilder: (BuildContext context, Animation<double> animation,
                Animation<double> secondaryAnimation) {
              return FutureBuilder<Widget>(
                future: routeNavigator(routeSettings.name ?? '/', viewModels: viewModels),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return SplashScreen(viewModels: viewModels);
                  }
                  if (snapshot.hasError) {
                    return const Text('Error loading route');
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
