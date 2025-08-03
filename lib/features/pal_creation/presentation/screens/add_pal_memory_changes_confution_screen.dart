import 'package:aiwel/features/pal_creation/presentation/screens/add_pal_sensitive_rest_less_screen.dart';
import 'package:aiwel/features/pal_creation/presentation/view_models/add_pal_view_model.dart';
import 'package:aiwel/features/pal_creation/widgets/back_button_with_point.dart';
import 'package:flutter/material.dart';

import '../../../../../../components/buttons/label_button.dart';
import '../../../../../../components/constants.dart';
import '../../../../../../components/text_widgets/text_widgets.dart';
import '../../../../components/snackbars/custom_snackbar.dart';
import '../../../auth/presentation/widgets/selectable_listView.dart';
import '../../widgets/selctableListview_pal_creation.dart';

class AddPalMemoryChangesConfutionScreen extends StatelessWidget {
  static const String routeName = '/addPalMemoryChangesConfutionScreen';
  final AddPalViewModel viewModelBase;
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  AddPalMemoryChangesConfutionScreen({super.key, required this.viewModelBase});

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
                        currentPoints: 60, totalPoints: 120),
                    SizedBox(height: 60),
                    LargePurpleText(state.gender?.toLowerCase() == 'male'
                        ? "Have you noticed any memory changes or moments of confusion in him lately?"
                        : state.gender?.toLowerCase() == 'female'
                            ? "Have you noticed any memory changes or moments of confusion in her lately?"
                            : "Have you noticed any memory changes or moments of confusion in them lately?"),
                    SizedBox(height: 16),
                    NormalGreyText("Aiwel can help them if they forget"),
                    const SizedBox(height: 16),
                    SelctablelistviewPalCreation(
                      items: viewModelBase.yesOrNoList,
                      selectedValue: state
                          .has_dementia, // Use has_dementia instead of selectedAbleToWalk
                      onItemSelected: viewModelBase
                          .setHasDementia, // Use setHasDementia instead of yesOrNoSelected
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
              if (state.has_dementia == null) {
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
                AddPalSensitiveRestLessScreen.routeName,
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
