import 'package:flutter/material.dart';

/// Espaçamentos padrão do app (8 / 16 / 24).
class Espaco {
  static const double p = 8;
  static const double m = 16;
  static const double g = 24;
}

/// Identidade visual única: azul GuardaRio, cards com raio 12.
class AppTheme {
  static const Color azul = Color(0xFF1F7AB8);
  static const Color fundo = Color(0xFFF4F7FA);

  static ThemeData get tema {
    final raio = BorderRadius.circular(12);
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(seedColor: azul, primary: azul),
      scaffoldBackgroundColor: fundo,
      appBarTheme: const AppBarTheme(
        backgroundColor: azul,
        foregroundColor: Colors.white,
      ),
      cardTheme: CardThemeData(
        elevation: 1,
        margin: EdgeInsets.zero,
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: raio),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: raio),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(64, 48),
          shape: RoundedRectangleBorder(borderRadius: raio),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(64, 48),
          shape: RoundedRectangleBorder(borderRadius: raio),
        ),
      ),
    );
  }
}
