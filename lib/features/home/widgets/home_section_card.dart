import 'package:flutter/material.dart';
import 'package:aiwel/components/constants.dart';

class HomeSectionCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;
  final Color? borderColor;
  final double borderRadius;
  final double borderWidth;

  const HomeSectionCard({
    super.key,
    required this.child,
    this.padding,
    this.backgroundColor,
    this.borderColor,
    this.borderRadius = 0,
    this.borderWidth = 2,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      // padding: padding ?? EdgeInsets.all(cardPadding + 5),
      decoration: BoxDecoration(
        // color: backgroundColor ?? Colors.white.withOpacity(0.8),
        color: Color(0xFFF9F3FF
        ),
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(
          width: borderWidth,
          color: borderColor ?? Colors.white,
        ),
      ),
      child: child,
    );
  }
}
class MeditationSectionCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;
  final Color? borderColor;
  final double borderRadius;
  final double borderWidth;

  const MeditationSectionCard({
    super.key,
    required this.child,
    this.padding,
    this.backgroundColor,
    this.borderColor,
    this.borderRadius = 20,
    this.borderWidth = 2,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      // padding: padding ?? EdgeInsets.all(cardPadding + 5),
      decoration: BoxDecoration(
        color:  Colors.white,
        // color: Color(0xFFF9F3FF

        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(
          width: borderWidth,
          color: borderColor ?? Colors.white,
        ),
      ),
      child: child,
    );
  }
}
