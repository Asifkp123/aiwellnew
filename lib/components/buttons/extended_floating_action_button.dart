import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../constants.dart';

class ExtendedFloatingButton extends StatelessWidget {
  final Function onTap;
  final String? icon;
  final String label;
  final String? heroTag;
  const ExtendedFloatingButton(
      {super.key,
      required this.onTap,
      this.heroTag,
      this.icon,
      required this.label});

  @override
  Widget build(BuildContext context) => SizedBox(
        height: 80,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 30),
          child: FloatingActionButton.extended(
              heroTag: heroTag,
              onPressed: () {
                FocusManager.instance.primaryFocus?.unfocus();
                onTap();
              },
              backgroundColor: Theme.of(context).primaryColor,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0)),
              label: Row(
                children: [
                  icon != null
                      ? SvgPicture.asset(
                          '$svgPath$icon',
                          colorFilter: const ColorFilter.mode(
                              Colors.white, BlendMode.srcIn),
                        )
                      : SvgPicture.asset('$svgPath/add_icon.svg'),
                  Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: Text(
                      label,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSecondary,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  )
                ],
              )),
        ),
      );
}
