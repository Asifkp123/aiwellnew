import 'package:aiwel/components/constants.dart';
import 'package:aiwel/components/textfields/simple_textfield.dart';
import 'package:aiwel/components/buttons/label_button.dart';
import 'package:aiwel/components/text_widgets/text_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../components/snackbars/error_snackbar.dart';
import '../../../../components/snackbars/success_snackbar.dart';
import '../view_models/sign_in_viewModel.dart';
import 'otp_screen.dart';

class SigninSignupScreen extends StatelessWidget {
  static const String routeName = '/signinSignup';
  final SignInViewModelBase viewModelBase;

  const SigninSignupScreen({Key? key, required this.viewModelBase})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      viewModelBase.clearErrorMessage();
    });
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            width: double.infinity,
            height: 1000,
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
            child: StreamBuilder<SignInState>(
              stream: viewModelBase.stateStream,
              initialData: SignInState(status: SignInStatus.idle),
              builder: (context, snapshot) {
                final state = snapshot.data!;
                final isLoading = state.isLoading;
                final isOtpSent = state.isOtpSent;

                // Show SnackBar for feedback messages
                if (state.feedbackMessage != null) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      successSnackBarWidget(state.feedbackMessage!),
                    );
                    viewModelBase.clearFeedback();
                  });
                }

                return Padding(
                  padding: const EdgeInsets.all(scaffoldPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 130),
                      const SizedBox(height: 50),
                      LargePurpleText("Hey there!"),
                      const SizedBox(height: 16),
                      NormalGreyText("What’s the best way to reach you?"),
                      const SizedBox(height: 32),
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
                        const SizedBox(height: 8),
                        Text(
                          state.errorMessage!,
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 12,
                          ),
                        ),
                      ],
                      // StreamBuilder<SignInState>(
                      //   stream: viewModelBase.stateStream,
                      //   initialData: SignInState(status: SignInStatus.idle),
                      //   builder: (context, snapshot) {
                      //     final state = snapshot.data!;
                      //     final isLoading = state.isLoading;
                      //     final isOtpSent = state.isOtpSent;
                      //
                      //     // if (isOtpSent && state.errorMessage == null&& ModalRoute.of(context)?.settings.name == SigninSignupScreen.routeName) {
                      //     //   print("hrerere");
                      //     //   WidgetsBinding.instance.addPostFrameCallback((_) {
                      //     //     Navigator.pushNamed(
                      //     //       context,
                      //     //       OtpScreen.routeName,
                      //     //       arguments: viewModelBase,
                      //     //     );
                      //     //     viewModelBase.clearOtpSentFlag();
                      //     //   });
                      //     // }
                      //
                      //     return LabelButton(
                      //       label: isLoading ? 'Sending...' : 'Get OTP',
                      //       onTap: isLoading
                      //           ? null
                      //           : () {
                      //        var result   =viewModelBase.requestOtp();
                      //        if(result.){
                      //          WidgetsBinding.instance.addPostFrameCallback((_) {
                      //            Navigator.pushNamed(
                      //              context,
                      //              OtpScreen.routeName,
                      //              arguments: viewModelBase,
                      //            );
                      //            viewModelBase.clearOtpSentFlag();
                      //          });
                      //        }
                      //       },
                      //       gradient: splashGradient(),
                      //       fontColor: Theme.of(context).primaryColorLight,
                      //     );
                      //   },
                      // ),
                      LabelButton(
                        label: isLoading ? 'Sending...' : 'Get OTP',
                        onTap: isLoading
                            ? null
                            : () async {
                                final result = await viewModelBase.requestOtp();
                                result.fold(
                                  (failure) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      errorSnackBarWidget(failure.message),
                                    );
                                  },
                                  (success) {
                                    Navigator.pushNamed(
                                      context,
                                      OtpScreen.routeName,
                                      arguments: viewModelBase,
                                    ).then((_) {
                                      viewModelBase.clearErrorMessage();
                                    });
                                    viewModelBase.clearOtpSentFlag();
                                  },
                                );
                              },
                        gradient: splashGradient(),
                        fontColor: Theme.of(context).primaryColorLight,
                      ),
                      const SizedBox(height: 250),

                      Center(
                        child: SvgPicture.asset(
                          '$svgPath/applogo.svg',
                          height: 120,
                          width: 120,
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
      // floatingActionButton: StreamBuilder<SignInState>(
      //   stream: viewModelBase.stateStream,
      //   initialData: SignInState(status: SignInStatus.idle),
      //   builder: (context, snapshot) {
      //     final state = snapshot.data!;
      //     final isLoading = state.isLoading;
      //     final isOtpSent = state.isOtpSent;
      //
      //     if (isOtpSent && state.errorMessage == null) {
      //       WidgetsBinding.instance.addPostFrameCallback((_) {
      //         Navigator.pushNamed(
      //           context,
      //           OtpScreen.routeName,
      //           arguments: viewModelBase,
      //         );
      //         viewModelBase.clearOtpSentFlag();
      //       });
      //     }
      //
      //     return LabelButton(
      //       label: isLoading ? 'Sending...' : 'Get OTP',
      //       onTap: isLoading
      //           ? null
      //           : () {
      //         viewModelBase.requestOtp();
      //       },
      //       gradient: splashGradient(),
      //       fontColor: Theme.of(context).primaryColorLight,
      //     );
      //   },
      // ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
