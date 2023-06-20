import 'package:flutter/material.dart';

import 'Helper.dart';

abstract class ThemeMixin {
  static ThemeData getTheme(BuildContext context) {
    final backgroundColor = Helper.hexToColor("#ffffff");
    final primaryColor = Helper.hexToColor("#5BAEE2");
    return ThemeData(
      backgroundColor: backgroundColor,
      primaryColor: primaryColor,
    );
  }
}
