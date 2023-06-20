import 'package:flutter/material.dart';

class SizeConfig {
  static MediaQueryData? _mediaQueryData;
  static double? screenWidth;
  static double? screenHeight;
  static double? defaultSize;
  static Orientation? orientation;

  void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData!.size.width;
    screenHeight = _mediaQueryData!.size.height;
    orientation = _mediaQueryData!.orientation;
  }
}

double getProportionateScreenHeightMain(double inputHeight) {
  double? screenHeight = SizeConfig.screenHeight;
  // 812 is the layout height that designer use
  return (inputHeight / 812.0) * screenHeight!;
}

double getProportionateScreenWidthMain(double inputWidth) {
  double? screenWidth = SizeConfig.screenWidth;
  // 375 is the layout width that designer use
  return (inputWidth / 375.0) * screenWidth!;
}

double getProportionalFontSizeMain(int fontsize){
  double finalFontSize = fontsize.toDouble();
  double? screenWidth = SizeConfig.screenWidth;
  finalFontSize = (finalFontSize * screenWidth!) / 375.0;
  return finalFontSize;
}

// Get the proportionate height as per screen size
double getProportionateScreenHeight(double inputHeight) {
  return inputHeight;
  double? screenHeight = SizeConfig.screenHeight;
  // 812 is the layout height that designer use
  return (inputHeight / 812.0) * screenHeight!;
}

// Get the proportionate height as per screen size
double getProportionateScreenWidth(double inputWidth) {
  return inputWidth;
  double? screenWidth = SizeConfig.screenWidth;
  // 375 is the layout width that designer use
  return (inputWidth / 375.0) * screenWidth!;
}

double getProportionalFontSize(int fontsize){
  return fontsize.toDouble();
  double finalFontSize = fontsize.toDouble();
  double? screenWidth = SizeConfig.screenWidth;
  finalFontSize = (finalFontSize * screenWidth!) / 375.0;
  return finalFontSize;
}
