import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../constants.dart';

class SearchTextField extends StatelessWidget {
  final String hintText;
  final TextInputType? keyboardType;
  final TextEditingController? controller;
  final int? maxLines;
  final Function onChange;
  const SearchTextField(
      {super.key,
      required this.hintText,
      this.keyboardType,
      this.controller,
      this.maxLines,
      required this.onChange});

  @override
  Widget build(BuildContext context) => TextFormField(
      cursorColor: Theme.of(context).colorScheme.surface,
      maxLines: maxLines ?? 1,
      keyboardType: keyboardType,
      controller: controller,
      onChanged: (val) {
        onChange(val);
      },
      style: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
        color: Theme.of(context).colorScheme.surface,
      ),
      decoration: InputDecoration(
          hintText: hintText,
          filled: true,
          fillColor: Colors.white,
          enabledBorder: Theme.of(context)
              .inputDecorationTheme
              .enabledBorder
              ?.copyWith(
                  borderSide: BorderSide(
                      color: const Color(0xff222222).withValues(alpha: 0.15))),
          focusedBorder: Theme.of(context)
              .inputDecorationTheme
              .enabledBorder
              ?.copyWith(
                  borderSide: BorderSide(
                      color: const Color(0xff222222).withValues(alpha: 0.15))),
          prefixIcon: UnconstrainedBox(
            child: SvgPicture.asset(
              '$svgPath/search_icon.svg',
              colorFilter: const ColorFilter.mode(
                Color(0xff878787),
                BlendMode.srcIn,
              ),
              width: 20,
            ),
          )));
}
