import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppTextTheme {
  AppTextTheme._(); // Private constructor

  // Font Family
  static const String _fontFamily = 'Inter';

  // Light Text Theme
  static const TextTheme lightTextTheme = TextTheme(
    // Title styles
    titleLarge: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: AppColors.textPrimaryLight,
      height: 1.3,
      fontFamily: _fontFamily,
    ),
    titleMedium: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: AppColors.textSecondaryLight,
      height: 1.4,
      fontFamily: _fontFamily,
    ),
    titleSmall: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: AppColors.textTertiaryLight,
      height: 1.4,
      fontFamily: _fontFamily,
    ),

    // Body styles
    bodyLarge: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.normal,
      color: AppColors.textSecondaryLight,
      height: 1.5,
      fontFamily: _fontFamily,
    ),
    bodyMedium: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.normal,
      color: AppColors.textTertiaryLight,
      height: 1.5,
      fontFamily: _fontFamily,
    ),
    bodySmall: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.normal,
      color: AppColors.hintTextLight,
      height: 1.4,
      fontFamily: _fontFamily,
    ),
  );

  // Dark Text Theme
  static const TextTheme darkTextTheme = TextTheme(
    // Title styles
    titleLarge: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: AppColors.textPrimaryDark,
      height: 1.3,
      fontFamily: _fontFamily,
    ),
    titleMedium: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: AppColors.textSecondaryDark,
      height: 1.4,
      fontFamily: _fontFamily,
    ),
    titleSmall: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: AppColors.textTertiaryDark,
      height: 1.4,
      fontFamily: _fontFamily,
    ),

    // Body styles
    bodyLarge: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.normal,
      color: AppColors.textSecondaryDark,
      height: 1.5,
      fontFamily: _fontFamily,
    ),
    bodyMedium: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.normal,
      color: AppColors.textTertiaryDark,
      height: 1.5,
      fontFamily: _fontFamily,
    ),
    bodySmall: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.normal,
      color: AppColors.hintTextDark,
      height: 1.4,
      fontFamily: _fontFamily,
    ),
  );

  // Custom button text style
  static const TextStyle buttonText = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Colors.white,
    fontFamily: _fontFamily,
  );
}
