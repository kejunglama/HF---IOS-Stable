import 'package:flutter/material.dart';

class SizeConfig {
  static MediaQueryData _mediaQueryData;
  static double screenWidth;
  static double screenHeight;
  static double screenViewPadding;
  static double defaultSize;
  static Orientation orientation;

  void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    screenViewPadding = _mediaQueryData.viewPadding.top;
    orientation = _mediaQueryData.orientation;
  }
}

num breakHeight = 700;
// Get the proportionate height as per screen size
double getProportionateScreenHeight(double inputHeight) {
  double screenHeight = SizeConfig.screenHeight;
  // 812 is the layout height that designer use
  return screenHeight > breakHeight ? (inputHeight / 812.0) * screenHeight : inputHeight;
}

// Get the proportionate height as per screen size
double getProportionateScreenWidth(double inputWidth) {
  double screenWidth = SizeConfig.screenWidth;
  // 375 is the layout width that designer use
  return (inputWidth / 375.0) * screenWidth;
}

Widget sizedBoxOfHeight(double inputHeight) {
  return SizedBox(
    height: getProportionateScreenHeight(inputHeight),
  );
}

Widget sizedBoxOfWidth(double inputWidth) {
  return SizedBox(
    width: getProportionateScreenWidth(inputWidth),
  );
}
