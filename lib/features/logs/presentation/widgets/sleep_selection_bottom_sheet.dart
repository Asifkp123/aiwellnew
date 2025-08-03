import 'package:flutter/material.dart';
import '../../../../components/text_widgets/text_widgets.dart';
import '../../../../components/theme/light_theme.dart';
import '../view_models/logs_view_model.dart';

class SleepSelectionBottomSheet extends StatefulWidget {
  final LogsViewModel logsViewModel;
  final Function(Map<String, String>) onSleepSelected;

  const SleepSelectionBottomSheet({
    Key? key,
    required this.logsViewModel,
    required this.onSleepSelected,
  }) : super(key: key);

  @override
  State<SleepSelectionBottomSheet> createState() =>
      _SleepSelectionBottomSheetState();
}

class _SleepSelectionBottomSheetState extends State<SleepSelectionBottomSheet> {
  String? selectedQuality;
  String? selectedStartTime;
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
                PurpleBold22Text('Did you sleep well?'),
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
                  // Sleep Quality Dropdown
                  _buildDropdownField(
                    label: 'How was your sleep quality?',
                    value: selectedQuality,
                    items: LogsViewModel.sleepQualities
                        .map((quality) => quality.name)
                        .toList(),
                    onChanged: (value) =>
                        setState(() => selectedQuality = value),
                  ),

                  const SizedBox(height: 20),

                  // Sleep Start Time Dropdown
                  _buildDropdownField(
                    label: 'At what time did you go to sleep?',
                    value: selectedStartTime,
                    items: LogsViewModel.sleepTimes,
                    onChanged: (value) =>
                        setState(() => selectedStartTime = value),
                  ),

                  const SizedBox(height: 20),

                  // Sleep Duration Dropdown
                  _buildDropdownField(
                    label: 'How many hours did you sleep?',
                    value: selectedDuration,
                    items: LogsViewModel.sleepDurations,
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
                            final sleepData = _getSleepData();
                            final canSubmit = widget.logsViewModel
                                    .isSleepFormValid(sleepData) &&
                                !isLoading;

                            return SizedBox(
                              height: 50,
                              child: ElevatedButton(
                                onPressed:
                                    canSubmit ? () => _submitSleep() : null,
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
      case 'How was your sleep quality?':
        return 'Good';
      case 'At what time did you go to sleep?':
        return '10:00 PM';
      case 'How many hours did you sleep?':
        return '8 Hrs';
      default:
        return 'Select option';
    }
  }

  // ✅ Helper method to get current form data
  Map<String, String> _getSleepData() {
    return {
      'quality': selectedQuality ?? '',
      'startTime': selectedStartTime ?? '',
      'duration': selectedDuration ?? '',
    };
  }

  // ✅ Much simpler! ViewModel handles validation, SnackBar, and navigation
  void _submitSleep() async {
    final sleepData = _getSleepData();
    print(sleepData);
    print("sleepData");

    // ✅ ViewModel handles everything: validation, API call, SnackBar, navigation
    await widget.logsViewModel.logSleep(sleepData, context);

    // ✅ Notify parent about selection (for any additional logic if needed)
    widget.onSleepSelected(sleepData);
  }
}
