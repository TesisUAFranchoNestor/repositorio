import 'package:flutter/material.dart';

class AppTheme {
  final colorSeed = const Color(0xff44d62c);
  final bool isDarkMode;

  AppTheme({this.isDarkMode = false});

  ThemeData getTheme() => ThemeData(

      ///* General
      useMaterial3: true,
      colorSchemeSeed: colorSeed,
      brightness: isDarkMode ? Brightness.dark : Brightness.light);

  AppTheme copyWith({bool? isDarkMode}) =>
      AppTheme(isDarkMode: isDarkMode ?? this.isDarkMode);
}

TextStyle titleTextStyle =
    const TextStyle(fontSize: 18, fontWeight: FontWeight.w500);

TextStyle greetingTextStyle =
    const TextStyle(fontSize: 24, fontWeight: FontWeight.w700);

TextStyle subTitleTextStyle =
    const TextStyle(fontSize: 16, fontWeight: FontWeight.w500);

TextStyle subTitleTextStyleDark =
    const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black54);

TextStyle addressTextStyle = const TextStyle(
    fontSize: 14, fontWeight: FontWeight.w400, color: Color(0xFF188906));

TextStyle addressTextStyle2 = const TextStyle(
    fontSize: 14, fontWeight: FontWeight.w400);

TextStyle addressTextStyleBlack = const TextStyle(
    fontSize: 14, fontWeight: FontWeight.w400, color: Colors.black);

TextStyle priceTextStyle = const TextStyle(
    fontSize: 16, fontWeight: FontWeight.w400, color: Color(0xFF188906));


TextStyle descTextStyle =
    const TextStyle(fontSize: 14, fontWeight: FontWeight.w400);

TextStyle normalTextStyle = const TextStyle(color: Color(0xFF188906));


TextStyle tabBarTextStyle = const TextStyle(fontWeight: FontWeight.w500, color: Color(0xFF188906));

TextStyle buttonTextStyle = const TextStyle(
    fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white);