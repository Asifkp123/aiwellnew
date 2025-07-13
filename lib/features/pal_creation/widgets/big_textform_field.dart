import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../components/styles/decorations.dart';

class BigTextformField extends StatelessWidget {
  final TextEditingController? controller;

  const BigTextformField({super.key, this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.grey.shade200, // Light gray border
        ),
          boxShadow: [cardShadow]

      ),
      child: TextFormField(
        inputFormatters: [
          LengthLimitingTextInputFormatter(400), // Limits input to 400 characters
        ],
        controller: controller,
        maxLines: 10,
        style: const TextStyle(
          fontSize: 16,
          color: Colors.black87,
        ),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          hintText: "Enter text here",
          hintStyle: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w400,
            color: Colors.grey.shade500, // Subtle gray
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
