import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../components/constants.dart';
import '../../../../core/managers/credit_manager.dart';

class CreditDisplayWidget extends StatelessWidget {
  final double? fontSize;
  final Color? textColor;
  final bool showIcon;

  const CreditDisplayWidget({
    Key? key,
    this.fontSize,
    this.textColor,
    this.showIcon = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: CreditManager.instance,
      builder: (context, child) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (showIcon) ...[
              SvgPicture.asset(
                "$svgPath/Heart Icon Home.svg",
                height: fontSize != null ? fontSize! + 2 : 15,
                width: fontSize != null ? fontSize! : 13,
              ),
              const SizedBox(width: 4),
            ],
            Text(
              CreditManager.instance.totalCredits.toString(),
              style: TextStyle(
                fontSize: fontSize ?? 13,
                fontWeight: FontWeight.bold,
                color: textColor ?? Theme.of(context).primaryColor,
              ),
            ),
          ],
        );
      },
    );
  }
}
