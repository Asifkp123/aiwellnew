import 'package:aiwel/features/pal_creation/presentation/screens/add_pal_able_to_walk_screen.dart';
import 'package:aiwel/features/pal_creation/presentation/view_models/add_pal_view_model.dart';
import 'package:aiwel/features/pal_creation/widgets/big_textform_field.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../../../components/buttons/label_button.dart';
import '../../../../../../components/constants.dart';
import '../../../../../../components/snackbars/custom_snackbar.dart';
import '../../../../../../components/snackbars/error_snackbar.dart';
import '../../../../../../components/text_widgets/text_widgets.dart';
import '../../../../../../components/textfields/simple_textfield.dart';
import '../../../auth/presentation/view_models/sign_in_viewModel.dart';
import '../../../auth/presentation/widgets/back_button_widget.dart';
import '../../widgets/back_button_with_point.dart';

class AddPalDiagnosisScreen extends StatelessWidget {
  static const String routeName = '/addPalDiagnosisScreen';
  final AddPalViewModel viewModelBase;

  const AddPalDiagnosisScreen({super.key, required this.viewModelBase});


  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AddPalState>(
      stream: viewModelBase.stateStream,
      initialData: AddPalState(status: AddPalStateStatus.idle),
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
                children: [
                  SizedBox(height: 40),

                  BackButtonWithPointWidget(currentPoints: 20, totalPoints: 120,),
                  SizedBox(height: 40),

                  LargePurpleText("What is his primary diagnosis?"),
                  SizedBox(height: 16),
                  NormalGreyText("It helps us tailor Aiwel for you."),
                  const SizedBox(height: 32),
                  BigTextformField(
                    controller: viewModelBase.primaryDiagnosisController,
                  ),

                ],
              ),
            ),
          ),
          floatingActionButton: LabelButton(
            label: 'Continue',
            onTap: () {

              if(viewModelBase.primaryDiagnosisController.text.isEmpty){
                ScaffoldMessenger.of(context)!.showSnackBar(

                  commonSnackBarWidget(
                    content: "Please enter the primary diagnosis.",
                    type: SnackBarType.error,
                  ),
                );
                return;
              }
              Navigator.pushNamed(
                context,
                AddPalAbleToWalkScreen.routeName,
              );

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