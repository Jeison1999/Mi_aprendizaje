import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  static final ThemeProvider _instance = ThemeProvider._internal();
  factory ThemeProvider() => _instance;
  ThemeProvider._internal();

  final ValueNotifier<ThemeMode> _themeMode = ValueNotifier<ThemeMode>(
    ThemeMode.system,
  );

  ThemeMode get themeMode => _themeMode.value;

  void setThemeMode(ThemeMode mode) {
    _themeMode.value = mode;
    notifyListeners();
  }

  void toggleTheme() {
    switch (_themeMode.value) {
      case ThemeMode.light:
        _themeMode.value = ThemeMode.dark;
        break;
      case ThemeMode.dark:
        _themeMode.value = ThemeMode.system;
        break;
      case ThemeMode.system:
        _themeMode.value = ThemeMode.light;
        break;
    }
    notifyListeners();
  }

  String getThemeModeName() {
    switch (_themeMode.value) {
      case ThemeMode.light:
        return 'Claro';
      case ThemeMode.dark:
        return 'Oscuro';
      case ThemeMode.system:
        return 'Automático';
    }
  }
}
