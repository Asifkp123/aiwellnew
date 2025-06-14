import 'package:flutter/material.dart';

class AuthTextfield extends StatelessWidget {
  final String hintText;
  final TextInputType? keyboardType;
  final TextEditingController? controller;
  final Widget? prefixIcon;
  final bool isObscure;
  final Function(String)? onChange;
  final FormFieldValidator<String>? validator;
  final bool isEnabled;
  final TextInputAction? textInputAction;
  final double? borderRadius;
  final Widget? suffixIcon;

  const AuthTextfield({
    super.key,
    required this.hintText,
    this.keyboardType,
    this.controller,
    this.prefixIcon,
    this.isObscure = false,
    this.onChange,
    this.isEnabled = true,
    this.validator,
    this.textInputAction,
    this.borderRadius,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) => TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: validator,
        enabled: isEnabled,
        style: TextStyle(
          color: Theme.of(context).colorScheme.surface,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
        obscureText: isObscure,
        onChanged: onChange,
        textInputAction: textInputAction ?? TextInputAction.done,
        decoration: InputDecoration(
          filled: true,
          fillColor: const Color(0xffFCFCFC),
          isDense: true,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          hintText: hintText,
          hintStyle: const TextStyle(
            color: Color(0xff878CA7),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          errorStyle: const TextStyle(fontSize: 0, height: 0),
          prefixIcon: prefixIcon != null
              ? Padding(
                  padding: const EdgeInsets.only(right: 15, left: 15),
                  child: prefixIcon,
                )
              : null,
          suffixIcon: suffixIcon,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? 12.0),
            borderSide: const BorderSide(
              color: Color(0xffEDEEF3),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? 12.0),
            borderSide: const BorderSide(
              color: Color(0xffEDEEF3),
            ),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? 12.0),
            borderSide: const BorderSide(
              color: Color(0xffEDEEF3),
            ),
          ),
        ),
      );
}
