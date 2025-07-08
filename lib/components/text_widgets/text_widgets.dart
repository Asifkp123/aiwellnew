import 'package:aiwel/components/theme/light_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final Color? color;
  final TextAlign? align;
  final int? maxLines;
  final TextOverflow? overflow;
  final bool useBodyStyle;
  final FontWeight? fontweight;
  final double? fontSize;

  const CustomText(
      this.text, {
        super.key,
        this.style,
        this.fontweight,
        this.fontSize,
        this.color,
        this.align,
        this.maxLines,
        this.overflow,
        this.useBodyStyle = false,
      });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final defaultStyle = useBodyStyle
        ? theme.textTheme.bodyLarge?.copyWith(color: color)
        : style?.copyWith(color: color, fontWeight: fontweight, fontSize: fontSize) ?? style;

    return Text(
      text,
      style: defaultStyle ?? theme.textTheme.bodyLarge?.copyWith(
        color: color,
        fontWeight: fontweight,
        fontSize: fontSize,
      ),
      textAlign: align,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}

// === Equivalent Components for Your Text Helpers ===

class LargeBoldText extends CustomText {
   LargeBoldText(
      super.text, {
        super.key,
        super.color,
        super.fontSize,
        super.align,
        super.maxLines,
        super.overflow,
      }) : super(
    style: TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 32, // Example: match Theme.of(context).textTheme.headlineLarge
    ),
  );
}

class MediumBoldText extends CustomText {
   MediumBoldText(
      super.text, {
        super.key,
        super.color,
        super.fontSize,
        super.align,
        super.maxLines,
        super.overflow,
      }) : super(
    style: TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: 24, // Equivalent to headlineMedium
    ),
  );
}

class RegularText extends CustomText {
   RegularText(
      super.text, {
        super.key,
        super.color,
        super.fontSize,
        super.align,
        super.maxLines,
        super.overflow,
      }) : super(
    useBodyStyle: true,
  );
}

class RegularWhiteText extends CustomText {
   RegularWhiteText(
      super.text, {
        super.key,
        super.fontSize,
        super.align,
        super.maxLines,
        super.overflow,
      }) : super(
    style: TextStyle(
      color: Colors.white,
      fontSize: 14, // Adjust as needed
    ),
  );
}

class CommonButtonText extends CustomText {
   CommonButtonText(
      super.text, {
        super.key,
        super.color,
        super.fontSize,
        super.fontweight,
        super.align,
        super.maxLines,
        super.overflow,
      }) : super(

    style: TextStyle(

      fontSize: 14, // Typically for button text
      fontWeight: FontWeight.w600,
    ),
  );


}



class MediumPurpleText extends CustomText {
  MediumPurpleText(
      super.text, {
        super.key,
        super.fontSize,
        super.align,
        super.maxLines,
        super.overflow,
      }) : super(
    style: TextStyle(
      color: Color(0xFF6A1B9A),
      fontSize: fontSize ?? 16,
      fontWeight: FontWeight.w500,
    ),
  );
}
class LargePurpleText extends CustomText {
  LargePurpleText(
      super.text, {
        super.key,
        super.fontSize,
        super.align,
        super.maxLines,
        super.overflow,
      }) : super(
    style: TextStyle(
      color: Color(0xFF543474),
      fontSize: fontSize ?? 32,
      fontWeight: FontWeight.w500,
    ),
  );
}
class NormalGreyText extends CustomText {
  NormalGreyText(
      super.text, {
        super.key,
        super.fontSize,
        super.align,
        super.maxLines,
        super.overflow,
      }) : super(
    style: TextStyle(
      color: Color(0xFF606060),
      fontSize: fontSize ?? 14,
      fontWeight: FontWeight.w400,
    ),
  );
}
class Purple18Text extends CustomText {
  Purple18Text(
      super.text, {
        super.key,
        super.fontSize,
        super.align,
        super.maxLines,
        super.overflow,
        super.color,
      }) : super(
    style: GoogleFonts.poppins(
      color:color?? lightTheme.primaryColor,
      fontSize: fontSize ?? 18,
      fontWeight: FontWeight.w400,

    ),
  );
}
