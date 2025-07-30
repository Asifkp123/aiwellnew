import 'package:aiwel/components/constants.dart';
import 'package:aiwel/components/textfields/simple_textfield.dart';
import 'package:aiwel/components/buttons/label_button.dart';
import 'package:aiwel/components/text_widgets/text_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../components/snackbars/error_snackbar.dart';
import '../../../../components/snackbars/success_snackbar.dart';
import '../view_models/auth_view_model.dart';
import 'otp_screen.dart';

class SigninSignupScreen extends StatelessWidget {
  static const String routeName = '/signinSignup';
  final AuthViewModelBase viewModelBase;

  const SigninSignupScreen({Key? key, required this.viewModelBase})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenHeight = screenSize.height;
    final screenWidth = screenSize.width;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      viewModelBase.clearErrorMessage();
    });
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            width: double.infinity,
            height: screenHeight,
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
            child: StreamBuilder<AuthState>(
              stream: viewModelBase.stateStream,
              initialData: AuthState(status: AuthStatus.idle),
              builder: (context, snapshot) {
                final state = snapshot.data!;
                final isLoading = state.isLoading;
                final isOtpSent = state.isOtpSent;

                return Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.05,
                    vertical: screenHeight * 0.02,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: screenHeight * 0.15),
                      SizedBox(height: screenHeight * 0.06),
                      LargePurpleText("Hey there!"),
                      SizedBox(height: screenHeight * 0.02),
                      NormalGreyText("What's the best way to reach you?"),
                      SizedBox(height: screenHeight * 0.04),
                      SimpleTextField(
                        hintText: "Enter email/ phone number",
                        controller: viewModelBase.emailController,
                        onChange: (value) => viewModelBase.clearError(),
                        isEnabled: !isOtpSent,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.done,
                      ),

                      //
                      if (state.errorMessage != null && !isOtpSent) ...[
                        SizedBox(height: screenHeight * 0.01),
                        Text(
                          state.errorMessage!,
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: screenWidth * 0.03,
                          ),
                        ),
                      ],

                      LabelButton(
                        label: isLoading ? 'Sending...' : 'Get OTP',
                        onTap: isLoading
                            ? null
                            : () async {
                                await viewModelBase
                                    .requestOtpWithNavigation(context);
                              },
                        gradient: splashGradient(),
                        fontColor: Theme.of(context).primaryColorLight,
                      ),
                      SizedBox(height: screenHeight * 0.25),

                      Center(
                        child: SvgPicture.asset(
                          '$svgPath/applogo.svg',
                          height: screenWidth * 0.3,
                          width: screenWidth * 0.3,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
