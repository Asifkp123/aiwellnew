import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../../components/buttons/label_button.dart';
import '../../../../../components/constants.dart';
import '../../../../../components/snackbars/error_snackbar.dart';
import '../../../../../components/text_widgets/text_widgets.dart';
import '../../../../../components/textfields/simple_textfield.dart';
import '../../view_models/sign_in_viewModel.dart';
import '../signin_signup_screen.dart';
import 'emotian_screen.dart';

class ProfileScreen extends StatelessWidget {
  static const String routeName = '/profile';
  final SignInViewModelBase viewModelBase;

  const ProfileScreen({super.key, required this.viewModelBase});


  @override
  Widget build(BuildContext context) {
    return StreamBuilder<SignInState>(
      stream: viewModelBase.stateStream,
      initialData: SignInState(status: SignInStatus.idle),
      builder: (context, snapshot) {
        final state = snapshot.data!;
        return Scaffold(
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
            child: Padding(
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
                    controller: viewModelBase.nameController,
                    onChange: (value) => viewModelBase.clearError(),
                    isEnabled: true,
                    keyboardType: TextInputType.name,
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: () => viewModelBase.selectDate(context),
                    child: AbsorbPointer(
                      child: SimpleTextField(
                        hintText: "Date of Birth",
                        controller: viewModelBase.dateOfBirthController,
                        suffixIcon: Icon(Icons.calendar_month, color: Theme.of(context).hintColor),
                        isEnabled: true,
                        keyboardType: TextInputType.datetime,
                        textInputAction: TextInputAction.next,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      hintText: "Select Gender",
                      suffixIcon: Icon(Icons.keyboard_arrow_down, color: Theme.of(context).hintColor),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    value: state.gender,
                    items: ['Male', 'Female', 'Other']
                        .map((gender) => DropdownMenuItem(
                      value: gender,
                      child: Text(gender),
                    ))
                        .toList(),
                    onChanged: (value) {
                      viewModelBase.genderController.text = value ?? '';
                      viewModelBase.clearError();
                    },
                  ),
                  if (state.errorMessage != null) ...[
                    const SizedBox(height: 16),
                    Text(
                      state.errorMessage!,
                      style: TextStyle(color: Colors.red),
                    ),
                  ],
                ],
              ),
            ),
          ),
          floatingActionButton: LabelButton(
            label: 'Let’s get started',
            onTap: () {
              if (viewModelBase.nameController.text.isEmpty ||
                  viewModelBase.dateOfBirthController.text.isEmpty ||
                  viewModelBase.genderController.text.isEmpty) {
                 ScaffoldMessenger.of(context).showSnackBar(
                     errorSnackBarWidget( "Please fill in all fields to proceed.")
                  );

                return;
              }
              Navigator.pushNamed(context, EmotianScreen.routeName, arguments: viewModelBase);
            },
            gradient: splashGradient(),
            fontColor: Theme.of(context).primaryColorLight,
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        );
      },
    );
  }
}