import 'package:flutter/material.dart';

/// Central class for defining the 'Track N Stack' visual style.
/// 
/// We use a custom ThemeData class to ensure that any new screen 
/// we add automatically looks "gamified" and consistent.
class AppTheme {
  // --- Gamified Color Palette (Updated: No Black, Brown Background) ---
  
  // A vibrant, growth-inspired green as our primary focus.
  static const Color primaryColor = Color(0xFF00693E); 
  
  // High-contrast dark brown surfaces for depth and focus.
  static const Color secondaryColor = Color(0xFF2D241F); 
  
  // Bright yellow for XP, rewards, and "win" states.
  static const Color accentColor = Color(0xFFFFD700); 
  
  // Deep brown background instead of black.
  static const Color backgroundColor = Color(0xFF1B1411); 
  
  // Surface color for cards and secondary UI elements (Warmer brown).
  static const Color surfaceColor = Color(0xFF3E322B); 
  
  // Used for alert states, budget deficits, or negative streaks.
  static const Color errorColor = Color(0xFFCF6679); 

  // A very dark brown to replace absolute black in text/icons.
  static const Color darkestBrown = Color(0xFF0E0A08);
  
  /// The global dark theme configuration for the application.
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      // Define the core color mapping for the entire Flutter engine.
      colorScheme: const ColorScheme.dark(
        primary: primaryColor,
        onPrimary: darkestBrown, // Dark brown text on light green primary.
        secondary: accentColor,
        onSecondary: darkestBrown,
        surface: surfaceColor,
        onSurface: Colors.white,
        error: errorColor,
      ),
      scaffoldBackgroundColor: backgroundColor,
      
      // --- Global Widget Styles ---
      
      // AppBars should be subtle, allowing the content to be the focus.
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
      
      // Cards are used for "Summary Cards" (Milestone 1, Requirement 6).
      cardTheme: CardThemeData(
        color: surfaceColor,
        elevation: 8,
        shadowColor: primaryColor.withValues(alpha: 0.2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: primaryColor.withValues(alpha: 0.1), width: 1),
        ),
      ),
      
      // Custom styling for primary actions (Sign Up, Log Transaction).
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: darkestBrown,
          minimumSize: const Size(double.infinity, 56), // Large touch target.
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30), // Extra rounded "gaming" feel.
          ),
          textStyle: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.1,
          ),
          elevation: 4,
        ),
      ),
      
      // --- Custom TextTheme ---
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
      
      // --- Input Decoration (Forms) ---
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
          borderSide: BorderSide(color: primaryColor.withValues(alpha: 0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
      ),
    );
  }
}
