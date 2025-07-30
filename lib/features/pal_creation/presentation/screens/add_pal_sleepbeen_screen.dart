import 'package:aiwel/features/pal_creation/presentation/screens/add_pal_discomfort_pain_screen.dart';
import 'package:aiwel/features/pal_creation/presentation/view_models/add_pal_view_model.dart';
import 'package:aiwel/features/pal_creation/widgets/back_button_with_point.dart';
import 'package:flutter/material.dart';

import '../../../../../../components/buttons/label_button.dart';
import '../../../../../../components/constants.dart';
import '../../../../../../components/text_widgets/text_widgets.dart';
import '../../../../components/snackbars/custom_snackbar.dart';
import '../../../auth/presentation/widgets/selectable_listView.dart';

class AddPalSleepbeenScreen extends StatelessWidget {
  static const String routeName = '/addPalSleepbeenScreen';
  final AddPalViewModel viewModelBase;
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  AddPalSleepbeenScreen({super.key, required this.viewModelBase}) {
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
                      currentPoints: 110,
                      totalPoints: 120,
                    ),
                    SizedBox(height: 60),

                    LargePurpleText(state.gender?.toLowerCase() == 'male'
                        ? "How well has he been sleeping lately?"
                        : state.gender?.toLowerCase() == 'female'
                            ? "How well has she been sleeping lately?"
                            : "How well have they been sleeping lately?"),
                    SizedBox(height: 16),
                    NormalGreyText(
                        "Aiwel will help you and your pal sleep peacefully"),
                    const SizedBox(height: 16),
                    SelectableListView(
                      items: viewModelBase.sleepBeenList,
                      selectedValue: state.sleep_quality,
                      onItemSelected: viewModelBase.setSleepQuality,
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
              if (state.sleep_quality == null) {
                ScaffoldMessenger.of(context)!
                    .showSnackBar(commonSnackBarWidget(
                  content: "Please select an option before continuing.",
                  type: SnackBarType.error,
                ));
                return;
              }
              Navigator.pushNamed(
                context,
                AddPalDiscomfortOrPainScreen.routeName,
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
