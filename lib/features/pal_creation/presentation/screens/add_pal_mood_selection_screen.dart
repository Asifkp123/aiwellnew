import 'package:aiwel/features/pal_creation/presentation/screens/add_pal_sleep_pattern_screen.dart';
import 'package:aiwel/features/pal_creation/presentation/view_models/add_pal_view_model.dart';
import 'package:aiwel/features/pal_creation/widgets/back_button_with_point.dart';
import 'package:flutter/material.dart';

import '../../../../../../components/buttons/label_button.dart';
import '../../../../../../components/constants.dart';
import '../../../../../../components/text_widgets/text_widgets.dart';
import '../../../../components/snackbars/custom_snackbar.dart';
import '../../../auth/presentation/widgets/selectable_listView.dart';

class AddPalMoodSelectionScreen extends StatelessWidget {
  static const String routeName = '/addPalMoodSelectionScreen';
  final AddPalViewModel viewModelBase;
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  AddPalMoodSelectionScreen({super.key, required this.viewModelBase}) {
    // viewModelBase.startAnimationForEmotian(_listKey);
  }

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
                      currentPoints: 90,
                      totalPoints: 120,
                    ),
                    SizedBox(height: 60),

                    LargePurpleText(state.gender?.toLowerCase() == 'male'
                        ? "What kind of mood has he been in most of the time?"
                        : state.gender?.toLowerCase() == 'female'
                            ? "What kind of mood has she been in most of the time?"
                            : "What kind of mood have they been in most of the time?"),
                    SizedBox(height: 16),
                    NormalGreyText("Aiwel want you to be happy and pleasant "),
                    const SizedBox(height: 16),
                    SelectableListView(
                      items: viewModelBase.addPalMoodList,
                      selectedValue: state.dominant_emotion,
                      onItemSelected: viewModelBase.setDominantEmotion,
                    ),
                    // if (state.errorMessage != null) ...[
                    //   const SizedBox(height: 16),
                    //   Text(
                    //     state.errorMessage!,
                    //     style: TextStyle(color: Colors.red),
                    //   ),
                    // ],
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
              if (state.dominant_emotion == null) {
                ScaffoldMessenger.of(context).showSnackBar(commonSnackBarWidget(
                  content: "Please select an option before continuing.",
                  type: SnackBarType.error,
                ));
                return;
              }

              Navigator.pushNamed(
                context,
                AddPalSleepPatternScreen.routeName,
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
