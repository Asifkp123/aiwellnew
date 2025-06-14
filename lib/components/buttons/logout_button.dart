import 'package:flutter/material.dart';

class LogoutButton extends StatelessWidget {
  final VoidCallback? onTap;
  final String label;
  final Color? bgColor;
  final Color? fontColor;
  final Color? borderColor;
  final bool loading;
  final Color? disabledColor;
  final double? fontSize;

  const LogoutButton({
    super.key,
    this.onTap,
    required this.label,
    this.fontColor,
    this.bgColor,
    this.borderColor,
    this.disabledColor,
    this.fontSize,
    this.loading = false,
  });

  @override
  Widget build(BuildContext context) => MaterialButton(
        onPressed: onTap == null
            ? null
            : !loading
                ? () {
                    FocusManager.instance.primaryFocus?.unfocus();
                    onTap!();
                  }
                : null,
        height: 48,
        elevation: 0.0,
        disabledColor:
            disabledColor ?? Theme.of(context).primaryColor.withValues(alpha:0.5),
        color: bgColor ?? Theme.of(context).primaryColor,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: borderColor ?? Colors.transparent),
        ),
        child: loading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : Text(
                label,
                style: TextStyle(
                  color: fontColor ?? Theme.of(context).colorScheme.onPrimary,
                  fontWeight: FontWeight.w700,
                  fontSize: fontSize ?? 15,
                ),
              ),
      );
}
