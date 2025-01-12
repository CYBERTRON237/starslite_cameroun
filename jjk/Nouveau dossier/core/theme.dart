import 'package:flutter/material.dart';

ThemeData customTheme() {
  return ThemeData(
    primarySwatch: Colors.green,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    textTheme: TextTheme(
      bodyLarge: TextStyle(color: Colors.black),  // Changement de `bodyText1` en `bodyLarge`
      bodyMedium: TextStyle(color: Colors.black54),  // Changement de `bodyText2` en `bodyMedium`
      titleLarge: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),  // Changement de `headline6` en `titleLarge`
    ),
  );
}
