import 'package:flutter/material.dart';



const MaterialColor srcCol = Colors.blue;

final ColorScheme lightColorScheme = ColorScheme.fromSeed(seedColor: srcCol);

final ColorScheme darkColorScheme = ColorScheme.fromSeed(seedColor: srcCol, brightness: Brightness.dark);

final ThemeData lightTheme = ThemeData.from(colorScheme: lightColorScheme, useMaterial3: true);

final ThemeData darkTheme = ThemeData.from(colorScheme: darkColorScheme, useMaterial3: true);
