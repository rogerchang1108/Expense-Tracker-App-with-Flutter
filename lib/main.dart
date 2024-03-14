import 'package:flutter/material.dart';
import 'color_schemes.g.dart';

import 'package:test_dart/widgets/expenses.dart';

void main() {
  runApp(
    MaterialApp(
      darkTheme: ThemeData.dark().copyWith(
        colorScheme: darkColorScheme,
        cardTheme: const CardTheme().copyWith(
          color: darkColorScheme.secondaryContainer,
          margin: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: darkColorScheme.primaryContainer,
            foregroundColor: darkColorScheme.onPrimaryContainer,
          ),
        ),
      ),
      theme: ThemeData().copyWith(
        colorScheme: lightColorScheme,
        appBarTheme: const AppBarTheme().copyWith(
          backgroundColor: lightColorScheme.onPrimaryContainer,
          foregroundColor: lightColorScheme.primaryContainer,
        ),
        cardTheme: const CardTheme().copyWith(
          color: lightColorScheme.secondaryContainer,
          margin: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: lightColorScheme.primaryContainer,
          ),
        ),
        textTheme: ThemeData().textTheme.copyWith(
              titleLarge: TextStyle(
                fontWeight: FontWeight.bold,
                color: lightColorScheme.onSecondaryContainer,
                fontSize: 16,
              ),
            ),
      ),
      // themeMode: ThemeMode.system, // default
      home: const Expenses(),
    ),
  );
}
