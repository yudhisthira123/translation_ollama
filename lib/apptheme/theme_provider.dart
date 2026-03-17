import 'package:flutter/material.dart';

import 'apptheme.dart';

class ThemeProvider extends ChangeNotifier {
  AppTheme _currentTheme = AppTheme.dark;

  AppTheme get currentTheme => _currentTheme;

  ThemeData get themeData {
    switch (_currentTheme) {
      case AppTheme.light:
        return AppThemes.light;
      case AppTheme.dark:
        return AppThemes.dark;
    }
  }

  void setTheme(AppTheme theme) {
    _currentTheme = theme;
    notifyListeners();
  }
}
