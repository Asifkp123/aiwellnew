import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../../components/buttons/label_button.dart';
import '../../../../../components/constants.dart';
import '../../../../../components/snackbars/custom_snackbar.dart';
import '../../../../../components/snackbars/error_snackbar.dart';
import '../../../../../components/text_widgets/text_widgets.dart';
import '../../../../../components/textfields/simple_textfield.dart';
import '../../view_models/profile_view_model.dart';
import '../signin_signup_screen.dart';
import 'emotian_screen.dart';

class ProfileScreen extends StatelessWidget {
  static const String routeName = '/profile';
  final ProfileViewModelBase viewModelBase;

  const ProfileScreen({super.key, required this.viewModelBase});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ProfileState>(
      stream: viewModelBase.stateStream,
      initialData: ProfileState(status: ProfileStatus.idle),
      builder: (context, snapshot) {
        final state = snapshot.data!;
        return Scaffold(
          body: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient:
                  homeBackgroundGradient(context), // ✅ Now uses theme colors!
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
                  SimpleTextField(
                    hintText: "Enter your second name",
                    controller: viewModelBase.lastNameController,
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
                        suffixIcon: Icon(Icons.calendar_month,
                            color: Theme.of(context).hintColor),
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
                      hintStyle: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.1,
                        color: Theme.of(context).hintColor,
                      ),
                      suffixIcon: Icon(Icons.keyboard_arrow_down,
                          color: Theme.of(context).hintColor),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.1,
                      color: Colors.black, // Selected item text color
                    ),
                    value: (state.gender?.isEmpty ?? true)
                        ? null
                        : state.gender, // ✅ Fix: Handle empty string
                    items: ['Male', 'Female', 'Other']
                        .map((gender) => DropdownMenuItem(
                              value: gender,
                              child: Text(
                                gender,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 0.1,
                                  color: Colors
                                      .black, // Dropdown menu item text color
                                ),
                              ),
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
            // padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            label: 'Let’s get started',
            onTap: () {
              if (viewModelBase.nameController.text.isEmpty ||
                  viewModelBase.dateOfBirthController.text.isEmpty ||
                  viewModelBase.genderController.text.isEmpty) {
                // ScaffoldMessenger.of(context).showSnackBar(
                //     errorSnackBarWidget( "Please fill in all fields to proceed.")
                //  );

                ScaffoldMessenger.of(context)!.showSnackBar(
                  commonSnackBarWidget(
                    content: "Please fill in all fields to proceed.",
                    type: SnackBarType.error,
                  ),
                );

                return;
              }
              Navigator.pushNamed(
                context,
                EmotionScreen.routeName,
                arguments: {'viewModelBase': viewModelBase},
              );
            },
            gradient: splashGradient(context), // ✅ Now uses theme colors!
            fontColor: Theme.of(context).primaryColorLight,
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
        );
      },
    );
  }
}
