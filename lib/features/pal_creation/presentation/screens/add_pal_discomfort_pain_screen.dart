import 'package:aiwel/features/pal_creation/presentation/screens/add_pal_confirmation_submit_screen.dart';
import 'package:aiwel/features/pal_creation/presentation/view_models/add_pal_view_model.dart';
import 'package:aiwel/features/pal_creation/widgets/back_button_with_point.dart';
import 'package:flutter/material.dart';
import '../../../../../../components/buttons/label_button.dart';
import '../../../../../../components/constants.dart';
import '../../../../../../components/text_widgets/text_widgets.dart';
import '../../../../components/snackbars/custom_snackbar.dart';
import '../../../auth/presentation/widgets/selectable_listView.dart';

class AddPalDiscomfortOrPainScreen extends StatefulWidget {
  static const String routeName = '/addPalDiscomfortOrPainScreen';
  final AddPalViewModel viewModelBase;

  const AddPalDiscomfortOrPainScreen({super.key, required this.viewModelBase});

  @override
  _AddPalDiscomfortOrPainScreenState createState() =>
      _AddPalDiscomfortOrPainScreenState();
}

class _AddPalDiscomfortOrPainScreenState
    extends State<AddPalDiscomfortOrPainScreen> {
  @override
  void initState() {
    super.initState();
    widget.viewModelBase.updateStateWithControllers();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AddPalState>(
      stream: widget.viewModelBase.stateStream,
      initialData: widget.viewModelBase.getCurrentStateWithControllers(),
      builder: (context, snapshot) {
        final state = snapshot.data!;
        print('Discomfort Screen State: $state');

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
                    LargePurpleText(state.gender?.toLowerCase() == 'male'
                        ? "Is he feeling any discomfort or pain today?"
                        : state.gender?.toLowerCase() == 'female'
                            ? "Is she feeling any discomfort or pain today?"
                            : "Are they feeling any discomfort or pain today?"),
                    const SizedBox(height: 16),
                    NormalGreyText("Aiwel would be happy if you are pain free"),
                    const SizedBox(height: 16),
                    SelectableListView(
                      items: widget.viewModelBase.discomfortList,
                      selectedValue: state.pain_status,
                      onItemSelected: widget.viewModelBase.setPainStatus,
                    ),
                    const SizedBox(height: 50),
                  ],
                ),
              ),
            ),
          ),
          floatingActionButton: LabelButton(
            label: 'Continue',
            onTap: () {
              if (state.pain_status == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  commonSnackBarWidget(
                    content: "Please select an option before continuing.",
                    type: SnackBarType.error,
                  ),
                );
                return;
              }
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddPalConfirmationSubmitScreen(
                      viewModelBase: widget.viewModelBase),
                ),
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
