import 'package:flutter/material.dart';
import '../constants.dart';
import '../theme/app_colors.dart';

/// A reusable container widget with the standard app background gradient
///
/// Usage:
/// ```dart
/// GradientBackgroundContainer(
///   child: YourContentWidget(),
/// )
/// ```
class GradientBackgroundContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final bool addSafeArea;

  const GradientBackgroundContainer({
    super.key,
    required this.child,
    this.padding,
    this.addSafeArea = true,
  });

  @override
  Widget build(BuildContext context) {
    Widget content = Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: homeBackgroundGradient(context), // ✅ Now uses theme colors!
      ),
      child: padding != null ? Padding(padding: padding!, child: child) : child,
    );

    return addSafeArea ? SafeArea(child: content) : content;
  }
}

/// A reusable scaffold with gradient background - ready to use
///
/// Usage:
/// ```dart
/// GradientBackgroundScaffold(
///   body: YourContentWidget(),
///   floatingActionButton: YourButton(),
/// )
/// ```
class GradientBackgroundScaffold extends StatelessWidget {
  final Widget body;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final EdgeInsets? bodyPadding;
  final PreferredSizeWidget? appBar;

  const GradientBackgroundScaffold({
    super.key,
    required this.body,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.bodyPadding,
    this.appBar,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: GradientBackgroundContainer(
        padding: bodyPadding,
        child: body,
      ),
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
    );
  }
}
