import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../buttons/label_button.dart';
import '../constants.dart';
import '../small_widgets.dart';


class RequestSuccessDialog extends StatelessWidget {
  final String? headerTitle;
  final String title;
  final String subtitle;
  const RequestSuccessDialog({
    super.key,
    this.headerTitle,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) => Container(
        height: 500,
        color: Theme.of(context).colorScheme.onPrimary,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            dialogHeader(
                context: context,
                title: 'Done',
                onBack: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                }),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: sidePadding),
              child: Column(
                children: [
                  Padding(
                      padding: const EdgeInsets.only(top: 30),
                      child: SvgPicture.asset('$svgPath/success.svg')),
                  Padding(
                    padding: const EdgeInsets.only(top: 35),
                    child: Text(
                      title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).colorScheme.surface,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text(
                      subtitle,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Color(0xffA1A2A2),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(
                  left: sidePadding, right: sidePadding, bottom: 20),
              child: SizedBox(
                width: double.maxFinite,
                child: LabelButton(
                  label: 'OK',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  // bgColor: const Color(0xffF6F6F6),
                  bgColor:  Theme.of(context).colorScheme.secondary,
                  fontColor: Theme.of(context).primaryColor,
                ),
              ),
            ),
          ],
        ),
      );
}
