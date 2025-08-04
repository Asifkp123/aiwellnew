import 'package:flutter/material.dart';
import '../../../../components/constants.dart';
import '../../../../components/text_widgets/text_widgets.dart';
import '../../../../components/theme/light_theme.dart';
import '../view_models/logs_view_model.dart';

class SleepSelectionAlertDialog extends StatefulWidget {
  final LogsViewModel logsViewModel;
  final Function(Map<String, String>) onSleepSelected;

  const SleepSelectionAlertDialog({
    Key? key,
    required this.logsViewModel,
    required this.onSleepSelected,
  }) : super(key: key);

  @override
  State<SleepSelectionAlertDialog> createState() =>
      _SleepSelectionAlertDialogState();
}

class _SleepSelectionAlertDialogState extends State<SleepSelectionAlertDialog> {
  String? selectedQuality;
  String? selectedStartTime;
  String? selectedDuration;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: Column(

        children: [
          Row(
            children: [
              Spacer(),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close, color: Colors.black),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
          // SizedBox(height: 10),
          PurpleBold22Text('Did you sleep well?'),
        ],
      ),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
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
          ],
        ),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Cancel Button
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

            const SizedBox(width: 12),

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
              
                  return Container(
                    decoration: BoxDecoration(
                      gradient: splashGradient(context),

                      borderRadius: BorderRadius.circular(21),
                    ),
                    height: 40,
                    child: ElevatedButton(
                      onPressed:
                          canSubmit ? () => _submitSleep() : null,
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
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : Text(
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
      ],
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String? value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(16),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          hint: Text(
            label,
            style: TextStyle(color: Colors.grey[600]),
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
    );
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
