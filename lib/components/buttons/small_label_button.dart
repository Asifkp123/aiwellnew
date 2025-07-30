import 'package:flutter/material.dart';

class SmallLabelButton extends StatelessWidget {
  final Function? onTap;
  final String label;
  final Color? bgColor;
  final Color? fontColor;
  final Color? borderColor;
  final bool loading;
  final Color? disabledColor;
  const SmallLabelButton(
      {super.key,
      this.onTap,
      required this.label,
      this.fontColor,
      this.bgColor,
      this.borderColor,
      this.disabledColor,
      this.loading = false});

  @override
  Widget build(BuildContext context) => SizedBox(
        width: 75,
        child: MaterialButton(
          onPressed: !loading
              ? onTap == null
                  ? null
                  : () {
                      onTap!();
                    }
              : null,
          height: 38,
          elevation: 0.0,
          disabledColor:
              disabledColor ?? Theme.of(context).primaryColor.withValues(alpha:0.5),
          color: bgColor ?? Theme.of(context).primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(32.0),
            side: BorderSide(color: borderColor ?? Colors.transparent),
          ),
          child: loading
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ))
              : Text(
                  label,
                  style: TextStyle(
                    color: fontColor ?? Theme.of(context).colorScheme.onPrimary,
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
        ),
      );
}
