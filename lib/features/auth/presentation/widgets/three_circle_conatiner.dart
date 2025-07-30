import 'package:flutter/material.dart';

import '../../../../components/constants.dart';

class CircleContainer extends StatelessWidget {
  final bool filled;
  final VoidCallback onTap;


  const CircleContainer({required this.filled, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 10,
        height: 10,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: filled ? splashGradient() : null,
          border: filled ? null : Border.all(
            width: 1.2,
            color: splashGradient().colors.first.withOpacity(0.5) // Use the first color of the gradient with reduced opacity,
          ),
        ),
      ),
    );
  }
}