import 'dart:io';

import 'package:flutter/cupertino.dart';


const fontFamily = 'Poppins';

const double sidePadding = 20.0;
const String imagePath = 'assets/images';
const String svgPath = 'assets/svg';
const String appName = 'CashLink';
const String appLogo = 'applogo.svg';
const String appLogoSmall = 'assets/images/logoSmall.png';
const double cardPadding = 15.0;
const double bottomPadding = 100.0;
double buttonBottomPadding = Platform.isIOS ? 30 : 20.0;
const double topPadding = 20.0;

const searchDelayDuration = Duration(milliseconds: 800);

LinearGradient splashGradient (){
  return const LinearGradient(
    colors: [Color(0x66D5B3FF), Color(0x66D7BEF6)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}