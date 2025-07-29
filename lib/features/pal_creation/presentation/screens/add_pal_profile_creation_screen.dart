import 'package:aiwel/features/pal_creation/presentation/view_models/add_pal_view_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../../../components/buttons/label_button.dart';
import '../../../../../../components/constants.dart';
import '../../../../../../components/snackbars/custom_snackbar.dart';
import '../../../../../../components/snackbars/error_snackbar.dart';
import '../../../../../../components/text_widgets/text_widgets.dart';
import '../../../../../../components/textfields/simple_textfield.dart';
import '../../../auth/presentation/widgets/back_button_widget.dart';
import '../../widgets/back_button_with_point.dart';
import 'add_pal_diagnosis_screen.dart';

class AddPalProfileCreationScreen extends StatelessWidget {
  static const String routeName = '/addPalProfileCreationScreen';
  final AddPalViewModel viewModelBase;

  const AddPalProfileCreationScreen({super.key, required this.viewModelBase});

  @override
  Widget build(BuildContext context) {
    print(
        "🌟 AddPalProfileCreationScreen build - viewModelBase: ${viewModelBase.hashCode}");
    return StreamBuilder<AddPalState>(
      stream: viewModelBase.stateStream,
      initialData: AddPalState(status: AddPalStateStatus.idle),
      builder: (context, snapshot) {
        final state = snapshot.data!;
        print("🌟 ProfileScreen state.gender: ${state.gender}");
        print(
            "🌟 ProfileScreen genderController.text: ${viewModelBase.genderController.text}");
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
                children: [
                  SizedBox(height: 40),
                  BackButtonWithPointWidget(
                      currentPoints: 10, totalPoints: 120),
                  SizedBox(height: 40),
                  LargePurpleText("Let’s get to know you better."),
                  SizedBox(height: 16),
                  NormalGreyText("It helps us tailor Aiwel for you."),
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
                        fontWeight: FontWeight.w400,
                        letterSpacing: 0.1,
                        color: Theme.of(context).colorScheme.surface,
                      ),
                      // suffixIcon: Icon(Icons.keyboard_arrow_down, color: Theme.of(context).hintColor),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.1,
                      // color: Colors.black,
                      color: Theme.of(context).colorScheme.surface,
                    ),
                    value: state.gender,
                    items: ['Male', 'Female', 'Other']
                        .map<DropdownMenuItem<String>>(
                            (gender) => DropdownMenuItem<String>(
                                  value: gender,
                                  child: Text(
                                    gender,
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: 0.1,
                                      color: Colors.black,
                                    ),
                                  ),
                                ))
                        .toList(),
                    onChanged: (value) {
                      print("🔥 Gender selected: $value");
                      viewModelBase.genderController.text = value ?? '';
                      print(
                          "🔥 Controller updated: ${viewModelBase.genderController.text}");
                      viewModelBase.updateStateWithControllers(); // Sync controller to state
                      print("🔥 updateStateWithControllers called");
                      viewModelBase.clearError();
                    },
                  ),
                ],
              ),
            ),
          ),
          floatingActionButton: LabelButton(
            label: 'Continue',
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
                AddPalDiagnosisScreen.routeName,
                arguments: {'viewModelBase': viewModelBase},
              );
            },
            gradient: splashGradient(),
            fontColor: Theme.of(context).primaryColorLight,
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
        );
      },
    );
  }
}
