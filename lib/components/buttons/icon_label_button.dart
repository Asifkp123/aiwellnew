import '../constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class IconLabelButton extends StatelessWidget {
  final Function? onTap;
  final String label;
  final Color? bgColor;
  final String icon;
  final bool hasBorder;
  final Color? textColor;
  final FontWeight? fontWeight;
  final bool hasIconColorFilter;
  final double iconSize;
  final bool isLoading;
  final Widget? iconWidget;
  const IconLabelButton({
    super.key,
    this.onTap,
    required this.label,
    this.bgColor,
    required this.icon,
    this.textColor,
    this.hasBorder = false,
    this.fontWeight,
    this.hasIconColorFilter = true,
    this.iconSize = 14,
    this.isLoading = false,
    this.iconWidget,
  });

  @override
  Widget build(BuildContext context) => MaterialButton(
        onPressed: onTap == null
            ? null
            : !isLoading
                ? () {
                    FocusManager.instance.primaryFocus?.unfocus();
                    onTap!();
                  }
                : null,
        height: 50,
        elevation: 0.0,
        disabledColor: Theme.of(context).primaryColor.withValues(alpha: 0.5),
        color: bgColor ?? Theme.of(context).primaryColor,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
            side: hasBorder
                ? const BorderSide(color: Color(0xFFEDEEF3))
                : BorderSide.none),
        child: isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  iconWidget ??
                      SvgPicture.asset(
                        '$svgPath/$icon',
                        width: iconSize,
                        colorFilter: hasIconColorFilter
                            ? ColorFilter.mode(
                                Theme.of(context).colorScheme.onPrimary,
                                BlendMode.srcIn)
                            : null,
                      ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text(
                      label,
                      style: TextStyle(
                        color: textColor ??
                            Theme.of(context).colorScheme.onPrimary,
                        fontWeight: fontWeight ?? FontWeight.w500,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ],
              ),
      );
}
