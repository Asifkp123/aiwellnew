import 'package:aiwel/features/pal_creation/presentation/screens/add_pal_down_quite_screen.dart';
import 'package:aiwel/features/pal_creation/presentation/view_models/add_pal_view_model.dart';
import 'package:aiwel/features/pal_creation/widgets/back_button_with_point.dart';
import 'package:flutter/material.dart';

import '../../../../../../components/buttons/label_button.dart';
import '../../../../../../components/constants.dart';
import '../../../../../../components/text_widgets/text_widgets.dart';
import '../../../../components/snackbars/custom_snackbar.dart';
import '../../../auth/presentation/widgets/selectable_listView.dart';
import '../../widgets/selctableListview_pal_creation.dart';

class AddPalSensitiveRestLessScreen extends StatelessWidget {
  static const String routeName = '/addPalSensitiveRestLessScreen';
  final AddPalViewModel viewModelBase;
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  AddPalSensitiveRestLessScreen({super.key, required this.viewModelBase});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AddPalState>(
      stream: viewModelBase.stateStream,
      initialData: viewModelBase.getCurrentStateWithControllers(),
      builder: (context, snapshot) {
        final state = snapshot.data!;
        return Scaffold(
          body: SingleChildScrollView(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: homeBackgroundGradient(context),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 40),
                    BackButtonWithPointWidget(
                        currentPoints: 70, totalPoints: 120),
                    SizedBox(height: 60),
                    LargePurpleText(state.gender?.toLowerCase() == 'male'
                        ? "Has he been feeling uneasy, restless, or a little more sensitive than usual"
                        : state.gender?.toLowerCase() == 'female'
                            ? "Has she been feeling uneasy, restless, or a little more sensitive than usual"
                            : "Have they been feeling uneasy, restless, or a little more sensitive than usual"),
                    SizedBox(height: 16),
                    NormalGreyText("Aiwel will keep you calm"),
                    const SizedBox(height: 16),
                    SelctablelistviewPalCreation(
                      items: viewModelBase.yesOrNoList,
                      selectedValue: state
                          .is_agitated, // Use is_agitated instead of selectedAbleToWalk
                      onItemSelected: viewModelBase
                          .setIsAgitated, // Use setIsAgitated instead of yesOrNoSelected
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
              if (state.is_agitated == null) {
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
                AddPalDownQuiteScreen.routeName,
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
