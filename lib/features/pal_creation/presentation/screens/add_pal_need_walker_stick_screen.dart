import 'package:aiwel/features/pal_creation/presentation/screens/add_pal_resting_bed_screen.dart';
import 'package:aiwel/features/pal_creation/presentation/view_models/add_pal_view_model.dart';
import 'package:aiwel/features/pal_creation/widgets/back_button_with_point.dart';
import 'package:flutter/material.dart';

import '../../../../../../components/buttons/label_button.dart';
import '../../../../../../components/constants.dart';
import '../../../../../../components/text_widgets/text_widgets.dart';
import '../../../../components/snackbars/custom_snackbar.dart';
import '../../../auth/presentation/widgets/selectable_listView.dart';
import '../../widgets/selctableListview_pal_creation.dart';
import 'add_pal_diagnosis_screen.dart';

class AddPalNeedWalkerStickScreen extends StatelessWidget {
  static const String routeName = '/addPalNeedWalkerStickScreen';
  final AddPalViewModel viewModelBase;
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  AddPalNeedWalkerStickScreen({super.key, required this.viewModelBase});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AddPalState>(
      stream: viewModelBase.stateStream,
      initialData: AddPalState(status: AddPalStateStatus.idle),
      builder: (context, snapshot) {
        final state = snapshot.data!;
        print(state.needs_walking_aid);
        print("state.needs_walking_ai");
        return Scaffold(
          body: SingleChildScrollView(
            child: Container(
              width: double.infinity,
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
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 40),
                    BackButtonWithPointWidget(
                        currentPoints: 40, totalPoints: 120),
                    SizedBox(height: 60),
                    LargePurpleText(
                        "Do they need a little help to move around, like a walker or stick?"),
                    SizedBox(height: 16),
                    NormalGreyText("Aiwel has dedicated support equipments"),
                    const SizedBox(height: 16),
                    SelctablelistviewPalCreation(
                      items: viewModelBase.yesOrNoList,
                      selectedValue: state
                          .needs_walking_aid, // Use needs_walking_aid instead of selectedAbleToWalk
                      onItemSelected: viewModelBase
                          .setNeedsWalkingAid, // Correct method for this question
                    ),
                    if (state.errorMessage != null) ...[
                      const SizedBox(height: 16),
                      Text(
                        state.errorMessage!,
                        style: TextStyle(color: Colors.red),
                      ),
                    ],
                    SizedBox(height: 50),
                  ],
                ),
              ),
            ),
          ),
          floatingActionButton: LabelButton(
            label: 'Continue',
            onTap: () {
              // Check if a selection has been made
              if (state.needs_walking_aid == null) {
                ScaffoldMessenger.of(context)!
                    .showSnackBar(commonSnackBarWidget(
                  content: "Please select an option before continuing.",
                  type: SnackBarType.error,
                ));
                return;
              }

              // Navigate to the next screen with the viewModelBase
              Navigator.pushNamed(
                context,
                AddPalRestingBedScreen.routeName,
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
