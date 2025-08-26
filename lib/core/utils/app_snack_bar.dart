import 'package:chef_ai/core/themes/app_colors.dart';
import 'package:flutter/material.dart';

enum SnackBarType { success, error, info }

class AppSnackBar {
  static void show(
    BuildContext context, {
    required String message,
    required SnackBarType type,
  }) {
    // Dismiss any existing SnackBar
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    Color backgroundColor;

    switch (type) {
      case SnackBarType.success:
        backgroundColor = AppColors.successColor;
        break;
      case SnackBarType.error:
        backgroundColor = AppColors.errorColor;
        break;
      case SnackBarType.info:
        backgroundColor = AppColors.infoColor;
        break;
    }

    final snackBar = SnackBar(
      content: Text(message, style: const TextStyle(color: Colors.white)),
      backgroundColor: backgroundColor,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      duration: const Duration(seconds: 3),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}