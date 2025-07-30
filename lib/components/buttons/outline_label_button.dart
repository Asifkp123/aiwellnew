import 'package:flutter/material.dart';

class OutlineLabelButton extends StatelessWidget {
  final Function? onTap;
  final String label;
  const OutlineLabelButton({
    super.key,
    this.onTap,
    required this.label,
  });

  @override
  Widget build(BuildContext context) => SizedBox(
        height: 48,
        child: OutlinedButton(
          onPressed: () {
            if (onTap != null) {
              onTap!();
            }
          },
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      );
}
