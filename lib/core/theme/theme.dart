import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static const Color green = const Color.fromARGB(255, 86, 190, 89);
  static const Color lightGreen = Color.fromARGB(255, 232, 242, 236);
  static const Color darkGreen = Color.fromARGB(255, 61, 107, 82);
  static const Color darkGrey = Color.fromARGB(255, 74, 85, 104);
  static const Color dark = Color.fromARGB(255, 26, 32, 44);
  static const Color white = Color.fromARGB(255, 247, 249, 248);
  static const Color lightGrey = Color.fromARGB(255, 237, 242, 239);
  static const Color grey = Color.fromARGB(255, 154, 173, 163);
  static const Color error = Color.fromARGB(255, 229, 115, 115);
  static const Color yellow = Color.fromARGB(255, 246, 166, 35);
  static const Color blue = Color.fromARGB(255, 102, 179, 241);
  static const Color shinnyGreen = Color(0xFF66BB6A);
  static const Color shinnyOrange = Color(0xFFFFA726);
  static const Color shinnyRed = Color(0xFFEF5350);
  static ThemeData get light => ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: white,
    colorScheme: ColorScheme.fromSeed(
      seedColor: green,
      brightness: Brightness.light,
    ),
    fontFamily: 'Lato',
    appBarTheme: const AppBarTheme(
      backgroundColor: white,
      foregroundColor: dark,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontFamily: 'Lato',
        fontSize: 17,
        fontWeight: FontWeight.w600,
        color: dark,
        letterSpacing: 0.2,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(26),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(26),
        borderSide: BorderSide(color: Colors.grey.shade200),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(26),
        borderSide: const BorderSide(color: green, width: 1.5),
      ),
      hintStyle: const TextStyle(color: grey, fontSize: 15),
    ),
  );
}
