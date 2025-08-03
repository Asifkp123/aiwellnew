import 'package:flutter/material.dart';
import '../../components/theme/app_colors.dart';

/// App theme helper that provides access to colors and theme properties
class AppTheme {
  static AppTheme? _instance;
  static AppTheme get instance => _instance ??= AppTheme._();
  AppTheme._();

  // Background colors
  Color get color800000 => const Color(0xFF800000).withOpacity(0.8);
  Color get whiteCustom => Colors.white;
  Color get blackCustom => Colors.black;
  Color get transparentCustom => Colors.transparent;
  
  // Custom colors
  Color get colorFF9757 => const Color(0xFFFF9757);
  Color get colorFFF6F6 => const Color(0xFFFFF6F6);
}

/// Global app theme instance
final appTheme = AppTheme.instance;