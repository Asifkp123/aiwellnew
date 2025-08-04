import 'package:flutter/material.dart';
import '../../../../components/constants.dart';
import '../../../../components/custom_image_view.dart';
import '../../../../components/buttons/custom_button.dart';
import '../../../../core/constants/image_constant.dart';
import '../../../../core/utils/text_style_helper.dart';
import '../../../../core/theme/app_theme.dart';
import '../view_models/logs_view_model.dart';
import 'mood_option_widgets.dart';

class MoodTrackerScreen extends StatefulWidget {
  final LogsViewModel logsViewModel;
  final Function(String)? onMoodSelected;

  const MoodTrackerScreen({
    Key? key,
    required this.logsViewModel,
    this.onMoodSelected,
  }) : super(key: key);

  @override
  State<MoodTrackerScreen> createState() => _MoodTrackerScreenState();
}

class _MoodTrackerScreenState extends State<MoodTrackerScreen> {
  int selectedMoodIndex = 0; // Default to Happy
  bool isLoading = false;

  final List<Map<String, dynamic>> moodOptions = [
    {
      'imagePath': ImageConstant.imgGroup,
      'label': 'Happy',
    },
    {
      'imagePath': ImageConstant.imgGroupGray100,
      'label': 'Sad',
    },
    {
      'imagePath': ImageConstant.imgGroupGray10036x36,
      'label': 'Angry',
    },
    {
      'imagePath': ImageConstant.imgGroup36x36,
      'label': 'Anxious',
    },
    {
      'imagePath': ImageConstant.imgGroup1,
      'label': 'Calm',
    },
    {
      'imagePath': ImageConstant.imgGroupGray100,
      'label': 'Confused',
    },
    {
      'imagePath': ImageConstant.imgGroup123215,
      'label': 'Tired',
    },
    {
      'imagePath': ImageConstant.imgGroup2,
      'label': 'Excited',
    },
    {
      'imagePath': ImageConstant.imgGroupGray10035x36,
      'label': 'Scared',
    },
    {
      'imagePath': ImageConstant.imgFrame1686561009,
      'label': 'Neutral',
    },
  ];

  void _submitMood() async {
    if (isLoading) return;

    setState(() {
      isLoading = true;
    });

    final selectedMood = moodOptions[selectedMoodIndex]['label'] as String;

    // Call LogsViewModel.logMood - it handles SnackBar and returns success/failure
    final isSuccess = await widget.logsViewModel.logMood(selectedMood, context);

    setState(() {
      isLoading = false;
    });

    if (isSuccess) {
      // Close dialog and call callback on success
      widget.onMoodSelected?.call(selectedMood);
      Navigator.of(context).pop();
    }
    // ViewModel already shows error SnackBar on failure
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme.transparentCustom,
      body: Center(
        child: Container(
          width: double.infinity,
          constraints: BoxConstraints(maxWidth: 350),
          margin: const EdgeInsets.all(16),
          child: Container(
            height: 436,
            decoration: BoxDecoration(
              color: appTheme.whiteCustom,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: appTheme.blackCustom.withAlpha(26),
                  blurRadius: 10,
                  spreadRadius: 0,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Stack(
              children: [
                Positioned(
                  top: 24,
                  right: 24,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      width: 24,
                      height: 24,
                      child: CustomImageView(
                        imagePath: ImageConstant.imgIconsClose24px,
                        height: 24,
                        width: 24,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 49,
                  left: 26,
                  child: Text(
                    'How are you feeling today?',
                    style: TextStyleHelper.instance.title22Medium
                        .copyWith(height: 1.5),
                  ),
                ),
                Positioned(
                  top: 114,
                  left: 16,
                  right: 16,
                  child: Column(
                    children: [
                      _buildMoodRow(moodOptions.sublist(0, 4), 0),
                      const SizedBox(height: 16),
                      _buildMoodRow(moodOptions.sublist(4, 8), 4),
                      const SizedBox(height: 16),
                      _buildMoodRow(moodOptions.sublist(8, 10), 8),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 24,
                  left: 16,
                  right: 16,
                  child: Row(
                    children: [

                               Expanded(
                          child: SizedBox(
                            height: 40,
                            // width: 120,
                            child: OutlinedButton(
                              onPressed: () => Navigator.pop(context),
                              style: OutlinedButton.styleFrom(
                                backgroundColor: Colors.white,
                                side: BorderSide(color: Colors.grey[300]!),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(40),
                                ),
                              ),
                              child: const Text(
                                'Cancel',
                                style: TextStyle(
                                  color: Color(0xFF6B46C1),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ),


                      const SizedBox(width: 16),
                      Expanded(
                        child: Container(
                          height: 42,
                          decoration: BoxDecoration(
                            gradient: splashGradient(context),

                            borderRadius: BorderRadius.circular(21),
                          ),
                          child: ElevatedButton(
                            onPressed: isLoading ? null : _submitMood,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              disabledBackgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(40),
                              ),
                            ),
                            child: isLoading
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.white),
                                    ),
                                  )
                                : Text(
                                    'Save',
                                    style:
                                        TextStyleHelper.instance.title16Medium,
                                  ),
                        ),
                      ),)
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMoodRow(List<Map<String, dynamic>> moods, int startIndex) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: moods.asMap().entries.map((entry) {
        final index = entry.key;
        final mood = entry.value;
        final globalIndex = startIndex + index;

        return MoodOptionWidget(
          imagePath: mood['imagePath'],
          label: mood['label'],
          isSelected: selectedMoodIndex == globalIndex,
          onTap: () {
            setState(() {
              selectedMoodIndex = globalIndex;
            });
          },
        );
      }).toList(),
    );
  }
}
