import 'package:aiwel/features/pal_creation/presentation/view_models/add_pal_view_model.dart';
import 'package:aiwel/features/pal_creation/widgets/CarePointsCard.dart';
import 'package:aiwel/features/pal_creation/widgets/QuestionnaireSection.dart';
import 'package:aiwel/features/pal_creation/widgets/back_button_with_point.dart';
import 'package:aiwel/features/pal_creation/widgets/name_date_gender_widget.dart';
import 'package:flutter/material.dart';

import '../../../../../../components/buttons/label_button.dart';
import '../../../../../../components/constants.dart';
import '../../../../../../components/text_widgets/text_widgets.dart';
import '../../../../components/theme/light_theme.dart';
import '../../../auth/presentation/widgets/selectable_listView.dart';

class AddPalCompletionCongratsScreen extends StatelessWidget {
  static const String routeName = '/addPalCompletionCongratsScreen';
  final AddPalViewModel viewModelBase;
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  AddPalCompletionCongratsScreen({super.key, required this.viewModelBase}) {
    // viewModelBase.startAnimationForEmotian(_listKey);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AddPalState>(
      stream: viewModelBase.stateStream,
      initialData: AddPalState(status: AddPalStateStatus.idle),
      builder: (context, snapshot) {
        final state = snapshot.data!;
        return Scaffold(
          body: SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height,
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
                  crossAxisAlignment: CrossAxisAlignment.center,
                  // mainAxisAlignment: MainAxisAlignment.center,

                  children: [
                    SizedBox(height: 40),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Icon(Icons.close,
                          size: 30, color: lightTheme.colorScheme.surface),
                    ),
                    Spacer(),
                    const SizedBox(height: 100),
                    LargePurpleText("Congratulations"),
                    const SizedBox(height: 16),
                    NormalGreyText("Thank you for caring for your Pal"),
                    const SizedBox(height: 200),
                    CarePointsCard(),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ),
          floatingActionButton: LabelButton(
            label: 'Confirm & continue',
            onTap: () {},
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
