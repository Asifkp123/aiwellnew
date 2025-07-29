import 'dart:ui';
import 'package:flutter/material.dart';

class GlassEffectWidget extends StatelessWidget {
  final Widget child;
  final double width;
  final double height;
  final double borderRadius;
  final double blurSigma;
  final Color backgroundColor;
  final Color borderColor;
  final double borderWidth;

  const GlassEffectWidget({
    super.key,
    required this.child,
    required this.width,
    required this.height,
    this.borderRadius = 20,
    this.blurSigma = 10,
    this.backgroundColor = const Color(0x4DFFFFFF), // 30% white opacity
    this.borderColor = const Color(0xCCFFFFFF), // 80% white opacity
    this.borderWidth = 2,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(
              width: borderWidth,
              color: borderColor,
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}
