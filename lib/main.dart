import 'package:baby_tracker/themes/my_app_themes.dart';
import 'package:baby_tracker/ui/home_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Baby Tracker',
      theme: MyAppThemes.lightTheme,
      darkTheme: MyAppThemes.darkTheme,
      themeMode: ThemeMode.system,
      home: const HomePage(),
    );
  }
}
