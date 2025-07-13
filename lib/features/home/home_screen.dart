import 'dart:ui';
import 'package:aiwel/components/buttons/label_button.dart';
import 'package:aiwel/components/text_widgets/text_widgets.dart';
import 'package:aiwel/features/auth/presentation/screens/signin_signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../components/constants.dart';
import '../../components/theme/light_theme.dart';

class HomeScreen extends StatelessWidget {
  static const String routeName = '/homeScreen';
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final customColors = Theme.of(context).extension<CustomColors>()!;

    return Scaffold(

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
            stops: [0.1, 0.2, 0.5, 0.8, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(

                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    width: 3,
                    color: customColors.containerBorderColor,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset("$svgPath/Heart Icon Home.svg"),
                    PurpleBoldText("123",),
                  ],
                ),
              ),
            ],
          ),
              LargePurpleText("Good Morning Arjun,"),
              // const SizedBox(height: 0),

              MediumPurpleText("You are doing amazing work! "),
          
          
              // const SizedBox(height: 250),
              // Logo
              MediumPurpleText("Home "),
              GlassEffectWidget(

                width: 200  ,
                height: 200,
                child: Column(
                children: [
                  Row(
                    children: [
                      SvgPicture.asset("$svgPath/mood Emoji.svg"),
                      LargePurpleText(" Mood"),

                    ],
                  ),
                  NormalGreyText("How are you feeling today?"), 
                ],
              ),),
          
              MediumPurpleText("Logout  "),
          
              // gradientDivider(),
              const SizedBox(height: 30),
              LabelButton(
                label: 'Add Pal',
                onTap: () {
                  // Navigator.pushNamed(context, '/signinSignup');
                  // Navigator.pushNamed(context, SigninSignupScreen.routeName);
          
                },
                gradient: splashGradient(),
                // bgColor: const Color(0xffF6F6F6),
                fontColor: Theme.of(context).primaryColorLight,
              ),
          
          
            ],
          ),
        ),
      ),
    );
  }
}

class GlassEffectWidget extends StatelessWidget {
  final Widget child;
  final double width;
  final double height;
  const GlassEffectWidget({
    super.key, required this.child, required this.width, required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          width: width,
          height: height,
          padding: EdgeInsets.all(5),
     
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              width: 2,
              color: Colors.white,
            ),
          ),
child: child,
        ),
      ),
    );
  }
}