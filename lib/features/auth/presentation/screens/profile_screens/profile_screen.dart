import 'package:aiwel/components/textfields/auth_textfield.dart';
import 'package:flutter/material.dart';

import '../../../../../components/buttons/label_button.dart';
import '../../../../../components/constants.dart';
import '../../../../../components/text_widgets/text_widgets.dart';
import '../../../../../components/textfields/simple_textfield.dart';
import '../../view_models/sign_in_viewModel.dart';
import '../signin_signup_screen.dart';

class ProfileScreen extends StatelessWidget {
  static const String routeName = '/profile';
  final SignInViewModelBase viewModelBase;

  const ProfileScreen({super.key, required this.viewModelBase});

  @override
  Widget build(BuildContext context) {
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
      stops: [0.0, 0.2, 0.5, 0.8, 1.0],
      ),
      ),
        child:
        Padding(
          padding: const EdgeInsets.all(scaffoldPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              LargePurpleText("Let’s get to know you better."),
              SizedBox(height: 16),
              NormalGreyText("What’s the best way to reach you?"),
              const SizedBox(height: 32),
              SimpleTextField(
                hintText: "Enter your name",
                controller: viewModelBase.emailController,
                onChange: (value) => viewModelBase.clearError(),
                isEnabled: true,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.done,
              ),
              const SizedBox(height: 16),

              AuthTextfield(hintText: "Date of Birth",suffixIcon: Icon(Icons.calendar_month,color: Theme.of(context).hintColor,),),
              const SizedBox(height: 16),
              AuthTextfield(hintText: "Select Gender",suffixIcon: Icon(Icons.keyboard_arrow_down,color: Theme.of(context).hintColor,),),



            ],
          ),
        ),
      
      
      
      ),
      floatingActionButton:             LabelButton(
        label: 'Let’s get started',
        onTap: () {
          // Navigator.pushNamed(context, '/signinSignup');
          Navigator.pushNamed(context, SigninSignupScreen.routeName);

        },
        gradient: splashGradient(),
        // bgColor: const Color(0xffF6F6F6),
        fontColor: Theme.of(context).primaryColorLight,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
