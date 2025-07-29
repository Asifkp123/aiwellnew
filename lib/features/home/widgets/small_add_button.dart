import 'package:aiwel/components/theme/light_theme.dart';
import 'package:flutter/material.dart';

import '../../../components/constants.dart';
import '../../../components/text_widgets/text_widgets.dart';

Widget buildSmallAddButtonForFulWidth(BuildContext context, {double? buttonHeight}) {
  final height = buttonHeight ?? 25;
  return SizedBox(
    height: height,
    child: Container(
      decoration: BoxDecoration(
        color: lightTheme.primaryColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: MaterialButton(
        onPressed:  () {},
        minWidth: 50,
        elevation: 0,
        color: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: 8,
          vertical:
          height < 20 ? 0 : 4, // No vertical padding for small buttons
        ),
        child: RegularWhiteText(
          "Add",
          fontSize: 12,
        ),
      ),
    ),
  );
}
