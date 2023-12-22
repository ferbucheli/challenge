import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';

class UiUtils {
  static SvgPicture getSvg(String path,
      {Color? color, BoxFit? fit, double? width, double? height}) {
    return SvgPicture.asset(
      path,
      color: color,
      fit: fit ?? BoxFit.contain,
      width: width,
      height: height,
    );
  }

  static Widget progress(
      {double? width,
      double? height,
      Color? normalProgressColor,
      bool? showWhite}) {
    return LottieBuilder.asset(
      "assets/lottie/loading-spinner.json",
      width: width ?? 45,
      height: height ?? 45,
    );
  }

  static Widget booksLoading(
      {double? width,
      double? height,
      Color? normalProgressColor,
      bool? showWhite}) {
    return LottieBuilder.asset(
      "assets/lottie/books_loading.json",
      width: width ?? 45,
      height: height ?? 45,
    );
  }
}
