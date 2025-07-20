import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../components/constants.dart';
import '../../../components/theme/light_theme.dart';

class BackButtonWithPointWidget extends StatelessWidget {
  final int currentPoints;
  final int totalPoints;

  const BackButtonWithPointWidget({
    super.key,
    required this.currentPoints,
    this.totalPoints = 120, // Default total points
  });

  @override
  Widget build(BuildContext context) {
    final customColors = Theme.of(context).extension<CustomColors>()!;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Back button
        InkWell(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Icon(
            Icons.arrow_back,
            color: Theme.of(context).colorScheme.surface,
          ),
        ),

        // Point system
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            // color: const Color(0xFFF1E6FD),
            color: Colors.white.withOpacity(0.8),

            borderRadius: BorderRadius.circular(32),
            border: Border.all(
              width: 3,
              color: customColors.containerBorderColor,
            ),
          ),
          child: Row(
            children: [
              SvgPicture.asset('$svgPath/purple_love.svg',
                width: 16,
                height: 16),
              const SizedBox(width: 4),
              Text(
                '$currentPoints/$totalPoints',
                style: const TextStyle(
                  color: Color(0xFF8E2EFF),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
