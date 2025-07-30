import 'package:aiwel/features/home/widgets/add_pal_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:aiwel/components/constants.dart';
import '../../../components/theme/light_theme.dart';
import 'glass_effect_widget.dart';

class MusicSuggestionWidget extends StatelessWidget {
  final VoidCallback? onConnectSpotify;
  final double screenWidth;

  const MusicSuggestionWidget({
    super.key,
    this.onConnectSpotify,
    required this.screenWidth,
  });

  @override
  Widget build(BuildContext context) {
    return GlassEffectWidget(
      width: double.infinity,
      height: 200,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Music suggestion text
            Text(
              "We can suggest you some good music",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w400,
                color: lightTheme.primaryColor,
                height: 1.3,
              ),
            ),

            const SizedBox(height: 20),

            // Spotify connection row with white border
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.white,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
             Center(
              child: SvgPicture.asset(
                '$svgPath/spotify.svg',
                width: 24,
                height: 24,
                fit: BoxFit.contain,


      ),
    ),
                  const SizedBox(width: 15),

                  // Connect Spotify button
                  Expanded(
                    child: AddSpotifyButtonWidget(context,
                        buttonWidth: 168, buttonHeight: 40),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
