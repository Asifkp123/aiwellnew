import 'package:aiwel/features/auth/presentation/widgets/three_circle_conatiner.dart';
import 'package:flutter/material.dart';

import '../../../../../components/buttons/label_button.dart';
import '../../../../../components/constants.dart';
import '../../../../../components/snackbars/error_snackbar.dart';
import '../../../../../components/text_widgets/text_widgets.dart';
import '../../view_models/profile_view_model.dart';
import '../../widgets/back_button_widget.dart';
import '../../widgets/selectable_listView.dart';

class WorkoutScreen extends StatelessWidget {
  static const String routeName = '/workoutScreen';
  final ProfileViewModelBase viewModelBase;

  const WorkoutScreen({super.key, required this.viewModelBase});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return StreamBuilder<ProfileState>(
      stream: viewModelBase.stateStream,
      initialData: ProfileState(status: ProfileStatus.idle),
      builder: (context, snapshot) {
        final state = snapshot.data!;
        return Scaffold(
          body: SingleChildScrollView(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient:
                    homeBackgroundGradient(context), // ✅ Now uses theme colors!
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
