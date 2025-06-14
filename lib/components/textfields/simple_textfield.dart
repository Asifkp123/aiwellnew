import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SimpleTextField extends StatelessWidget {
  final String hintText;
  final TextInputType? keyboardType;
  final TextEditingController? controller;
  final int? maxLines;
  final Widget? suffixIcon;
  final FormFieldValidator? validator;
  final bool isObscure;
  final Function? onChange;
  final TextInputAction? textInputAction;
  final Widget? prefixIcon;
  final List<TextInputFormatter>? formatter;
  final bool isEnabled;
  final Color? textColor;
  final Color? fillColor;
  const SimpleTextField({
    super.key,
    required this.hintText,
    this.keyboardType,
    this.controller,
    this.maxLines,
    this.suffixIcon,
    this.validator,
    this.isObscure = false,
    this.onChange,
    this.textInputAction,
    this.prefixIcon,
    this.formatter,
    this.isEnabled = true,
    this.textColor,
    this.fillColor,
  });

  @override
  Widget build(BuildContext context) => TextFormField(
      cursorColor: Theme.of(context).colorScheme.surface,
      maxLines: maxLines ?? 1,
      keyboardType: keyboardType,
      obscureText: isObscure,
      controller: controller,
      validator: validator,
      enabled: isEnabled,
      textInputAction: textInputAction,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      inputFormatters: formatter ?? [],
      onChanged: (val) {
        if (onChange != null) {
          onChange!(val);
        }
      },
      style: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
        color: textColor ?? Theme.of(context).colorScheme.surface,
      ),
      decoration: InputDecoration(
          hintText: hintText,
          suffixIcon: suffixIcon,
          prefixIcon: prefixIcon,
          fillColor: fillColor));
}
