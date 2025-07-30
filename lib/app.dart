import 'package:aiwel/routes/routes.dart';
import 'package:flutter/material.dart';

import 'components/theme/light_theme.dart';
import 'features/auth/presentation/screens/signin_signup_screen.dart';
import 'features/auth/presentation/screens/splash_screen.dart';
import 'features/home/home_screen.dart';
import 'features/medicine_reminder/presentation/screens/medicine_reminder_screen.dart';
import 'features/pal_creation/presentation/screens/add_pal_completion_congrats_screen.dart';
import 'features/pal_creation/presentation/screens/add_pal_confirmation_submit_screen.dart';
import 'features/pal_creation/presentation/screens/add_pal_splash_screen.dart';
import 'features/auth/presentation/view_models/splash_viewModel.dart';
import 'features/auth/domain/usecases/check_auth_status_use_case.dart';
import 'core/services/auth_service.dart' as auth_service;
final GlobalKey<ScaffoldMessengerState> rootScaffoldMessengerKey =
GlobalKey<ScaffoldMessengerState>();

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatefulWidget {
  final Map<String, dynamic> viewModels; // Map of route names to ViewModels

  const MyApp({super.key, required this.viewModels});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {


    return MaterialApp(
      title: 'Aiwel',
      theme: lightTheme,
      themeMode: ThemeMode.light,
      debugShowCheckedModeBanner: false,
      scaffoldMessengerKey: rootScaffoldMessengerKey,
      navigatorKey: navigatorKey,
      home: SplashScreen(viewModels: widget.viewModels),
      onGenerateRoute: (RouteSettings routeSettings) => PageRouteBuilder<void>(
        settings: routeSettings,
        pageBuilder: (BuildContext context, Animation<double> animation,
            Animation<double> secondaryAnimation) {
          return FutureBuilder<Widget>(
            future: routeNavigator(routeSettings.name ?? '/', viewModels: widget.viewModels),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return SplashScreen(viewModels: widget.viewModels);
              }
              if (snapshot.hasError) {
                return const Text('Error loading route');
              }
              return snapshot.data ?? SplashScreen(viewModels: widget.viewModels);
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