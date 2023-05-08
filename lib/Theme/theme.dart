import 'package:flutter/material.dart';

CustomTheme currentTheme = CustomTheme();

class CustomTheme with ChangeNotifier {
  static bool isDarkTheme = false;

  ThemeMode get currentTheme => isDarkTheme ? ThemeMode.dark : ThemeMode.light;

  void toggleTheme() {
    isDarkTheme = !isDarkTheme;
    notifyListeners();
  }

  static ThemeData get lightTheme {
    return ThemeData(
        primaryColor: const Color(0xff57EE9D),
        backgroundColor: Colors.white,
        elevatedButtonTheme: ElevatedButtonThemeData(
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Color(0xff57EE9D)))),
        scaffoldBackgroundColor: Colors.white);
  }

  static ThemeData get darkTheme {
    return ThemeData(
        primaryColor: Colors.deepOrangeAccent,
        elevatedButtonTheme: ElevatedButtonThemeData(
            style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all(Colors.deepOrangeAccent))),
        backgroundColor: Colors.red,
        scaffoldBackgroundColor: Colors.grey);
  }
}
