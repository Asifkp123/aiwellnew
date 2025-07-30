import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../components/constants.dart';
import '../../../components/text_widgets/text_widgets.dart';

class CarePointsCard extends StatelessWidget {
  const CarePointsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xCCFFFFFF), // #FFFFFFCC (80% opacity)
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          // Points Bubble
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFF1E6FD), // Light purple background
              borderRadius: BorderRadius.circular(32),
            ),
            child: Row(
              children: [
                SvgPicture.asset(
                  '$svgPath/purple_love.svg', // Your SVG asset path
                  width: 16,
                  height: 16,
                ),
                const SizedBox(width: 4),
                const Text(
                  '120',
                  style: TextStyle(
                    color: Color(0xFF8E2EFF), // Purple
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 12),

          // Text Column
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children:  [
              MediumPurpleText('You Earned Care Points'),
              SizedBox(height: 4),

              Text("Check how to use it",style: TextStyle(
                color: Color(0xFF606060),
                fontSize:  14,
                fontWeight: FontWeight.w400,
                decoration: TextDecoration.underline, // 👈 underline added here

              ),)
            ],
          ),
        ],
      ),
    );
  }
}
