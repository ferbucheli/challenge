// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

Color get shimmerBaseColor => const Color.fromARGB(255, 225, 225, 225);

Color get shimmerHighlightColor => Colors.grey.shade100;

Color get shimmerContentColor => Colors.white.withOpacity(0.85);

class CustomShimmer extends StatelessWidget {
  final double? height;
  final double? width;
  final double? borderRadius;
  final EdgeInsetsGeometry? margin;
  const CustomShimmer(
      {Key? key, this.height, this.width, this.borderRadius, this.margin})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: shimmerBaseColor,
      highlightColor: shimmerHighlightColor,
      child: Container(
        width: width,
        margin: margin,
        height: height ?? 10,
        decoration: BoxDecoration(
            color: shimmerContentColor,
            borderRadius: BorderRadius.circular(borderRadius ?? 10)),
      ),
    );
  }
}
