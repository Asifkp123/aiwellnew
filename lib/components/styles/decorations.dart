import 'package:flutter/material.dart';

BorderRadius cardRadius = BorderRadius.circular(10.0);

BorderRadius topOnlyCardRadius = const BorderRadius.only(
    topLeft: Radius.circular(16.0), topRight: Radius.circular(16.0));

BoxShadow cardShadow = BoxShadow(
    color: Colors.black.withValues(alpha: 0.04),
    offset: const Offset(0, 4),
    blurRadius: 4);

BoxDecoration containerDecoration = BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.circular(8.0),
  border: Border.all(
    color: const Color(0xffEDEDED),
  ),
  boxShadow: [cardShadow]
);
