import 'dart:ui';
import 'package:aiwel/components/buttons/label_button.dart';
import 'package:aiwel/components/constants.dart';
import 'package:aiwel/components/text_widgets/text_widgets.dart';
import 'package:aiwel/features/auth/domain/usecases/check_auth_status_use_case.dart';
import 'package:aiwel/features/auth/presentation/screens/profile_screens/profile_screen.dart';
import 'package:aiwel/features/auth/presentation/screens/signin_signup_screen.dart';
import 'package:aiwel/features/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../view_models/splash_viewModel.dart';

class SplashScreen extends StatelessWidget {
  final SplashViewModel viewModel;

  const SplashScreen({Key? key, required this.viewModel}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: LabelButton(
        label: 'Let\u2019s get started',
        onTap: () async {
          final route = await viewModel.handleLetsGetStarted();
          print(route);
          Navigator.pushReplacementNamed(context, route);
        },
        gradient: splashGradient(),
        fontColor: Theme.of(context).primaryColorLight,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFE4D6FA),
              Color(0xFFF1EAFE),
              Color(0xFFFFFFFF),
              Color(0xFFF1EAFE),
              Color(0xFFE4D6FA),
            ],
            stops: [0.0, 0.2, 0.5, 0.8, 1.0],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 250),
            SvgPicture.asset(
              '$svgPath/applogo.svg',
              height: 120,
              width: 120,
            ),
            const SizedBox(height: 30),
            RichText(
              text: TextSpan(
                text: "ai",
                style: Theme.of(context).textTheme.labelLarge!.copyWith(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                children: [
                  TextSpan(
                    text: "wel",
                    style: Theme.of(context).textTheme.labelLarge!.copyWith(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff1C0038),
                        ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 5),
            MediumPurpleText("Take Care"),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}
