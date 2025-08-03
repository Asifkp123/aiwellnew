import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Custom image view widget that handles both SVG and regular images
class CustomImageView extends StatelessWidget {
  final String? imagePath;
  final double? height;
  final double? width;
  final Color? color;
  final BoxFit fit;
  final EdgeInsets? margin;
  final EdgeInsets? padding;
  final Alignment alignment;

  const CustomImageView({
    Key? key,
    this.imagePath,
    this.height,
    this.width,
    this.color,
    this.fit = BoxFit.contain,
    this.margin,
    this.padding,
    this.alignment = Alignment.center,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      margin: margin,
      padding: padding,
      alignment: alignment,
      child: _buildImageWidget(),
    );
  }

  Widget _buildImageWidget() {
    if (imagePath == null || imagePath!.isEmpty) {
      return const SizedBox();
    }

    // Check if it's an SVG file
    if (imagePath!.toLowerCase().endsWith('.svg')) {
      return SvgPicture.asset(
        imagePath!,
        height: height,
        width: width,
        fit: fit,
        colorFilter: color != null 
          ? ColorFilter.mode(color!, BlendMode.srcIn)
          : null,
      );
    }

    // Handle regular images
    return Image.asset(
      imagePath!,
      height: height,
      width: width,
      fit: fit,
      color: color,
    );
  }
}