import 'package:flutter/material.dart';

class IncasurTheme {
  static const Color azulProfundo = Color(0xFF0E6481);
  static const Color azulOscuro = Color(0xFF0A4D63);
  static const Color amarillo = Color(0xFFEAEA00);
  static const Color verdeAndino = Color(0xFF2E7D32);
  static const Color dorado = Color(0xFFD4A843);
  static const Color blanco = Color(0xFFF5F5F5);
  static const Color grisClaro = Color(0xFFE0E0E0);
  static const Color rojo = Color(0xFFC62828);

  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: azulProfundo,
      colorScheme: ColorScheme.light(
        primary: azulProfundo,
        secondary: amarillo,
        tertiary: dorado,
      ),
      scaffoldBackgroundColor: blanco,
      appBarTheme: const AppBarTheme(
        backgroundColor: azulProfundo,
        foregroundColor: Colors.white,
        elevation: 2,
        centerTitle: true,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: azulProfundo,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 4,
          shadowColor: azulProfundo.withAlpha(100),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: amarillo, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      cardTheme: CardThemeData(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        shadowColor: Colors.black.withAlpha(30),
      ),
    );
  }
}
