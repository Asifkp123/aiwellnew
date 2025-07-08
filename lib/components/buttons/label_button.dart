import 'package:aiwel/components/constants.dart';
import 'package:flutter/material.dart';

class LabelButton extends StatelessWidget {
  final VoidCallback? onTap;
  final String label;
  final Color? bgColor;
  final Color? fontColor;
  final Color? borderColor;
  final bool loading;
  final Color? disabledColor;
  final double? fontSize;
  final double? borderRadius;
  final LinearGradient? gradient; // Add gradient parameter
  final EdgeInsetsGeometry? padding;
  const LabelButton({
    super.key,
    this.onTap,
    required this.label,
    this.fontColor,
    this.bgColor,
    this.borderColor,
    this.disabledColor,
    this.fontSize,
    this.borderRadius,
    this.loading = false,
    this.gradient, // Initialize gradient parameter
    this.padding, // Initialize gradient parameter
  });

  @override
  Widget build(BuildContext context) {
    final borderRadiusValue = borderRadius ?? 40.0;

    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(borderRadiusValue),
      side: BorderSide(color: borderColor ?? Colors.transparent),
    );

    Widget button = MaterialButton(
      onPressed: onTap == null
          ? null
          : !loading
          ? () {
        FocusManager.instance.primaryFocus?.unfocus();
        onTap!();
      }
          : null,
      height: 48,
      minWidth: double.infinity,
      elevation: 0.0,
      disabledColor: disabledColor ?? Theme.of(context).primaryColor.withOpacity(0.5),
      color: gradient == null ? (bgColor ?? Theme.of(context).primaryColor) : Colors.transparent,
      shape: shape,
      child: loading
          ? const SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(
          color: Colors.white,
          strokeWidth: 2,
        ),
      )
          : Text(
        label,
        style: TextStyle(
          color: fontColor ?? Theme.of(context).colorScheme.onPrimary,
          fontWeight: FontWeight.w700,
          fontSize: fontSize ?? 15,
        ),
      ),
    );

    if (gradient != null) {
      button = Container(
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(borderRadiusValue),
        ),
        child: button,
      );
    }

    return Padding(
      padding: padding ?? EdgeInsets.symmetric(horizontal: buttonPadding, vertical: 16),
      child: button,
    );
  }

}