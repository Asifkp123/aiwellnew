import 'package:flutter/material.dart';
import '../../../../components/text_widgets/text_widgets.dart';
import '../../../../components/theme/light_theme.dart';
import '../view_models/logs_view_model.dart';

class WorkoutSelectionBottomSheet extends StatefulWidget {
  final LogsViewModel logsViewModel;
  final Function(Map<String, String>) onWorkoutSelected;

  const WorkoutSelectionBottomSheet({
    Key? key,
    required this.logsViewModel,
    required this.onWorkoutSelected,
  }) : super(key: key);

  @override
  State<WorkoutSelectionBottomSheet> createState() =>
      _WorkoutSelectionBottomSheetState();
}

class _WorkoutSelectionBottomSheetState
    extends State<WorkoutSelectionBottomSheet> {
  String? selectedRating;
  String? selectedType;
  String? selectedTime;
  String? selectedDuration;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      height: screenHeight * 0.7,
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

          // Title and close button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                PurpleBold22Text('Did you workout today?'),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(Icons.close, color: Colors.grey[600]),
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // Form fields
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  // Rating Dropdown
                  _buildDropdownField(
                    label: 'How will you rate your workout?',
                    value: selectedRating,
                    items: LogsViewModel.workoutRatings
                        .map((rating) => rating.name)
                        .toList(),
                    onChanged: (value) =>
                        setState(() => selectedRating = value),
                  ),

                  const SizedBox(height: 20),

                  // Activity Type Dropdown
                  _buildDropdownField(
                    label: 'What did you do?',
                    value: selectedType,
                    items: LogsViewModel.workoutTypes
                        .map((type) => type.name)
                        .toList(),
                    onChanged: (value) => setState(() => selectedType = value),
                  ),

                  const SizedBox(height: 20),

                  // Time Dropdown
                  _buildDropdownField(
                    label: 'At what time?',
                    value: selectedTime,
                    items: LogsViewModel.workoutTimes,
                    onChanged: (value) => setState(() => selectedTime = value),
                  ),

                  const SizedBox(height: 20),

                  // Duration Dropdown
                  _buildDropdownField(
                    label: 'How many Hours?',
                    value: selectedDuration,
                    items: LogsViewModel.workoutDurations,
                    onChanged: (value) =>
                        setState(() => selectedDuration = value),
                  ),

                  const Spacer(),

                  // Action Buttons
                  Row(
                    children: [
                      // Cancel Button
                      Expanded(
                        child: SizedBox(
                          height: 50,
                          child: OutlinedButton(
                            onPressed: () => Navigator.pop(context),
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: Colors.grey[400]!),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              'Cancel',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 16),

                      // Save Button
                      Expanded(
                        child: StreamBuilder<LogsState>(
                          stream: widget.logsViewModel.stateStream,
                          builder: (context, snapshot) {
                            final state = snapshot.data;
                            final isLoading = state?.isLoading ?? false;
                            final workoutData = _getWorkoutData();
                            final canSubmit = widget.logsViewModel
                                    .isWorkoutFormValid(workoutData) &&
                                !isLoading;

                            return SizedBox(
                              height: 50,
                              child: ElevatedButton(
                                onPressed:
                                    canSubmit ? () => _submitWorkout() : null,
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
                                        'Save',
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

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String? value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              hint: Text(
                _getHintText(label),
                style: TextStyle(color: Colors.grey[500]),
              ),
              isExpanded: true,
              items: items.map((String item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(item),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  String _getHintText(String label) {
    switch (label) {
      case 'How will you rate your workout?':
        return 'Excellent';
      case 'What did you do?':
        return 'Running';
      case 'At what time?':
        return '10:00 AM';
      case 'How many Hours?':
        return '1 Hr';
      default:
        return 'Select option';
    }
  }

  // ✅ Helper method to get current form data
  Map<String, String> _getWorkoutData() {
    return {
      'rating': selectedRating ?? '',
      'type': selectedType ?? '',
      'time': selectedTime ?? '',
      'duration': selectedDuration ?? '',
    };
  }

  // ✅ Much simpler! ViewModel handles validation, SnackBar, and navigation
  void _submitWorkout() async {
    final workoutData = _getWorkoutData();
    print(workoutData);
    print("workoutData");

    // ✅ ViewModel handles everything: validation, API call, SnackBar, navigation
    await widget.logsViewModel.logWorkout(workoutData, context);

    // ✅ Notify parent about selection (for any additional logic if needed)
    // widget.onWorkoutSelected(workoutData);
  }
}
