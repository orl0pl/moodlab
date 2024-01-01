import 'package:flutter/material.dart';



const MaterialColor srcCol = Colors.lightGreen;

final ColorScheme defaultLightColorScheme = ColorScheme.fromSeed(seedColor: srcCol);

final ColorScheme defaultDarkColorScheme = ColorScheme.fromSeed(seedColor: srcCol, brightness: Brightness.dark);

final ThemeData lightTheme = ThemeData.from(colorScheme: defaultLightColorScheme, useMaterial3: true);

final ThemeData darkTheme = ThemeData.from(colorScheme: defaultDarkColorScheme, useMaterial3: true);
