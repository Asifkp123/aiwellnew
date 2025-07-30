import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


Widget gradientDivider() {
  return SizedBox(
    height: 20, // You can adjust this height
    child: Center(
      child: ShaderMask(
        shaderCallback: (Rect bounds) {
          return const LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              Colors.transparent,
              Colors.white,
              Colors.transparent,
            ],
            stops: [0.0, 0.5, 1.0],
          ).createShader(bounds);
        },
        blendMode: BlendMode.srcIn,
        child: Container(
          height: 1,
          width: double.infinity,
          color: Colors.white,
          margin: const EdgeInsets.symmetric(horizontal: 30),
        ),
      ),
    ),
  );
}
