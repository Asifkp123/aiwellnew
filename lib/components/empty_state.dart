import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'constants.dart';

class EmptyState extends StatelessWidget {
  final String? svgImage;
  final String? emptyText;
  final double? topPadding;
  final double? width;
  const EmptyState({
    super.key,
    this.svgImage,
    this.emptyText,
    this.topPadding,
    this.width,
  });

  @override
  Widget build(BuildContext context) => Padding(
        padding: EdgeInsets.only(
            top: topPadding ?? 0.2 * MediaQuery.of(context).size.height),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: SvgPicture.asset(
                svgImage != null
                    ? '$svgPath$svgImage'
                    : '$svgPath/empty_illustration.svg',
                width: width ?? 160,
              ),
            ),
            Text(
              emptyText ?? '',
              style: const TextStyle(
                  color: Color(0xffACB1B5),
                  fontWeight: FontWeight.w500,
                  fontSize: 14),
            ),
          ],
        ),
      );
}
