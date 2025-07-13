import 'package:aiwel/features/home/home_screen.dart';
import 'package:aiwel/features/pal_creation/presentation/view_models/add_pal_view_model.dart';
import 'package:aiwel/features/pal_creation/widgets/QuestionnaireSection.dart';
import 'package:aiwel/features/pal_creation/widgets/back_button_with_point.dart';
import 'package:aiwel/features/pal_creation/widgets/name_date_gender_widget.dart';
import 'package:flutter/material.dart';
import '../../../../../../components/buttons/label_button.dart';
import '../../../../../../components/constants.dart';
import '../../../../../../components/text_widgets/text_widgets.dart';
import '../../../../components/snackbars/custom_snackbar.dart';

class AddPalConfirmationSubmitScreen extends StatefulWidget {
  static const String routeName = '/addPalConfirmationSubmitScreen';
  final AddPalViewModel viewModelBase;

  const AddPalConfirmationSubmitScreen(
      {super.key, required this.viewModelBase});

  @override
  State<AddPalConfirmationSubmitScreen> createState() =>
      _AddPalConfirmationSubmitScreenState();
}

class _AddPalConfirmationSubmitScreenState
    extends State<AddPalConfirmationSubmitScreen> {
  bool _isFirstLoad = true;

  @override
  void initState() {
    super.initState();
    // Clear any existing errors when the screen is first loaded
    widget.viewModelBase.clearError();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AddPalState>(
      stream: widget.viewModelBase.stateStream,
      initialData: widget.viewModelBase.getCurrentStateWithControllers(),
      builder: (context, snapshot) {
        final state = snapshot.data!;
        print('Confirmation Screen State: $state');

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
                    const SizedBox(height: 40),
                    const BackButtonWithPointWidget(
                        currentPoints: 120, totalPoints: 120),
                    const SizedBox(height: 60),
                    LargePurpleText("Confirm the details"),
                    const SizedBox(height: 16),
                    UserInfoCard(
                      name: state.name,
                      lastName: state.lastName,
                      dateOfBirth:
                          widget.viewModelBase.dateOfBirthController.text,
                      gender: state.gender,
                    ),
                    const SizedBox(height: 16),
                    const Divider(
                        color: Colors.grey, thickness: 0.7, height: 24),
                    const SizedBox(height: 16),
                    QuestionnaireSection(
                      primaryDiagnosis:
                          widget.viewModelBase.primaryDiagnosisController.text,
                      canWalk: state.can_walk,
                      needsWalkingAid: state.needs_walking_aid,
                      isBedridden: state.is_bedridden,
                      hasDementia: state.has_dementia,
                      isAgitated: state.is_agitated,
                      isDepressed: state.is_depressed,
                      dominantEmotion: state.dominant_emotion,
                      sleepPattern: state.sleep_pattern,
                      sleepQuality: state.sleep_quality,
                      painStatus: state.pain_status,
                    ),
                  ],
                ),
              ),
            ),
          ),
          floatingActionButton: LabelButton(
            label: 'Confirm & continue',
            onTap: () async {
              final currentState =
                  widget.viewModelBase.getCurrentStateWithControllers();
              print('Submitting State: $currentState');

              final missingFields = _getMissingFields(currentState);
              if (missingFields.isNotEmpty) {
                print('DEBUG: Showing missing fields snackbar');
                ScaffoldMessenger.of(context).showSnackBar(
                  commonSnackBarWidget(
                    content: 'Please complete: ${missingFields.join(', ')}',
                    type: SnackBarType.error,
                  ),
                );
                return;
              }

              print('DEBUG: Calling submitPalData');

              // Call submitPalData and handle the result directly
              await widget.viewModelBase.submitPalData();

              // Get the current state after submission
              final updatedState =
                  widget.viewModelBase.getCurrentStateWithControllers();
              print(
                  'DEBUG: submitPalData completed, status: ${updatedState.status}');

              if (updatedState.status == AddPalStateStatus.success) {
                // Show success snackbar
                ScaffoldMessenger.of(context).showSnackBar(
                  commonSnackBarWidget(
                    content: 'Profile created successfully!',
                    type: SnackBarType.message,
                  ),
                );

                // Wait a bit for the success snackbar to show before navigating
                await Future.delayed(const Duration(seconds: 2));
                if (mounted) {
                  Navigator.pushNamed(
                    context,
                    HomeScreen.routeName,
                  );
                }
              } else if (updatedState.status == AddPalStateStatus.error &&
                  updatedState.errorMessage != null) {
                // Show error snackbar
                ScaffoldMessenger.of(context).showSnackBar(
                  commonSnackBarWidget(
                    content: updatedState.errorMessage!,
                    type: SnackBarType.error,
                  ),
                );
              }
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

  List<String> _getMissingFields(AddPalState state) {
    final missing = <String>[];
    if (state.name?.isNotEmpty != true) missing.add('first name');
    if (state.lastName?.isNotEmpty != true) missing.add('last name');
    if (state.gender?.isNotEmpty != true) missing.add('gender');
    if (state.can_walk == null) missing.add('ability to walk');
    if (state.needs_walking_aid == null) missing.add('needs walking aid');
    if (state.is_bedridden == null) missing.add('bedridden status');
    if (state.has_dementia == null) missing.add('dementia status');
    if (state.is_agitated == null) missing.add('agitation status');
    if (state.is_depressed == null) missing.add('depression status');
    if (state.dominant_emotion == null) missing.add('dominant emotion');
    if (state.sleep_pattern == null) missing.add('sleep pattern');
    if (state.sleep_quality == null) missing.add('sleep quality');
    return missing;
  }
}
