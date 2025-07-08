import 'package:flutter/material.dart';
import 'package:aiwel/components/theme/light_theme.dart';

enum SnackBarType { message, error, custom }

class AnimatedSnackBarContent extends StatefulWidget {
  final String content;
  final SnackBarType type;
  final Duration duration;
  final TextStyle? textStyle;

  const AnimatedSnackBarContent({
    Key? key,
    required this.content,
    required this.type,
    this.duration = const Duration(seconds: 3),
    this.textStyle,
  }) : super(key: key);

  @override
  _AnimatedSnackBarContentState createState() => _AnimatedSnackBarContentState();
}

class _AnimatedSnackBarContentState extends State<AnimatedSnackBarContent>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  late Animation<Offset> _positionAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200), // Fade-in and slide duration
    );

    // Opacity animation: from 0.0 (transparent) to 1.0 (fully visible)
    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    // Position animation: slide from below (Offset(0, 1)) to top (Offset(0, 0))
    _positionAnimation = Tween<Offset>(
      begin: const Offset(0, 1), // Start below the screen
      end: const Offset(0, 0), // End at normal position
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    // Start slide-up and fade-in animation
    if (mounted) {
      _controller.forward();
    }

    // Reverse animation (slide down and fade out) before dismissing
    Future.delayed(widget.duration - const Duration(milliseconds: 200), () {
      if (mounted) {
        _controller.reverse().then((_) {
          if (mounted && context.mounted) {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.stop();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Determine default styles based on SnackBarType
    final Color baseColor;
    final TextStyle textStyle;
    switch (widget.type) {
      case SnackBarType.message:
        baseColor = lightTheme.primaryColor; // Theme color for success/message
        textStyle = widget.textStyle ??
            const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w500,
            );
        break;
      case SnackBarType.error:
        baseColor = const Color(0xFFD32F2F); // Red for error
        textStyle = widget.textStyle ??
            const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w500,
            );
        break;
      case SnackBarType.custom:
        baseColor = const Color(0xFF511D85); // Default purple from original
        textStyle = widget.textStyle ??
            const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w500,
            );
        break;
    }

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.translate(
          offset: _positionAnimation.value * 100, // Scale offset for slide effect
          child: Opacity(
            opacity: _opacityAnimation.value,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: baseColor.withOpacity(_opacityAnimation.value), // Apply opacity to background
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                widget.content,
                style: textStyle.copyWith(
                  color: textStyle.color?.withOpacity(_opacityAnimation.value),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

SnackBar commonSnackBarWidget({
  required String content,
  required SnackBarType type,
  Duration duration = const Duration(seconds: 3),
  TextStyle? textStyle,
}) {
  return SnackBar(
    content: AnimatedSnackBarContent(
      content: content,
      type: type,
      duration: duration,
      textStyle: textStyle,
    ),
    duration: duration,
    elevation: 0,
    behavior: SnackBarBehavior.floating,
    backgroundColor: Colors.transparent, // Transparent to allow AnimatedSnackBarContent to handle color
    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10), // Ensure proper positioning
  );
}