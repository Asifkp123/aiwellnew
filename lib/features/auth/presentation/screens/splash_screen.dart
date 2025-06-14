import 'dart:ui';
import 'package:aiwel/components/buttons/label_button.dart';
import 'package:flutter/material.dart';

import '../../../../components/constants.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFE4D6FA), // light purple
              Color(0xFFF1EAFE), // even lighter
              Color(0xFFFFFFFF), // white middle
              Color(0xFFF1EAFE),
              Color(0xFFE4D6FA),
            ],
            stops: [0.0, 0.2, 0.5, 0.8, 1.0],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo
            Image.asset(
              '$imagePath/applogo.png',
              height: 120,
              width: 120,
            ),

            const SizedBox(height: 30),

            // App name
            const Text(
              "aiwel",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
                letterSpacing: 1.5,
              ),
            ),

            const SizedBox(height: 5),

            // Tagline
            const Text(
              "Take Care",
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
                fontWeight: FontWeight.w400,
              ),
            ),

            const SizedBox(height: 80),


            LabelButton(
              label: 'OK',
              onTap: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              gradient: splashGradient(),
              // bgColor: const Color(0xffF6F6F6),
              fontColor: Theme.of(context).primaryColor,
            ),
          ],
        ),
      ),
    );
  }
}