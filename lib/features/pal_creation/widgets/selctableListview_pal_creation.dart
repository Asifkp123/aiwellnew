import 'package:flutter/material.dart';

import '../../../components/constants.dart';
import '../../../components/text_widgets/text_widgets.dart';
import '../../../components/theme/light_theme.dart';

class SelctablelistviewPalCreation extends StatelessWidget {
  final List<String> items;
  final bool? selectedValue; // Changed from String? to bool?
  final Function(String) onItemSelected;

  const SelctablelistviewPalCreation({
    super.key,
    required this.items,
    required this.selectedValue,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height - 200,
      child: ListView.builder(
        padding: EdgeInsets.zero,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          // Map bool? to the corresponding item ("Yes" or "No")
          final isSelected = selectedValue != null &&
              ((selectedValue! && item == 'Yes') ||
                  (!selectedValue! && item == 'No'));
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 6.0),
            child: GestureDetector(
              onTap: () => onItemSelected(item),
              child: Container(
                width: double.infinity,
                height: 70,
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 2,
                    color: isSelected
                        ? splashGradient().colors.first.withOpacity(0.5)
                        : lightTheme.focusColor,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child: Purple18Text(
                        item,
                        color: !isSelected
                            ? lightTheme.colorScheme.secondaryFixed
                            : lightTheme.primaryColor,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: Icon(
                        isSelected ? Icons.check_circle : Icons.circle_outlined,
                        color: isSelected ? Colors.purple : Colors.grey,
                        size: 24,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
