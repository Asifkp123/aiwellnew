import 'package:flutter/material.dart';
import 'package:aiwel/components/text_widgets/text_widgets.dart';
import 'package:aiwel/components/theme/light_theme.dart';

class PointsHeaderWidget extends StatelessWidget {
  final String points;
  final IconData icon;
  final double iconSize;
  final Color? backgroundColor;
  final Color? borderColor;
  final double borderRadius;
  final double borderWidth;
  final EdgeInsetsGeometry? padding;

  const PointsHeaderWidget({
    super.key,
    required this.points,
    this.icon = Icons.favorite,
    this.iconSize = 16,
    this.backgroundColor,
    this.borderColor,
    this.borderRadius = 20,
    this.borderWidth = 2,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final customColors = Theme.of(context).extension<CustomColors>()!;

    return Container(
      padding:
          padding ?? const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(
          width: borderWidth,
          color: borderColor ?? customColors.containerBorderColor,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: Theme.of(context).primaryColor,
            size: iconSize,
          ),
          const SizedBox(width: 4),
          PurpleBoldText(
            points,
            color: Theme.of(context).primaryColor,
          ),
        ],
      ),
    );
  }
}
