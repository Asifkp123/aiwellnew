import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Text style helper singleton
class TextStyleHelper {
  static final TextStyleHelper _instance = TextStyleHelper._internal();
  static TextStyleHelper get instance => _instance;
  TextStyleHelper._internal();

  // Title styles
  TextStyle get title22Medium => GoogleFonts.poppins(
    fontSize: 22,
    fontWeight: FontWeight.w500,
    color: const Color(0xFF333333),
  );

  TextStyle get title16Medium => GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: Colors.white,
  );

  // Label styles
  TextStyle get label10Medium => GoogleFonts.poppins(
    fontSize: 10,
    fontWeight: FontWeight.w500,
    color: const Color(0xFF333333),
  );

  TextStyle get label12Medium => GoogleFonts.poppins(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: const Color(0xFF333333),
  );

  // Body styles
  TextStyle get body14Regular => GoogleFonts.poppins(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: const Color(0xFF333333),
  );

  TextStyle get body16Medium => GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: const Color(0xFF333333),
  );
}