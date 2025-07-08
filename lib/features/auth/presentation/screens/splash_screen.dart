import 'dart:ui';
import 'package:aiwel/components/buttons/label_button.dart';
import 'package:aiwel/components/text_widgets/text_widgets.dart';
import 'package:aiwel/features/auth/presentation/screens/signin_signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../components/constants.dart';
import '../../../home/home_screen.dart';
import '../view_models/sign_in_viewModel.dart';

class SplashScreen extends StatelessWidget {

  final SignInViewModelBase viewModelBase;


  static const String routeName = '/splashScreen';
  const SplashScreen({super.key,required this.viewModelBase});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton:             LabelButton(
        label: 'Let’s get started',
          onTap: () async {

            final token = await viewModelBase.getToken();
            print(token);
            print("token");
            if (token == null || token.isEmpty) {
              // No token found, navigate to SigninSignupScreen
              // return SigninSignupScreen(viewModelBase: viewModel);
              Navigator.pushNamed(context, SigninSignupScreen.routeName);

            }else{

              Navigator.pushNamed(context, HomeScreen.routeName);


            }

            // Navigator.pushNamed(context, '/signinSignup');

          },
        gradient: splashGradient(),
        // bgColor: const Color(0xffF6F6F6),
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
              Color(0xFFE4D6FA), // light purple
              Color(0xFFF1EAFE), // even lighter
              Color(0xFFFFFFFF), // white middle
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
            // Logo
            SvgPicture.asset(
              '$svgPath/applogo.svg',
              height: 120,
              width: 120,
            ),

            // gradientDivider(),
            const SizedBox(height: 30),
            RichText(text: TextSpan(
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
            )),
            const SizedBox(height: 5),
            // Tagline
            MediumPurpleText("Take Care"),
            const SizedBox(height: 80),


          ],
        ),
      ),
    );
  }
}