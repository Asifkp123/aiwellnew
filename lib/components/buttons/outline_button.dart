import '../constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class OutlineIconLabelButton extends StatelessWidget {
  final Function? onTap;
  final String label;
  final Color? bgColor;
  final String icon;
  final bool isLoading;
  final Color? borderColor;
  const OutlineIconLabelButton({
    super.key,
    this.onTap,
    required this.label,
    this.bgColor,
    required this.icon,
    this.isLoading = false,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) => MaterialButton(
        onPressed: onTap == null
            ? null
            : () {
                onTap!();
              },
        height: 50,
        elevation: 0.0,
        disabledColor: Theme.of(context).primaryColor.withValues(alpha: 0.5),
        color: bgColor ?? Theme.of(context).cardColor,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
            side: BorderSide(color: borderColor ?? const Color(0xffEDEEF3))),
        child: isLoading
            ? const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 30,
                    height: 30,
                    child: CircularProgressIndicator(),
                  ),
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    '$svgPath/$icon',
                    width: 20,
                    colorFilter: ColorFilter.mode(
                        Theme.of(context).primaryColor, BlendMode.srcIn),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text(
                      label,
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ],
              ),
      );
}
