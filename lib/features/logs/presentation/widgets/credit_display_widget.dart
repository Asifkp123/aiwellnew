import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../components/constants.dart';
import '../../../../core/managers/credit_manager.dart';
import '../../../credit/presentation/view_models/credit_view_model.dart';

class CreditDisplayWidget extends StatelessWidget {
  final double? fontSize;
  final Color? textColor;
  final bool showIcon;
  final CreditViewModel? creditViewModel; // ← ADD THIS

  const CreditDisplayWidget({
    Key? key,
    this.fontSize,
    this.textColor,
    this.showIcon = true,
    this.creditViewModel, // ← ADD THIS
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Use CreditViewModel if provided, otherwise fallback to CreditManager
    if (creditViewModel != null) {
      return StreamBuilder<CreditState>(
        stream: creditViewModel!.stateStream,
        builder: (context, snapshot) {
          final credits = snapshot.data?.totalCredits ??
              CreditManager.instance.totalCredits;

          return _buildCreditRow(context, credits);
        },
      );
    } else {
      // Fallback to original CreditManager approach
      return ListenableBuilder(
        listenable: CreditManager.instance,
        builder: (context, child) {
          return _buildCreditRow(context, CreditManager.instance.totalCredits);
        },
      );
    }
  }

  Widget _buildCreditRow(BuildContext context, int credits) {
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
          credits.toString(),
          style: TextStyle(
            fontSize: fontSize ?? 13,
            fontWeight: FontWeight.bold,
            color: textColor ?? Theme.of(context).primaryColor,
          ),
        ),
      ],
    );
  }
}
