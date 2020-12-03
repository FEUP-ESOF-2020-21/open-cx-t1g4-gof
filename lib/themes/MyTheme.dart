import 'package:flutter/material.dart';

class MyTheme with ChangeNotifier {
  static bool _isLight = false;

  static bool get isLight => _isLight;

  static bool get isDark => !_isLight;

  static ThemeMode currentThemeMode() {
    return _isLight ? ThemeMode.light : ThemeMode.dark;
  }

  void switchTheme(bool value) {
    _isLight = value;
    notifyListeners();
  }

  static ThemeData get theme => isLight ? lightTheme : darkTheme;

  static final ThemeData darkTheme = ThemeData(
    // accentColor: Color.fromRGBO(255, 153, 204, 1),
    backgroundColor: Colors.grey[700],
    accentColor: Colors.deepPurpleAccent,
    brightness: Brightness.dark,
    primaryColor: Colors.deepPurple,
    cardColor: Colors.grey[800],
  );

  static final ThemeData lightTheme = ThemeData(
    accentColor: Color.fromRGBO(25, 30, 60, 1),
    brightness: Brightness.light,
    primaryColor: Color.fromRGBO(2, 62, 160, 1),
  );
}
