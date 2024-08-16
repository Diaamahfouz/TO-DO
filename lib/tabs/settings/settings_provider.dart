import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider with ChangeNotifier {
  static ThemeMode themeMode = ThemeMode.light;
  SharedPreferences? prefs;

  bool get isDark => themeMode == ThemeMode.dark;
  SettingsProvider() {
    loadSettings();
  }

  void loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    themeMode = prefs.getBool('isDarkMode') ?? false ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
  Future <void> changeThemeMode(ThemeMode selectedThemeMode)async {
    themeMode = selectedThemeMode;
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isDarkMode', isDark);
    notifyListeners();
  }
}
