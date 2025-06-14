import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // Import google_fonts

final ThemeData lightTheme = ThemeData(
  fontFamily: GoogleFonts.poppins().fontFamily, // Set Poppins as the default font family
  primaryColor: const Color(0xFF6A1B9A),
  colorScheme: ColorScheme(
    brightness: Brightness.light,
    primary: const Color(0xFF6A1B9A),
    onPrimary: Colors.white,
    secondary: const Color(0xFFE1BEE7),
    onSecondary: const Color(0xFF333333),
    error: const Color(0xFFB71C1C),
    onError: Colors.white,
    surface: const Color(0xFFFFFFFF),
    onSurface: const Color(0xFF333333),
    onSurfaceVariant: const Color(0xFFEDEEF3),
    surfaceContainer: const Color(0xFFE1BEE7).withOpacity(0.3),
    tertiary: const Color(0xFF878CA7).withOpacity(0.7),
  ),
  indicatorColor: const Color(0xFFEDEEF3),
  cardColor: Colors.white,
  iconTheme: const IconThemeData(color: Color(0xFF333333)),
  primaryColorDark: const Color(0xFF4A0072),
  dividerColor: const Color(0xFFEDEEF3),
  highlightColor: Colors.transparent,
  splashColor: Colors.transparent,
  scaffoldBackgroundColor: const Color(0xFFFFFFFF),
  dividerTheme: const DividerThemeData(color: Color(0xFFEDEEF3), thickness: 1),
  hintColor: const Color(0xFF878CA7).withOpacity(0.7),
  canvasColor: Colors.white,
  useMaterial3: true,
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.white,
    iconTheme: const IconThemeData(color: Color(0xFF333333)),
    actionsIconTheme: const IconThemeData(color: Color(0xFF333333)),
    surfaceTintColor: Colors.transparent,
    shadowColor: Colors.black.withOpacity(0.2),
    scrolledUnderElevation: 3,
    elevation: 0,
    titleTextStyle: GoogleFonts.poppins(
      color: const Color(0xFF333333),
      fontWeight: FontWeight.w700,
      fontSize: 18,
    ),
  ),
  buttonTheme: ButtonThemeData(
    buttonColor: const Color(0xFF6A1B9A),
    disabledColor: const Color(0xFF6A1B9A).withOpacity(0.5),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(8.0)),
    ),
    textTheme: ButtonTextTheme.accent,
    colorScheme: const ColorScheme.light(
      secondary: Colors.white,
      primary: Color(0xFF6A1B9A),
    ),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: ButtonStyle(
      elevation: WidgetStateProperty.all<double?>(0.0),
      textStyle: WidgetStateProperty.resolveWith<TextStyle?>(
            (Set<WidgetState> states) => GoogleFonts.poppins(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: const Color(0xFF6A1B9A),
        ),
      ),
      foregroundColor: WidgetStateProperty.resolveWith<Color?>(
            (Set<WidgetState> states) => const Color(0xFF6A1B9A),
      ),
      side: WidgetStateProperty.all<BorderSide?>(
        const BorderSide(color: Color(0xFF6A1B9A), width: 1),
      ),
      shape: WidgetStateProperty.all<OutlinedBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: const Color(0xFFFFFFFF),
    isDense: true,
    hintStyle: GoogleFonts.poppins(
      color: const Color(0xFF878CA7),
      fontSize: 13,
      fontWeight: FontWeight.w500,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
      borderSide: const BorderSide(
        color: Color(0xFFEDEEF3),
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
      borderSide: const BorderSide(
        color: Color(0xFF6A1B9A),
      ),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
      borderSide: const BorderSide(
        color: Color(0xFFB71C1C),
      ),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
      borderSide: const BorderSide(
        color: Color(0xFFB71C1C),
      ),
    ),
    errorStyle: GoogleFonts.poppins(
      fontWeight: FontWeight.w500,
      fontSize: 14,
      color: const Color(0xFFB71C1C),
    ),
    disabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
      borderSide: const BorderSide(
        color: Color(0xFFEDEEF3),
      ),
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 13),
  ),
  textTheme: TextTheme(
    bodyMedium: GoogleFonts.poppins(
      color: const Color(0xFF333333),
      fontSize: 15,
      fontWeight: FontWeight.w500,
    ),
    bodySmall: GoogleFonts.poppins(
      color: const Color(0xFF878CA7),
      fontSize: 13,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.1,
    ),
    displaySmall: GoogleFonts.poppins(
      color: const Color(0xFF878CA7),
      fontWeight: FontWeight.w500,
      fontSize: 13,
    ),
    displayMedium: GoogleFonts.poppins(
      color: const Color(0xFF333333),
      fontWeight: FontWeight.w700,
      fontSize: 15,
    ),
  ).apply(
    bodyColor: const Color(0xFF333333),
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Color(0xFF6A1B9A),
    foregroundColor: Colors.white,
    elevation: 1,
  ),
  popupMenuTheme: PopupMenuThemeData(
    iconColor: const Color(0xFF333333),
    elevation: 0.0,
    color: Colors.white,
    textStyle: GoogleFonts.poppins(color: const Color(0xFF333333)),
    shadowColor: Colors.black.withOpacity(0.3),
    shape: RoundedRectangleBorder(
      side: const BorderSide(
        color: Color(0xFFEDEEF3),
      ),
      borderRadius: BorderRadius.circular(10.0),
    ),
  ),
  bottomSheetTheme: BottomSheetThemeData(
    backgroundColor: Colors.white,
    modalBarrierColor: const Color(0xFF333333).withOpacity(0.3),
    clipBehavior: Clip.antiAliasWithSaveLayer,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20.0),
        topRight: Radius.circular(20.0),
      ),
    ),
  ),
  dialogBackgroundColor: Colors.white,
  drawerTheme: const DrawerThemeData(
    backgroundColor: Colors.white,
    shape: RoundedRectangleBorder(),
  ),
  datePickerTheme: DatePickerThemeData(
    backgroundColor: Colors.white,
    shadowColor: Colors.transparent,
    headerForegroundColor: const Color(0xFF333333),
    dayForegroundColor: WidgetStateProperty.all<Color>(const Color(0xFF333333)),
    rangePickerHeaderForegroundColor: const Color(0xFF333333),
    yearForegroundColor: WidgetStateProperty.all<Color>(const Color(0xFF333333)),
    dividerColor: const Color(0xFFEDEEF3),
    weekdayStyle: GoogleFonts.poppins(color: const Color(0xFF333333)),
    headerHeadlineStyle: GoogleFonts.poppins(color: const Color(0xFF333333)),
    headerHelpStyle: GoogleFonts.poppins(color: const Color(0xFF333333)),
    yearStyle: GoogleFonts.poppins(color: const Color(0xFF333333)),
    dayStyle: GoogleFonts.poppins(color: const Color(0xFF333333)),
    inputDecorationTheme: InputDecorationTheme(
      labelStyle: GoogleFonts.poppins(color: const Color(0xFF333333)),
      hintStyle: GoogleFonts.poppins(color: const Color(0xFF878CA7)),
    ),
    yearOverlayColor: WidgetStateProperty.all<Color>(const Color(0xFF6A1B9A)),
    todayForegroundColor: WidgetStateProperty.all<Color>(const Color(0xFF6A1B9A)),
  ),
  timePickerTheme: const TimePickerThemeData(
    backgroundColor: Colors.white,
  ),
  chipTheme: const ChipThemeData(backgroundColor: Colors.white),
  checkboxTheme: const CheckboxThemeData(
    side: BorderSide(color: Color(0xFF6A1B9A), width: 1.5),
    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
  ),
);