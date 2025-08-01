import 'package:flutter/material.dart';
import '../../../../components/text_widgets/text_widgets.dart';
import '../../../../components/theme/light_theme.dart';
import '../view_models/logs_view_model.dart';

class MoodSelectionBottomSheet extends StatefulWidget {
  final LogsViewModel logsViewModel;
  final Function(String) onMoodSelected;

  const MoodSelectionBottomSheet({
    Key? key,
    required this.logsViewModel,
    required this.onMoodSelected,
  }) : super(key: key);

  @override
  State<MoodSelectionBottomSheet> createState() =>
      _MoodSelectionBottomSheetState();
}

class _MoodSelectionBottomSheetState extends State<MoodSelectionBottomSheet> {
  String? selectedMood;

  // ✅ Mood options now come from ViewModel - Clean Architecture!

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      height: screenHeight * 0.6,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          const SizedBox(height: 24),

          // Title
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                PurpleBold22Text('How are you feeling?'),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(Icons.close, color: Colors.grey[600]),
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: NormalGreyText(
              'Select your current mood to track how you\'re feeling today.',
              maxLines: 2,
            ),
          ),

          const SizedBox(height: 32),

          // Mood Options Grid
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 2.5,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: LogsViewModel.moodOptions.length,
                itemBuilder: (context, index) {
                  final mood = LogsViewModel.moodOptions[index];
                  final isSelected = selectedMood == mood.name;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedMood = mood.name;
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: isSelected
                            ? mood.color.withOpacity(0.1)
                            : Colors.grey[50],
                        border: Border.all(
                          color: isSelected ? mood.color : Colors.grey[300]!,
                          width: isSelected ? 2 : 1,
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            mood.emoji,
                            style: const TextStyle(fontSize: 24),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            mood.name,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              color: isSelected ? mood.color : Colors.grey[700],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          // Submit Button
          Padding(
            padding: const EdgeInsets.all(24),
            child: StreamBuilder<LogsState>(
              stream: widget.logsViewModel.stateStream,
              builder: (context, snapshot) {
                final state = snapshot.data;
                final isLoading = state?.isLoading ?? false;

                return SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: selectedMood != null && !isLoading
                        ? () => _submitMood()
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: lightTheme.primaryColor,
                      disabledBackgroundColor: Colors.grey[300],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text(
                            'Log Mood',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _submitMood() async {
    if (selectedMood == null) return;

    // ✅ Simple! Call ViewModel - it handles SnackBar and returns success/failure
    final isSuccess =
        await widget.logsViewModel.logMood(selectedMood!, context);

    if (isSuccess) {
      // ✅ Only close bottom sheet on success - matches your existing pattern!
      widget.onMoodSelected(selectedMood!);
      if (mounted) {
        Navigator.pop(context);
      }
    }
    // ✅ On error, bottom sheet stays open so user can retry
  }
}
