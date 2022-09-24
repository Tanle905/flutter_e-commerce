import 'package:flutter/material.dart';
import 'package:tmdt/constants/constants.dart';

ThemeData lightTheme() {
  return ThemeData(
      inputDecorationTheme:
          InputDecorationTheme(fillColor: Colors.grey.shade300),
      backgroundColor: COLOR_BACKGROUND,
      // drawerTheme: DrawerThemeData(backgroundColor: Colors.grey.shade700),
      textTheme: TextTheme(
          titleSmall: TextStyle(color: COLOR_TEXT_AND_ICON),
          titleLarge: TextStyle(
              color: COLOR_TEXT_AND_ICON, fontWeight: FontWeight.bold),
          titleMedium: TextStyle(color: COLOR_TEXT_AND_ICON)),
      iconTheme: IconThemeData(color: COLOR_TEXT_AND_ICON, size: 25),
      appBarTheme: AppBarTheme(backgroundColor: COLOR_BACKGROUND, elevation: 0),
      fontFamily: 'Lato',
      brightness: Brightness.light,
      primaryColor: COLOR_BACKGROUND,
      colorScheme: ColorScheme.fromSwatch().copyWith(
          secondary: COLOR_BACKGROUND_ACCENT, brightness: Brightness.light),
      shadowColor: COLOR_SHADOW,
      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(primary: COLOR_TEXT_AND_ICON)));
}

ThemeData darkTheme() {
  return ThemeData(
      inputDecorationTheme:
          InputDecorationTheme(fillColor: Colors.grey.shade800),
      backgroundColor: COLOR_BACKGROUND_DARK,
      // drawerTheme: DrawerThemeData(backgroundColor: Colors.grey.shade700),
      textTheme: TextTheme(
          titleSmall: TextStyle(color: COLOR_TEXT_AND_ICON_DARK),
          titleLarge: TextStyle(
              color: COLOR_TEXT_AND_ICON_DARK, fontWeight: FontWeight.bold),
          titleMedium: TextStyle(color: COLOR_TEXT_AND_ICON_DARK)),
      iconTheme: IconThemeData(color: COLOR_TEXT_AND_ICON_DARK, size: 25),
      appBarTheme:
          AppBarTheme(backgroundColor: COLOR_BACKGROUND_DARK, elevation: 0),
      fontFamily: 'Lato',
      brightness: Brightness.dark,
      primaryColor: COLOR_BACKGROUND_DARK,
      colorScheme: ColorScheme.fromSwatch().copyWith(
          secondary: COLOR_BACKGROUND_ACCENT_DARK, brightness: Brightness.dark),
      shadowColor: COLOR_SHADOW_DARK,
      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(primary: COLOR_TEXT_AND_ICON_DARK)));
}

ThemeMode themeMode() {
  return ThemeMode.light;
}
