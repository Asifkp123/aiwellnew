import 'package:flutter/material.dart';
import '../../../../components/custom_image_view.dart';


import '../../../../core/utils/text_style_helper.dart';
import '../../../../core/theme/app_theme.dart';


class MoodOptionWidget extends StatelessWidget {
  final String? imagePath;
  final String? label;
  final bool isSelected;
  final VoidCallback? onTap;

  const MoodOptionWidget({
    Key? key,
    this.imagePath,
    this.label,
    this.isSelected = false,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 72,
        height: 72,
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFF3E8FF) : appTheme.whiteCustom,
          border: Border.all(
            color: isSelected ? const Color(0xFF511D85) : appTheme.colorFFF6F6,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(7),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomImageView(
              imagePath: imagePath ?? '',
              // color: ,
              height: 36,
              width: 36,
            ),
            const SizedBox(height: 4),
            Text(
              label ?? '',
              style: TextStyleHelper.instance.label10Medium,
            ),
          ],
        ),
      ),
    );
  }
}
