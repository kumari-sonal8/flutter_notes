import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = false;

  // Getter to expose current theme mode
  bool  getThemeValue() => _isDarkMode;

  // Toggle method to switch theme
  /*void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }*/

  // Optional: Direct method to update theme
  void updateTheme({required bool value}) {
    _isDarkMode = value;
    notifyListeners();
  }
}

