import 'package:flutter/material.dart';

class MyAppThemes {
  static final lightTheme = ThemeData(
    useMaterial3: true,
    primaryColor: Colors.lightBlue,
    brightness: Brightness.light,
  );

  static final darkTheme = ThemeData(
    useMaterial3: true,
    primaryColor: Colors.blue,
    brightness: Brightness.dark,
  );
}