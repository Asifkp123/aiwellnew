import 'package:aiwel/features/auth/presentation/screens/profile_screens/workout_screen.dart';
import 'package:aiwel/features/auth/presentation/widgets/back_button_widget.dart';
import 'package:aiwel/features/auth/presentation/widgets/three_circle_conatiner.dart';
import 'package:flutter/material.dart';

import '../../../../../components/buttons/label_button.dart';
import '../../../../../components/constants.dart';
import '../../../../../components/snackbars/custom_snackbar.dart';
import '../../../../../components/snackbars/error_snackbar.dart';
import '../../../../../components/text_widgets/text_widgets.dart';
import '../../view_models/sign_in_viewModel.dart';
import '../../widgets/selectable_listView.dart';
import '../../widgets/slider_animation.dart';
import '../signin_signup_screen.dart';

class SleepQualityScreen extends StatelessWidget {
  static const String routeName = '/sleepQualityScreen';
  final SignInViewModelBase viewModelBase;
  final GlobalKey<AnimatedListState> _sleepListKey =
      GlobalKey<AnimatedListState>();

  SleepQualityScreen({super.key, required this.viewModelBase}) {
    // viewModelBase.startAnimationForSleep(_sleepListKey);
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return StreamBuilder<SignInState>(
      stream: viewModelBase.stateStream,
      initialData: SignInState(status: SignInStatus.idle),
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
                    SizedBox(height: 60),

                    BackButtonWidget(),
                    SizedBox(height: 60),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        CircleContainer(
                          filled: true,
                          onTap: () =>
                              Navigator.pushNamed(context, '/emotianScreen'),
                        ),
                        SizedBox(width: 5),
                        CircleContainer(
                          filled: true,
                          onTap: () => Navigator.pushNamed(
                              context, '/sleepQualityScreen',
                              arguments: viewModelBase),
                        ),
                        SizedBox(width: 5),
                        CircleContainer(
                          filled: false,
                          onTap: () => Navigator.pushNamed(
                              context, '/workoutScreen',
                              arguments: viewModelBase),
                        ),
                      ],
                    ),
                    LargePurpleText("Sleeping well these days?"),
                    SizedBox(height: 16),
                    NormalGreyText("Quick check-in before we get started."),
                    const SizedBox(height: 16),
                    // SizedBox(
                    //   height: height - 200, // Adjusted to prevent overflow
                    //   child: AnimatedList(
                    //     key: _sleepListKey,
                    //     physics: NeverScrollableScrollPhysics(),
                    //     initialItemCount: viewModelBase.displayedSleeps.length,
                    //     itemBuilder: (context, index, animation) {
                    //       return buildItem(
                    //         viewModelBase.displayedSleeps[index],
                    //         animation,
                    //         viewModelBase,
                    //         state.selectedSleep,
                    //       );
                    //     },
                    //   ),
                    // ),
                    SelectableListView(
                      items: viewModelBase.displayedSleeps,
                      selectedValue: state
                          .selectedSleep, // Use state.selectedMood instead of direct field access
                      onItemSelected: viewModelBase
                          .selectSleep, // Use the method from the view model
                    ),
                  ],
                ),
              ),
            ),
          ),
          floatingActionButton: LabelButton(
            label: 'Continue',
            onTap: () {
              if (state.selectedSleep == null) {
                ScaffoldMessenger.of(context)!.showSnackBar(
                  commonSnackBarWidget(
                    content: "Please fill in all fields to proceed.",
                    type: SnackBarType.error,
                  ),
                );

                return;
              }

              Navigator.pushNamed(context, WorkoutScreen.routeName,
                  arguments: {'viewModelBase': viewModelBase});
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
