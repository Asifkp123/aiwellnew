import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';

class PinputWidget extends StatelessWidget {
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onCompleted;

  const PinputWidget({
    super.key,
    this.controller,
    this.onChanged,
    this.onCompleted,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final inputTheme = theme.inputDecorationTheme;
    final colorScheme = theme.colorScheme;

    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    // Shared text style
    final textStyle = GoogleFonts.poppins(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: colorScheme.onSurface,
    );

    // Default box decoration using theme values
    final defaultBoxDecoration = BoxDecoration(
      color: inputTheme.fillColor ?? Colors.white,
      borderRadius: (inputTheme.enabledBorder is OutlineInputBorder)
          ? (inputTheme.enabledBorder as OutlineInputBorder).borderRadius
          : BorderRadius.circular(8),
      border: Border.all(
        color: inputTheme.enabledBorder?.borderSide.color ?? colorScheme.outline,
        width: inputTheme.enabledBorder?.borderSide.width ?? 1.0,
      ),
      boxShadow: const [
        BoxShadow(
          blurRadius: 8,
          spreadRadius: -1,
          offset: Offset(3, 4),
          color: Colors.black12,
        )
      ],
    );

    final focusedBoxDecoration = BoxDecoration(
      color: inputTheme.fillColor ?? Colors.white,
      borderRadius: (inputTheme.focusedBorder is OutlineInputBorder)
          ? (inputTheme.focusedBorder as OutlineInputBorder).borderRadius
          : BorderRadius.circular(8),
      border: Border.all(
        color: inputTheme.focusedBorder?.borderSide.color ?? theme.primaryColor,
        width: inputTheme.focusedBorder?.borderSide.width ?? 1.5,
      ),
    );

    final submittedBoxDecoration = BoxDecoration(
      color: inputTheme.fillColor ?? Colors.white,
      borderRadius: (inputTheme.enabledBorder is OutlineInputBorder)
          ? (inputTheme.enabledBorder as OutlineInputBorder).borderRadius
          : BorderRadius.circular(8),
      border: Border.all(
        color: inputTheme.enabledBorder?.borderSide.color ?? colorScheme.onSurface,
        width: inputTheme.enabledBorder?.borderSide.width ?? 1.0,
      ),
      boxShadow: const [
        BoxShadow(
          blurRadius: 8,
          spreadRadius: -1,
          offset: Offset(3, 4),
          color: Colors.black12,
        )
      ],
    );

    return Pinput(
      length: 6,
      controller: controller,
      onChanged: onChanged,
      onCompleted: onCompleted,
      onTapOutside: (_) => FocusScope.of(context).unfocus(),
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      defaultPinTheme: PinTheme(
        height: height / 16,
        width: width / 6,
        textStyle: textStyle,
        decoration: defaultBoxDecoration,
      ),
      focusedPinTheme: PinTheme(
        height: height / 16,
        width: width / 6,
        textStyle: textStyle,
        decoration: focusedBoxDecoration,
      ),
      submittedPinTheme: PinTheme(
        height: height / 16,
        width: width / 6,
        textStyle: textStyle,
        decoration: submittedBoxDecoration,
      ),
    );
  }
}