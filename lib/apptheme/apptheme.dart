import 'package:flutter/material.dart';

import '../constants.dart';

enum AppTheme {
  dark,
  light,
}


class AppThemes {
  static final ThemeData dark = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColor.darkBgColor,// BG Color
    primaryColor: AppColor.darkPriBtnColor,// PRIMARY BTN Color
    secondaryHeaderColor: AppColor.darkChatWidgetBgColor,// ChatWidgetBg Color
    fontFamily: 'Inter',
    cardColor: AppColor.darkCardColor,//CARD COLOR
    colorScheme: const ColorScheme.dark(
      primary: AppColor.darkAccentColor,// Accent Color
      secondary: AppColor.darkTextColor,// Text Color
    ),
  );

  static final ThemeData light = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColor.lightBgColor,
    primaryColor: AppColor.lightPriBtnColor,
    secondaryHeaderColor: AppColor.lightChatWidgetBgColor,
    fontFamily: 'Inter',
    cardColor: AppColor.lightCardColor,
    colorScheme: const ColorScheme.light(
      primary: AppColor.lightAccentColor,
      secondary: AppColor.lightTextColor,
    ),
  );

}
