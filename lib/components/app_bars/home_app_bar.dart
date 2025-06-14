
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../constants.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback? onProfileTap;

  const HomeAppBar({Key? key, this.onProfileTap}) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leadingWidth: 200,
      leading: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(
            appLogoSmall,
            scale: 1.3,
            fit: BoxFit.cover,
          ),
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
            onTap: onProfileTap,
            child: CircleAvatar(
              backgroundColor: const Color(0xffF2F2F2),
              child: SvgPicture.asset('$svgPath/userProfileICon.svg'),
            ),
          ),
        )
      ],
    );
  }
}