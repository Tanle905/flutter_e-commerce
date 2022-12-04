import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tmdt/constants/constants.dart';

ThemeData lightTheme() {
  return ThemeData(
      cardColor: COLOR_BACKGROUND,
      cardTheme: CardTheme(
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: const BorderSide(color: COLOR_SHADOW))),
      canvasColor: COLOR_BACKGROUND,
      inputDecorationTheme:
          InputDecorationTheme(fillColor: Colors.grey.shade300),
      backgroundColor: COLOR_BACKGROUND,
      // drawerTheme: DrawerThemeData(backgroundColor: Colors.grey.shade700),
      textTheme: TextTheme(
          labelLarge: const TextStyle(
              color: COLOR_BUTTON_AND_LINK_TEXT,
              fontWeight: FontWeight.bold,
              fontSize: 15),
          headlineLarge: TextStyle(
              color: COLOR_TEXT_AND_ICON,
              fontWeight: FontWeight.bold,
              fontSize: 50),
          headlineMedium: TextStyle(
            color: COLOR_TEXT_AND_ICON,
            fontWeight: FontWeight.bold,
          ),
          headlineSmall: TextStyle(
            color: COLOR_TEXT_AND_ICON,
            fontWeight: FontWeight.w900,
          ),
          titleLarge: TextStyle(
              color: COLOR_TEXT_AND_ICON, fontWeight: FontWeight.bold),
          titleMedium: TextStyle(
              color: COLOR_TEXT_AND_ICON, fontWeight: FontWeight.bold),
          titleSmall: TextStyle(color: COLOR_TEXT_AND_ICON),
          bodyMedium: TextStyle(color: COLOR_TEXT_BODY)),
      iconTheme: IconThemeData(color: COLOR_TEXT_AND_ICON, size: 25),
      appBarTheme: AppBarTheme(backgroundColor: COLOR_BACKGROUND, elevation: 0),
      fontFamily: 'Lato',
      brightness: Brightness.light,
      primaryColor: COLOR_BACKGROUND,
      colorScheme: ColorScheme.fromSwatch().copyWith(
          secondary: COLOR_BACKGROUND_ACCENT, brightness: Brightness.light),
      shadowColor: COLOR_SHADOW,
      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
              primary: COLOR_BUTTON_AND_LINK_TEXT,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)))));
}

ThemeData darkTheme() {
  return ThemeData(
      cardColor: COLOR_BACKGROUND_DARK,
      cardTheme: CardTheme(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: BorderSide(color: COLOR_SHADOW_DARK))),
      canvasColor: COLOR_BACKGROUND_DARK,
      inputDecorationTheme:
          InputDecorationTheme(fillColor: Colors.grey.shade800),
      backgroundColor: COLOR_BACKGROUND_DARK,
      // drawerTheme: DrawerThemeData(backgroundColor: Colors.grey.shade700),
      textTheme: TextTheme(
          labelLarge: const TextStyle(
              color: COLOR_BUTTON_AND_LINK_TEXT,
              fontWeight: FontWeight.bold,
              fontSize: 15),
          headlineLarge: TextStyle(
              color: COLOR_TEXT_AND_ICON_DARK,
              fontWeight: FontWeight.bold,
              fontSize: 50),
          headlineSmall: TextStyle(
              color: COLOR_TEXT_AND_ICON_DARK, fontWeight: FontWeight.w900),
          titleSmall: TextStyle(color: COLOR_TEXT_AND_ICON_DARK),
          titleLarge: TextStyle(
              color: COLOR_TEXT_AND_ICON_DARK, fontWeight: FontWeight.bold),
          titleMedium: TextStyle(color: COLOR_TEXT_AND_ICON_DARK),
          bodyMedium: TextStyle(color: COLOR_TEXT_BODY_DARK)),
      iconTheme: IconThemeData(color: COLOR_TEXT_AND_ICON_DARK, size: 25),
      appBarTheme: const AppBarTheme(
          backgroundColor: COLOR_BACKGROUND_DARK, elevation: 0),
      fontFamily: 'Lato',
      brightness: Brightness.dark,
      primaryColor: COLOR_BACKGROUND_DARK,
      colorScheme: ColorScheme.fromSwatch().copyWith(
          secondary: COLOR_BACKGROUND_ACCENT_DARK, brightness: Brightness.dark),
      shadowColor: COLOR_SHADOW_DARK,
      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
              primary: COLOR_BUTTON_AND_LINK_TEXT_DARK,
              disabledBackgroundColor: Colors.grey)));
}

ThemeMode themeMode() {
  return ThemeMode.system;
}

final myLightSystemTheme = SystemUiOverlayStyle.light.copyWith(
    statusBarColor: COLOR_BACKGROUND,
    statusBarBrightness: Brightness.dark,
    systemNavigationBarColor: COLOR_BACKGROUND,
    systemNavigationBarIconBrightness: Brightness.dark);
final myDarkSystemTheme = SystemUiOverlayStyle.light.copyWith(
    statusBarColor: COLOR_BACKGROUND_DARK,
    statusBarBrightness: Brightness.light,
    systemNavigationBarColor: COLOR_BACKGROUND_DARK,
    systemNavigationBarIconBrightness: Brightness.light);
