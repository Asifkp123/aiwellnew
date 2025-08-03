import 'package:flutter/material.dart';
import 'package:aiwel/components/text_widgets/text_widgets.dart';
import 'package:aiwel/components/constants.dart';
import 'package:flutter_svg/svg.dart';

import 'glass_effect_widget.dart';
import '../../../components/theme/light_theme.dart';

class TrackingCardWidget extends StatelessWidget {
  final dynamic icon; // Changed to dynamic to accept both IconData and String
  final String title;
  final String subtitle;
  final String points;
  final VoidCallback? onAddPressed;
  final bool isFullWidth;
  final double screenWidth;
  final double screenHeight;
  final double? iconSize; // Added custom icon size parameter

  const TrackingCardWidget({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.points,
    required this.screenWidth,
    required this.screenHeight,
    this.onAddPressed,
    this.isFullWidth = false,
    this.iconSize, // Optional custom icon size
  });

  @override
  Widget build(BuildContext context) {
    return GlassEffectWidget(
      width: double.infinity,
      height: isFullWidth ? screenHeight * 0.14 : screenHeight * 0.21,
      child: isFullWidth
          ? _buildFullWidthContent(context)
          : _buildRegularContent(context),
    );
  }

  Widget _buildRegularContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        // mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              // Only show icon if not full width and icon is provided
              if (!isFullWidth && icon != null) ...[
                _buildIconWidget(context, size: iconSize ?? 20),
                const SizedBox(width: 6),
              ],
              Expanded(child: PurpleBold22Text(title)),
            ],
          ),
          const SizedBox(height: 6),
          NormalGreyText(
            subtitle,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 30),

          // const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildPointsRow(context),
              _buildSmallAddButton(context),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFullWidthContent(BuildContext context) {
    return Row(
      children: [
        _buildIconWidget(context, size: iconSize ?? 22),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              MediumPurpleText(title),
              const SizedBox(height: 2),
              Flexible(
                child: NormalGreyText(
                  subtitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        _buildPointsRow(context),
        const SizedBox(width: 12),
        _buildSmallAddButton(context),
      ],
    );
  }

  // New method to handle both IconData and SVG strings
  Widget _buildIconWidget(BuildContext context, {required double size}) {
    if (icon == null) {
      return SizedBox(width: size, height: size);
    }

    if (icon is String) {
      // Handle SVG string with proper sizing
      return SvgPicture.asset(
        icon,
        height: size,
        width: size,
        fit: BoxFit.contain, // This helps with sizing
        colorFilter: ColorFilter.mode(
          Theme.of(context).primaryColor,
          BlendMode.srcIn,
        ),
        placeholderBuilder: (context) => Container(
          height: size,
          width: size,
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withOpacity(0.2),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Icon(
            Icons.image,
            size: size * 0.8,
            color: Theme.of(context).primaryColor,
          ),
        ),
      );
    } else if (icon is IconData) {
      // Handle IconData
      return Icon(
        icon,
        color: Theme.of(context).primaryColor,
        size: size,
      );
    } else {
      // Fallback for unsupported types
      return Icon(
        Icons.help_outline,
        color: Theme.of(context).primaryColor,
        size: size,
      );
    }
  }

  Widget _buildPointsRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(
          "$svgPath/Heart Icon Home.svg",
          height: 15,
          width: 13,
        ),
        PurpleBoldText(
          fontSize: 13,
          points,
        ),
      ],
    );
  }

  Widget _buildSmallAddButton(BuildContext context) {
    return Container(
      height: 32,
      decoration: BoxDecoration(
        color: lightTheme.primaryColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: MaterialButton(
        onPressed: onAddPressed ?? () {},
        minWidth: 50,
        elevation: 0,
        color: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: RegularWhiteText(
          "Add",
          fontSize: 12,
        ),
      ),
    );
  }
}
