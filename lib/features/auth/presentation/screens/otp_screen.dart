import 'package:aiwel/features/auth/presentation/screens/profile_screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:aiwel/components/buttons/label_button.dart';
import 'package:aiwel/components/constants.dart';
import 'package:aiwel/components/snackbars/success_snackbar.dart';
import 'package:aiwel/components/text_widgets/text_widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../home/home_screen.dart';
import '../view_models/sign_in_viewModel.dart';
import '../widgets/keyboard.dart';

class OtpScreen extends StatelessWidget {
  static const String routeName = '/otpScreen';
  final SignInViewModelBase viewModelBase;

  const OtpScreen({Key? key, required this.viewModelBase}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
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
          child: StreamBuilder<SignInState>(
            stream: viewModelBase.stateStream,
            initialData: SignInState(status: SignInStatus.idle),
            builder: (context, snapshot) {
              final state = snapshot.data!;
              final isLoading = state.isLoading;

              final canResendOtp = state.countdownSeconds == 0 && !isLoading;
              final isCountdownActive = state.countdownSeconds > 0 ||
                  state.status == SignInStatus.otpSent;

              if (state.feedbackMessage != null) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  successSnackBarWidget(state.feedbackMessage!);
                  viewModelBase.clearFeedback();
                });
              }

              return Padding(
                padding: const EdgeInsets.all(scaffoldPadding),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 100),
                      // Center(
                      //   child: SvgPicture.asset(
                      //     '$svgPath/applogo.svg',
                      //     height: 120,
                      //     width: 120,
                      //   ),
                      // ),
                      const SizedBox(height: 50),
                      LargePurpleText("We’ve sent you a code"),
                      const SizedBox(height: 16),
                      RichText(
                        text: TextSpan(
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                            color: const Color(0xFF606060),
                            fontWeight: FontWeight.w400,
                            height: 1.5,
                          ),
                          children: [
                            const TextSpan(
                              text:
                                  'Check your messages - we just sent a 6 digit code to ',
                            ),
                            TextSpan(
                              text: viewModelBase.emailController.text,
                              style: GoogleFonts.poppins(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            const TextSpan(
                              text: '. Enter it below to continue.',
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 15),

                      // CustomPinInput(
                      //
                      //   controller: viewModelBase.otpController,
                      //   onCompleted: (_) async {
                      //     final result = await viewModelBase.verifyOtp();
                      //     if (result.isRight()) {
                      //       viewModelBase.clearInputs();
                      //       ScaffoldMessenger.of(context).showSnackBar(
                      //         successSnackBarWidget("OTP verified successfully!"),
                      //       );
                      //
                      //       Navigator.pushNamed(context, ProfileScreen.routeName, arguments: viewModelBase);
                      //
                      //     }
                      //
                      //
                      //   },
                      //   isLoading: state.isLoading,
                      // ),

                      CustomPinInput(
                        controller: viewModelBase.otpController,
                        onCompleted: (_) async {
                          final result = await viewModelBase.verifyOtp();
                          result.fold(
                            (failure) {
                              // Optionally show error
                            },
                            (response) {
                              viewModelBase.clearInputs();
                              if (response.isApproved == true) {
                                Navigator.pushReplacementNamed(
                                    context, HomeScreen.routeName);
                              } else {
                                Navigator.pushReplacementNamed(
                                    context, ProfileScreen.routeName,
                                    arguments: viewModelBase);
                              }
                            },
                          );
                        },
                        isLoading: state.isLoading,
                        countdownSeconds: state.countdownSeconds,
                        canResend:
                            state.countdownSeconds == 0 && !state.isLoading,
                        onResend: viewModelBase.requestOtp,
                        errorMessage: state.errorMessage,
                      ),

                      const SizedBox(height: 16),
                    ]),
              );
            },
          ),
        ),
      ),
    );
  }
}
