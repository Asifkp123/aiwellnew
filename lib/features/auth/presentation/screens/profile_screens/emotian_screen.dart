import 'package:aiwel/components/snackbars/error_snackbar.dart';
import 'package:aiwel/features/auth/presentation/screens/profile_screens/workout_screen.dart';
import 'package:aiwel/features/auth/presentation/widgets/back_button_widget.dart';
import 'package:flutter/material.dart';
import '../../../../../components/buttons/label_button.dart';
import '../../../../../components/constants.dart';
import '../../../../../components/snackbars/custom_snackbar.dart';
import '../../../../../components/text_widgets/text_widgets.dart';
import '../../view_models/sign_in_viewModel.dart';
import '../../widgets/selectable_listView.dart';
import '../../widgets/three_circle_conatiner.dart';
import 'sleep_quality_screen.dart';

class EmotianScreen extends StatelessWidget {
  static const String routeName = '/emotianScreen';
  final SignInViewModelBase viewModelBase;
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  EmotianScreen({super.key, required this.viewModelBase}) {
    // viewModelBase.startAnimationForEmotian(_listKey);
  }

  @override
  Widget build(BuildContext context) {
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
                    SizedBox(height: 40),

                    BackButtonWidget(),
                    SizedBox(height: 60),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        CircleContainer(filled: true, onTap: () {}),
                        SizedBox(width: 5),
                        CircleContainer(
                          filled: false,
                          onTap: () => Navigator.pushNamed(context, SleepQualityScreen.routeName, arguments: viewModelBase),
                        ),
                        SizedBox(width: 5),
                        CircleContainer(
                          filled: false,
                          onTap: () => Navigator.pushNamed(context, WorkoutScreen.routeName, arguments: viewModelBase),
                        ),
                      ],
                    ),
                    LargePurpleText("How has your mood been lately?"),
                    SizedBox(height: 16),
                    NormalGreyText("Quick check-in before we get started."),
                    const SizedBox(height: 16),
                    SelectableListView(
                      items: viewModelBase.displayedMoods,
                      selectedValue: state.selectedMood,
                      onItemSelected: viewModelBase.selectMood,
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

              if (state.selectedMood == null) {
                    ScaffoldMessenger.of(context)!.showSnackBar(

                      commonSnackBarWidget(
                        content: "Please fill in all fields to proceed.",
                        type: SnackBarType.error,
                      ),
                    );

                return;
              }

                  Navigator.pushNamed(context, SleepQualityScreen.routeName, arguments: viewModelBase);
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