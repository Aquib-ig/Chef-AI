import 'package:flutter/material.dart';

class AppColors {
  AppColors._(); // Private constructor

  // Primary Colors - Much softer and more appealing warm tones
  static const Color primaryLight = Color(0xFFBF7E4B); // Soft warm brown
  static const Color primaryDark = Color(0xFF8B5A3C); // Muted warm brown
  static const Color secondaryLight = Color(0xFFD4A574); // Gentle warm beige
  static const Color secondaryDark = Color(0xFFA67C5A); // Soft caramel

  // Surface Colors - Better matching to your gradients
  static const Color surfaceLight = Color(
    0xFFFFF8F5,
  ); // Your existing warm surface
  static const Color surfaceDark = Color(
    0xFF2D2418,
  ); // Darker warm brown instead of white12
  static const Color inputFillLight = Color(0xFFFFF3E0); // Your existing
  static const Color inputFillDark = Color(0xFF3E2723); // Your existing

  // Text Colors - Better contrast and appeal
  static const Color textPrimaryLight = Color(0xFF3E2723); // Your existing
  static const Color textSecondaryLight = Color(0xFF5D4037); // Your existing
  static const Color textTertiaryLight = Color(0xFF6D4C41); // Your existing
  static const Color hintTextLight = Color(0xFF8D6E63); // Your existing

  static const Color textPrimaryDark = Color(0xFFFFF8F0); // Warmer white
  static const Color textSecondaryDark = Color(0xFFE8D5C4); // Soft warm beige
  static const Color textTertiaryDark = Color(0xFFD4B896); // Gentle tan
  static const Color hintTextDark = Color(0xFFA1896F); // Muted brown

  // Border Colors - Softer and more harmonious
  static const Color borderLight = Color(0xFFE8D5C4); // Soft beige border
  static const Color borderDark = Color(0xFF4A3429); // Warm dark brown

  // Gradient Colors - Your existing beautiful gradients
  static const List<Color> lightWarmGradient = [
    Color(0xFFFFF3E0), // Your original light peach
    Color(0xFFFFE0B2), // Your original light orange
  ];

  static const List<Color> darkWarmGradient = [
    Color(0xFF3E2723), // Your original dark brown
    Color(0xFF5D4037), // Your original medium brown
  ];

  // Button gradients - Much softer and appealing
  static const List<Color> buttonLightGradient = [
    Color(0xFFBF7E4B), // Soft warm brown
    Color(0xFFD4A574), // Gentle warm beige
  ];

  static const List<Color> buttonDarkGradient = [
    Color(0xFF8B5A3C), // Muted warm brown
    Color(0xFFA67C5A), // Soft caramel
  ];

  // Additional accent colors for better variety
  static const Color accentLight = Color(0xFFF4E4BC); // Very light cream
  static const Color accentDark = Color(0xFF6B4E3D); // Rich cocoa

  //App Snackbar colors
  static const Color successColor = Colors.green; 
  static const Color infoColor = Colors.blue; 
  static const Color errorColor = Colors.red; 



  // Color Schemes - Updated with new softer colors
  static const ColorScheme lightColorScheme = ColorScheme.light(
    primary: primaryLight,
    secondary: secondaryLight,
    surface: surfaceLight,
    onPrimary: Colors.white,
    onSecondary: textPrimaryLight,
    onSurface: textPrimaryLight,
    tertiary: accentLight, // Added tertiary color
  );

  static const ColorScheme darkColorScheme = ColorScheme.dark(
    primary: primaryDark,
    secondary: secondaryDark,
    surface: surfaceDark,
    onPrimary: Colors.white,
    onSecondary: Colors.white,
    onSurface: textPrimaryDark,
    tertiary: accentDark, // Added tertiary color
  );
}
