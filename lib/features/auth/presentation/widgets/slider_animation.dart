import 'package:aiwel/components/text_widgets/text_widgets.dart';
import 'package:aiwel/components/theme/light_theme.dart';
import 'package:flutter/material.dart';

import '../../../../components/constants.dart';
import '../view_models/sign_in_viewModel.dart';

Widget buildItem(String mood, Animation<double> animation, SignInViewModelBase viewModelBase, String? selectedMood) {
  final isSelected = selectedMood == mood;
  return SlideTransition(
    position: Tween<Offset>(
      begin: const Offset(1, 0), // Slide from right
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: animation,
      curve: Curves.easeOut,
    )),
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: GestureDetector(
        onTap: () {
          (viewModelBase as SignInViewModel).selectMood(mood);
        },
        child: Container(
          width: double.infinity,
          height: 60,
          decoration: BoxDecoration(
            // gradient: splashGradient(),
            border: Border.all(
              width: 2,
              color: isSelected ? splashGradient().colors.first.withOpacity(0.5):lightTheme.hintColor,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16),
                child:
                Purple18Text(mood,color:!isSelected ?lightTheme.colorScheme.secondaryFixed:lightTheme.primaryColor),
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
    ),
  );
}

