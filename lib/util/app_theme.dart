import 'package:flutter/material.dart';

ThemeData lightTheme() {
  return ThemeData(
    brightness: Brightness.light,
    primarySwatch: Colors.blue,
    appBarTheme: AppBarTheme(
      titleTextStyle: const TextStyle(
        color: Colors.black87,
      ),
      // ignore: deprecated_member_use
      backgroundColor: Colors.white.withOpacity(0.95),
      elevation: 5.0,
      shadowColor: Colors.black12,
    ),
  );
}

ThemeData darkTheme() {
  return ThemeData(
    brightness: Brightness.dark,
    primarySwatch: Colors.grey,
    appBarTheme: const AppBarTheme(
      titleTextStyle: TextStyle(
        color: Colors.white,
      ),
      iconTheme: IconThemeData(
        color: Colors.white,
      ),
    ),
  );
}
