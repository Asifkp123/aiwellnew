import 'package:aiwel/components/constants.dart';
import 'package:aiwel/components/snackbars/success_snackbar.dart';
import 'package:aiwel/components/buttons/label_button.dart';
import 'package:aiwel/components/text_widgets/text_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../view_models/sign_in_viewModel.dart';
import '../widgets/pinput_widget.dart';

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
              final canResendOtp = state.countdownSeconds == 0 && !isLoading;
              final isCountdownActive = state.countdownSeconds > 0 || state.status == SignInStatus.otpSent;

              // Show feedback message if present
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
                    const SizedBox(height: 115),
                    Center(
                      child: SvgPicture.asset(
                        '$svgPath/applogo.svg',
                        height: 120,
                        width: 120,
                      ),
                    ),
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
                            text: 'Check your messages - we just sent a 6 digit code to ',
                          ),
                          TextSpan(
                            text: viewModelBase.emailController.text.isNotEmpty
                                ? viewModelBase.emailController.text
                                : 'email__here@.com',
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
                    const SizedBox(height: 32),
                    PinputWidget(
                      controller: viewModelBase.otpController,
                      onChanged: (value) => viewModelBase.clearError(),
                      onCompleted: (pin) => viewModelBase.verifyOtp(),
                    ),
                    if (state.errorMessage != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        state.errorMessage!,
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 12,
                        ),
                      ),
                    ],
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        RichText(
                          text: TextSpan(
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: const Color(0xFF606060),
                              fontWeight: FontWeight.w400,
                            ),
                            children: [
                              const TextSpan(text: "Didn't get the code? "),
                              TextSpan(
                                text: isCountdownActive
                                    ? 'Resend in ${state.countdownSeconds}s'
                                    : 'Resend',
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                        TextButton(
                          onPressed: canResendOtp
                              ? () async {
                            final result = await viewModelBase.requestOtp();
                            // Feedback is handled via state.feedbackMessage
                          }
                              : null,
                          style: TextButton.styleFrom(
                            foregroundColor: canResendOtp ? Colors.indigo : Colors.grey,
                            textStyle: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          child: const Text("Resend OTP"),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
      floatingActionButton: StreamBuilder<SignInState>(
        stream: viewModelBase.stateStream,
        initialData: SignInState(status: SignInStatus.idle),
        builder: (context, snapshot) {
          final state = snapshot.data!;
          final isLoading = state.isLoading;
          return LabelButton(
            label: isLoading ? 'Verifying...' : 'Verify OTP',
            onTap: isLoading
                ? null
                : () async {
              final result = await viewModelBase.verifyOtp();
              if (result.isRight()) {
                viewModelBase.clearInputs();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Sign-in successful!")),
                );
                // Navigate to next screen if needed
              }
            },
            gradient: splashGradient(),
            fontColor: Theme.of(context).primaryColorLight,
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}