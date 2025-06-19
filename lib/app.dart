import 'package:flutter/material.dart';

import 'components/theme/light_theme.dart';
import 'features/auth/presentation/screens/splash_screen.dart';
import 'features/routes/routes.dart';


final GlobalKey<ScaffoldMessengerState> rootScaffoldMessengerKey =
GlobalKey<ScaffoldMessengerState>();

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }



  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Aiwel',
    theme: lightTheme,
    themeMode: ThemeMode.light,
    debugShowCheckedModeBanner: false,
    scaffoldMessengerKey: rootScaffoldMessengerKey,
    navigatorKey: navigatorKey,
    onGenerateRoute: (RouteSettings routeSettings) =>
        PageRouteBuilder<void>(
          settings: routeSettings,
          pageBuilder: (BuildContext context, Animation<double> animation,
              Animation<double> secondaryAnimation) =>
              routeNavigator(routeSettings.name ?? '/'),
          transitionsBuilder: (BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
              Widget child) =>
          child,
        ),


  );
}
