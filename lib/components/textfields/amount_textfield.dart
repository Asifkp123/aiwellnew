import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AmountTextField extends StatelessWidget {
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
  final TextInputFormatter? formatter;
  final double? fontsize;

  const AmountTextField(
      {super.key,
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
      this.fontsize});

  @override
  Widget build(BuildContext context) => TextFormField(
      cursorColor: Theme.of(context).colorScheme.surface,
      maxLines: maxLines ?? 1,
      keyboardType: keyboardType,
      textAlign: TextAlign.center,
      obscureText: isObscure,
      controller: controller,
      validator: validator,
      textInputAction: textInputAction,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      inputFormatters: formatter == null ? [] : [formatter!],
      onChanged: (val) {
        if (onChange != null) {
          onChange!(val);
        }
      },
      style: TextStyle(
        fontSize: fontsize ?? 25,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
        color: Theme.of(context).colorScheme.surface,
      ),
      decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            fontSize: fontsize ?? 25,
            color: Theme.of(context).inputDecorationTheme.hintStyle?.color,
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 15),
          suffixIcon: suffixIcon,
          prefixIcon: prefixIcon));
}
