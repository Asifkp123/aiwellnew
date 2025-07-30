import 'package:flutter/material.dart';
import 'light_theme.dart';

/// 🎨 **App Colors Helper**
///
/// This file demonstrates how to use the theme-based color system.
/// All colors are now centralized in the CustomColors theme extension.
///
/// ## ✅ **How to Use Theme Colors in Your Widgets:**
///
/// ```dart
/// class MyWidget extends StatelessWidget {
///   @override
///   Widget build(BuildContext context) {
///     final colors = AppColors.of(context);
///
///     return Container(
///       color: colors.lightPurpleBackground,
///       child: Text(
///         'Hello',
///         style: TextStyle(color: colors.greyText),
///       ),
///     );
///   }
/// }
/// ```

class AppColors {
  /// Get the CustomColors theme extension from context
  static CustomColors of(BuildContext context) {
    return Theme.of(context).extension<CustomColors>()!;
  }

  /// Quick access to background gradient colors
  static List<Color> backgroundGradientColors(BuildContext context) {
    final colors = of(context);
    return [
      colors.backgroundGradientLight,
      colors.backgroundGradientLighter,
      colors.backgroundGradientWhite,
      colors.backgroundGradientLighter,
      colors.backgroundGradientLight,
    ];
  }

  /// Quick access to button gradient colors
  static List<Color> buttonGradientColors(BuildContext context) {
    final colors = of(context);
    return [colors.buttonGradientStart, colors.buttonGradientEnd];
  }
}

/// 📝 **Usage Examples:**
/// 
/// ## 1. Background Gradient:
/// ```dart
/// Container(
///   decoration: BoxDecoration(
///     gradient: LinearGradient(
///       colors: AppColors.backgroundGradientColors(context),
///       begin: Alignment.topCenter,
///       end: Alignment.bottomCenter,
///       stops: [0.1, 0.2, 0.5, 0.8, 1.0],
///     ),
///   ),
/// )
/// ```
/// 
/// ## 2. Individual Colors:
/// ```dart
/// final colors = AppColors.of(context);
/// Container(
///   color: colors.lightPurpleBackground,
///   child: Icon(Icons.star, color: colors.purpleAccent),
/// )
/// ```
/// 
/// ## 3. Button Gradient:
/// ```dart
/// Container(
///   decoration: BoxDecoration(
///     gradient: LinearGradient(
///       colors: AppColors.buttonGradientColors(context),
///     ),
///   ),
/// )
/// ``` 