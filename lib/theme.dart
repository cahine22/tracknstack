import 'package:flutter/material.dart';

class AppTheme {
  // Gamified Color Palette - Prompt 2 Refinement
  static const Color primaryColor = Color(0xFF50C878); // Emerald Green (Action/Growth)
  static const Color secondaryColor = Color(0xFF1A1A1A); // High-Contrast Dark (Depth)
  static const Color accentColor = Color(0xFFFFD700); // Gold (XP/Rewards)
  static const Color backgroundColor = Color(0xFF0D0D0D); // Deep Black
  static const Color surfaceColor = Color(0xFF1E1E1E); // Elevated Surface
  static const Color errorColor = Color(0xFFCF6679); // Soft Red
  
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: primaryColor,
        onPrimary: Colors.black,
        secondary: accentColor,
        onSecondary: Colors.black,
        surface: surfaceColor,
        onSurface: Colors.white,
        error: errorColor,
      ),
      scaffoldBackgroundColor: backgroundColor,
      appBarTheme: const AppBarTheme(
        backgroundColor: backgroundColor,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: primaryColor,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
      cardTheme: CardThemeData(
        color: surfaceColor,
        elevation: 8,
        shadowColor: primaryColor.withOpacity(0.2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: primaryColor.withOpacity(0.1), width: 1),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.black,
          minimumSize: const Size(double.infinity, 56),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30), // Extra rounded for gamified feel
          ),
          textStyle: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.1,
          ),
          elevation: 4,
        ),
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.w900,
          color: primaryColor,
          letterSpacing: -1.0,
        ),
        headlineMedium: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white,
          fontSize: 24,
        ),
        titleLarge: TextStyle(
          fontWeight: FontWeight.w600,
          color: primaryColor,
          fontSize: 20,
        ),
        bodyLarge: TextStyle(
          color: Colors.white,
          fontSize: 16,
          height: 1.5,
        ),
        bodyMedium: TextStyle(
          color: Colors.white70,
          fontSize: 14,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: secondaryColor,
        labelStyle: const TextStyle(color: Colors.white70),
        hintStyle: const TextStyle(color: Colors.white38),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: primaryColor.withOpacity(0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
      ),
    );
  }
}
