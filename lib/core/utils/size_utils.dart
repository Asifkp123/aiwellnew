import 'package:flutter/material.dart';

/// Extension for adding size utilities to numbers
extension SizeUtils on num {
  /// Converts number to height value
  double get h => toDouble();
  
  /// Converts number to width value 
  double get w => toDouble();
  
  /// Converts number to font size
  double get fSize => toDouble();
}

/// Size utility functions
class SizeHelper {
  static double getHorizontalSize(double px) => px;
  static double getVerticalSize(double px) => px;
  static double getSize(double px) => px;
  static double getFontSize(double px) => px;
}