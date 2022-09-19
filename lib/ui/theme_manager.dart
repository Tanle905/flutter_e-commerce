import 'package:flutter/material.dart';
import 'package:tmdt/ui/constants.dart';

ThemeData lightTheme() {
  return ThemeData(
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
      primaryColor: Colors.grey,
      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(primary: COLOR_TEXT_AND_ICON)));
}

ThemeData darkTheme() {
  return ThemeData(
    brightness: Brightness.dark,
  );
}

ThemeMode themeMode() {
  return ThemeMode.light;
}
