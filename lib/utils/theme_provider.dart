import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  bool isDarkMode = false;

  static const Color lightThemeColor = Colors.white;
  static const Color darkThemeColor = Color(0xFF212121);
  static const Color lightTextColor = Colors.black;
  static const Color darkTextColor = Colors.white;

  Color get themeColor => isDarkMode ? darkThemeColor : lightThemeColor;
  Color get textColor => isDarkMode ? darkTextColor : lightTextColor;

  ThemeProvider() {
    loadTheme(); // Load theme when app starts
  }

  void toggleTheme() async {
    isDarkMode = !isDarkMode;
    await saveTheme(isDarkMode);
    notifyListeners();
  }

  Future<void> saveTheme(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool("isDarkMode", value);
  }

  Future<void> loadTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    isDarkMode = prefs.getBool("isDarkMode") ?? false;
    notifyListeners();
  }
}