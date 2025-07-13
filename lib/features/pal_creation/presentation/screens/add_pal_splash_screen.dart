  import 'dart:ui';
  import 'package:aiwel/components/buttons/label_button.dart';
  import 'package:aiwel/components/text_widgets/text_widgets.dart';
  import 'package:aiwel/components/theme/light_theme.dart';
  import 'package:aiwel/features/auth/presentation/screens/signin_signup_screen.dart';
  import 'package:aiwel/features/pal_creation/presentation/screens/add_pal_profile_creation_screen.dart';
  import 'package:aiwel/features/pal_creation/presentation/view_models/add_pal_view_model.dart';
  import 'package:flutter/material.dart';
  import 'package:flutter_svg/svg.dart';

  import '../../../../../components/constants.dart';
  import '../../../auth/presentation/view_models/sign_in_viewModel.dart';
  import '../../../home/home_screen.dart';


  class AddPalSplashScreen extends StatelessWidget {

    final AddPalViewModel viewModelBase;


    static const String routeName = '/addPalSplashScreen';
    const AddPalSplashScreen({super.key,required this.viewModelBase});

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        floatingActionButton:             LabelButton(
          label: 'Continue',
          onTap: () async {

            // Navigate to the next screen
            // Navigator.pushReplacement(
            //   context,
            //   MaterialPageRoute(
            //     builder: (context) => SigninSignupScreen(viewModelBase: viewModelBase),
            //   ),
            // );
            Navigator.pushNamed(
              context,
              AddPalProfileCreationScreen.routeName,
              arguments: {'viewModelBase': viewModelBase},
            );
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
          child: Padding(
            padding: const EdgeInsets.symmetric (horizontal: scaffoldPadding, vertical: scaffoldPadding ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                Align(
                alignment: Alignment.centerRight,
                child: Icon(Icons.close, size: 30, color: lightTheme.colorScheme.surface),
              ),

                const SizedBox(height: 100),
                LargePurpleText("Add your Pal "),
                SizedBox(height: 10,),
                NormalGreyText("Lets create a personalized experience for your Pal."),

                // Logo
                SvgPicture.asset(
                  '$svgPath/add_pal_splash.svg',
                  height: 300,
                  width: 343,
                ),

                // gradientDivider(),
                const SizedBox(height: 30),
                NormalGreyText("Earn care points by completing this."),


                const SizedBox(height: 80),


              ],
            ),
          ),
        ),
      );
    }
  }