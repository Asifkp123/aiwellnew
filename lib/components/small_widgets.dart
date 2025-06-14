
import 'package:aiwel/components/styles/decorations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'constants.dart';
//logo
Widget logoWidget({double? width, double? height}) => SvgPicture.asset(
      '$svgPath/$appLogo',
      width: width ?? 110,
    );

Widget authTextfieldLabel({
  required String label,
  Color? color,
}) =>
    Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Text(
        label,
        style: TextStyle(
          color: color ?? const Color(0xff323442),
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );

Widget textfieldLabel(
        {required String label,
        required BuildContext context,
        double? topPadding,
        bool isRequired = false}) =>
    Padding(
      padding: EdgeInsets.only(bottom: 8, top: topPadding ?? 0),
      child: Row(
        children: [
          Text(
            label,
            style: const TextStyle(
                color: Color(0xff4E4E4E),
                fontSize: 13,
                fontWeight: FontWeight.w400),
          ),
          if (isRequired)
            const Padding(
              padding: EdgeInsets.only(left: 2),
              child: Text(
                '*',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
    );

Widget dialogHeader(
        {required BuildContext context,
        required String title,
        double? bottomPadding,
        Function? onBack}) =>
    Padding(
      padding: EdgeInsets.only(bottom: bottomPadding ?? 20),
      child: Column(
        children: [
          // headerLine(context,
          //     marginBottom: 5, bgColor: const Color(0xFF171718)),
          Padding(
            padding: const EdgeInsets.only(left: sidePadding, right: 5, top: 5),
            child: Row(
              children: [
                Expanded(
                    child: Text(
                  title,
                  style: const TextStyle(
                      color: Color(0xff4E4E4E),
                      fontWeight: FontWeight.w500,
                      fontSize: 16.0),
                )),
                IconButton(
                    onPressed: () {
                      if (onBack != null) {
                        onBack();
                      } else {
                        Navigator.pop(context);
                      }
                    },
                    icon: SvgPicture.asset('$svgPath/close.svg'))
              ],
            ),
          ),
          const Divider(
            height: 0,
            thickness: 1,
            color: Color(0xffF1F1F1),
          )
        ],
      ),
    );

Widget iconWithRound(
        {required String icon,
        Color? color,
        double? iconSize,
        Color? iconColor,
        double? radius}) =>
    CircleAvatar(
      backgroundColor: color ?? const Color(0xff88E3DC).withValues(alpha: 0.2),
      radius: radius ?? 20,
      child: SvgPicture.asset(
        '$svgPath$icon',
        width: iconSize ?? 16,
        colorFilter: ColorFilter.mode(
            iconColor ?? const Color(0xff00B6A9), BlendMode.srcIn),
      ),
    );

Widget roundIconButton(
        {required Function ontap,
        required String icon,
        bool selected = false}) =>
    IconButton.filledTonal(
      isSelected: selected,
      icon: SvgPicture.asset(
        '$svgPath$icon',
        colorFilter: const ColorFilter.mode(
          Color(0xff00B6A9),
          BlendMode.srcIn,
        ),
        width: 22,
      ),
      selectedIcon: SvgPicture.asset(
        '$svgPath$icon',
        colorFilter: const ColorFilter.mode(
          Colors.white,
          BlendMode.srcIn,
        ),
        width: 22,
      ),
      onPressed: () {
        ontap();
      },
      style: ButtonStyle(
          elevation: WidgetStateProperty.resolveWith((states) => 3),
          shadowColor: WidgetStateProperty.resolveWith(
              (states) => Colors.black.withValues(alpha: 0.3)),
          backgroundColor: selected
              ? WidgetStateProperty.resolveWith(
                  (states) => const Color(0xff00B6A9))
              : WidgetStateProperty.resolveWith((states) => Colors.white),
          minimumSize:
              WidgetStateProperty.resolveWith((states) => const Size(40, 40))),
    );

Widget headerLine(BuildContext context,
        {double? marginBottom, Color? bgColor}) =>
    Container(
        width: MediaQuery.of(context).size.width / 2.8,
        height: 6,
        margin: EdgeInsets.only(top: 12, bottom: marginBottom ?? 30),
        decoration: BoxDecoration(
          color: bgColor ?? Colors.black.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(30.0),
        ));

Widget cardIcon(
        {required String icon,
        double? iconSize,
        double? size,
        double? radius,
        Color? color,
        Color? bgColor,
        double? height}) =>
    Container(
      width: size ?? 50,
      height: size ?? 49,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius:
            radius != null ? BorderRadius.circular(radius) : cardRadius,
        color: bgColor ?? const Color(0xffF4F4F4),
      ),
      child: SvgPicture.asset(
        '$svgPath$icon',
        width: iconSize ?? 21,
        colorFilter: ColorFilter.mode(
          color ?? const Color(0xff82A5A2),
          BlendMode.srcIn,
        ),
      ),
    );
Widget roundedCardIcon(
        {required String icon,
        double? iconSize,
        double? size,
        double? radius,
        Color? color,
        Color? bgColor,
        double? height}) =>
    Container(
      width: size ?? 36,
      height: size ?? 36,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        // borderRadius:
        //     radius != null ? BorderRadius.circular(radius) : cardRadius,
        color: bgColor ?? const Color(0xffEFFEFB),
      ),
      child: SvgPicture.asset(
        '$svgPath$icon',
        width: iconSize ?? 21,
        colorFilter: ColorFilter.mode(
          color ?? const Color(0xff82A5A2),
          BlendMode.srcIn,
        ),
      ),
    );
Widget notificationIcon(
        {required String icon,
        double? iconSize,
        double? size,
        double? radius,
        Color? color,
        Color? bgColor,
        Function? ontap,
        double? height}) =>
    InkWell(
      onTap: ontap == null ? null : () => ontap(),
      child: Container(
        width: size ?? 50,
        height: size ?? 49,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius:
              radius != null ? BorderRadius.circular(radius) : cardRadius,
          color: bgColor ?? const Color(0xffF4F4F4),
        ),
        child: SvgPicture.asset(
          '$svgPath$icon',
          width: iconSize ?? 21,
          colorFilter: ColorFilter.mode(
            color ?? const Color(0xffF4F4F4),
            BlendMode.srcIn,
          ),
        ),
      ),
    );

Widget iconCard({required String icon, double? iconSize}) => Container(
      width: 40,
      height: 40,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: const Color(0xffC5CED3).withValues(alpha: 0.25),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: SvgPicture.asset(
        '$svgPath$icon',
        width: iconSize ?? 20,
      ),
    );

Widget cardCheckBox({
  required bool value,
  required Function(bool?) onChanged,
  double? size,
  double? radius,
  Color? checkColor,
  Color? bgColor,
  double? borderWidth,
}) =>
    Checkbox(
      value: value,
      onChanged: onChanged,
      activeColor: checkColor ?? const Color(0xff82A5A2),
      // shape: RoundedRectangleBorder(
      //   borderRadius: BorderRadius.circular(radius ?? 8),
      // ),
    );
Widget profileIcon(
        {required String name,
        String? image,
        double? fontSize,
        Color? bgColor,
        required BuildContext context,
        double? radius}) =>
    image == null
        ? CircleAvatar(
            //backgroundColor: bgColor ?? const Color(0xff82A5A2),
            radius: radius ?? 22,
            backgroundImage: const AssetImage('$imagePath/profile.png'),

            // child: Text(
            //   getFirstLetters(name),
            //   style: TextStyle(
            //       color: Theme.of(context).colorScheme.onPrimary,
            //       fontWeight: FontWeight.w500,
            //       fontSize: fontSize ?? 15.0),
            // ),
          )
        : CircleAvatar(
            radius: radius ?? 22,
            backgroundImage: NetworkImage(image),
          );

Widget subtitle({required String text, double? bottomPadding}) => Padding(
      padding: EdgeInsets.only(
        left: sidePadding,
        right: sidePadding,
        bottom: bottomPadding ?? 15,
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Color(0xff171718),
          fontSize: 15,
          fontWeight: FontWeight.w700,
        ),
      ),
    );

Widget titleSubTitle({required String title, required String subTitle}) =>
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Color(0xff878CA7),
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Text(
            subTitle,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        )
      ],
    );
