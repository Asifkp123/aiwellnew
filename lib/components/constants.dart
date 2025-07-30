import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'theme/light_theme.dart';

const fontFamily = 'Poppins';

const double sidePadding = 20.0;
const String imagePath = 'assets/images';
const String svgPath = 'assets/svg';
const String appName = 'CashLink';
const String appLogo = 'applogo.svg';
const String appLogoSmall = 'assets/images/logoSmall.png';
const double cardPadding = 15.0;
const double scaffoldPadding = 16.0;
const double buttonPadding = 5.0;
const double bottomPadding = 100.0;
double buttonBottomPadding = Platform.isIOS ? 30 : 20.0;
const double topPadding = 20.0;

const searchDelayDuration = Duration(milliseconds: 800);

// ✅ NEW: Theme-based gradient functions
LinearGradient splashGradient([BuildContext? context]) {
  if (context != null) {
    final customColors = Theme.of(context).extension<CustomColors>()!;
    return LinearGradient(
      colors: [
        customColors.buttonGradientStart,
        customColors.buttonGradientEnd
      ],
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
    );
  }
  // Fallback for cases where context is not available
  return const LinearGradient(
    colors: [Color(0xFF543474), Color(0xFF9858D8)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );
}

LinearGradient homeBackgroundGradient([BuildContext? context]) {
  if (context != null) {
    final customColors = Theme.of(context).extension<CustomColors>()!;
    return LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        customColors.backgroundGradientLight,
        customColors.backgroundGradientLighter,
        customColors.backgroundGradientWhite,
        customColors.backgroundGradientLighter,
        customColors.backgroundGradientLight,
      ],
      stops: const [0.1, 0.2, 0.5, 0.8, 1.0],
    );
  }
  // Fallback for cases where context is not available
  return const LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFFE4D6FA), // light purple
      Color(0xFFF1EAFE), // even lighter
      Color(0xFFFFFFFF), // white middle
      Color(0xFFF1EAFE), // even lighter
      Color(0xFFE4D6FA), // light purple
    ],
    stops: [0.1, 0.2, 0.5, 0.8, 1.0],
  );
}
