import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  bool isDarkMode = false;


  static const Color lightThemeColor = Colors.white;
  static const Color darkThemeColor = Color(0xFF212121);
  static const Color lightTextColor = Colors.black;
  static const Color darkTextColor = Colors.white;

  Color get themeColor => isDarkMode ? darkThemeColor : lightThemeColor;
  Color get textColor => isDarkMode ? darkTextColor : lightTextColor;

  void toggleTheme() {
    isDarkMode = !isDarkMode;
    notifyListeners();
  }
}
