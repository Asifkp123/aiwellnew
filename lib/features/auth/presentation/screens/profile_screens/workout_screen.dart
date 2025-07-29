import 'package:aiwel/features/auth/presentation/screens/profile_screens/profile_screen.dart';
import 'package:aiwel/features/auth/presentation/widgets/three_circle_conatiner.dart';
import 'package:aiwel/features/home/home_screen.dart';
import 'package:flutter/material.dart';

import '../../../../../components/buttons/label_button.dart';
import '../../../../../components/constants.dart';
import '../../../../../components/snackbars/custom_snackbar.dart';
import '../../../../../components/snackbars/error_snackbar.dart';
import '../../../../../components/text_widgets/text_widgets.dart';
import '../../view_models/sign_in_viewModel.dart';
import '../../widgets/back_button_widget.dart';
import '../../widgets/selectable_listView.dart';
import '../../widgets/slider_animation.dart';
import '../otp_screen.dart';
import '../signin_signup_screen.dart';
import '../../../../../core/state/app_state_manager.dart';

class WorkoutScreen extends StatelessWidget {
  static const String routeName = '/workoutScreen';
  final SignInViewModelBase viewModelBase;

  const WorkoutScreen({super.key, required this.viewModelBase});

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
                    Color(0xFFE4D6FA), // light purple
                    Color(0xFFF1EAFE), // even lighter
                    Color(0xFFFFFFFF), // white middle
                    Color(0xFFF1EAFE),
                    Color(0xFFE4D6FA),
                  ],
                  stops: [0.0, 0.2, 0.5, 0.8, 1.0],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                // Fallback if scaffoldPadding is not defined
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
                              context, '/sleepQualityScreen'),
                        ),
                        SizedBox(width: 5),
                        CircleContainer(
                          filled: true,
                          onTap: () =>
                              Navigator.pushNamed(context, '/workoutScreen'),
                        ),
                      ],
                    ),
                    LargePurpleText("What about workouts?"),
                    SizedBox(height: 16),
                    NormalGreyText("Quick check-in before we get started."),
                    const SizedBox(height: 16),
                    // SizedBox(
                    //   height:height ,
                    //   child: AnimatedList(
                    //     key: viewModelBase.listKey,
                    //     physics: NeverScrollableScrollPhysics(),
                    //     initialItemCount: viewModelBase.displayedMoods.length,
                    //     itemBuilder: (context, index, animation) {
                    //       return buildItem(
                    //           viewModelBase.displayedMoods[index], animation,
                    //           viewModelBase, state.selectedMood);
                    //     },
                    //   ),
                    // ),

                    SelectableListView(
                      items: viewModelBase.displayedWorkouts,
                      selectedValue: state
                          .selectedWorkout, // Use state.selectedMood instead of direct field access
                      onItemSelected: viewModelBase
                          .selectWorkout, // Use the method from the view model
                    ),
                  ],
                ),
              ),
            ),
          ),
          floatingActionButton: LabelButton(
            label: 'Continue',
            onTap: () async {
              if (state.selectedWorkout == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  errorSnackBarWidget(
                    "Please pick your workout level to move forward.",
                  ),
                );
                return;
              }

              await viewModelBase.submitProfile(context);
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
