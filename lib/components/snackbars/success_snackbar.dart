import 'package:flutter/material.dart';

SnackBar successSnackBarWidget(String content, {Color? color, Duration? duration}) => SnackBar(
    duration: duration ??const Duration(seconds: 3),
    elevation: 0,
    content: Text(
      content,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 15,
        fontWeight: FontWeight.w500,
      ),
    ),
    backgroundColor: color ?? Color(0xFF511D85),
    behavior: SnackBarBehavior.floating,
  );




// Enum SnackBarType { message, error, custom }
//
// SnackBar successSnackBarWidget(String content,SnackBarType type ) => SnackBar(
//   duration: duration ??const Duration(seconds: 3),
//   elevation: 0,
//   content: Text(
//     content,
//     style: const TextStyle(
//       color: Colors.white,
//       fontSize: 15,
//       fontWeight: FontWeight.w500,
//     ),
//   ),
//   backgroundColor: color ?? Color(0xFF511D85),
//   behavior: SnackBarBehavior.floating,
// );