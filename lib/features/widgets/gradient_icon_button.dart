import 'package:chef_ai/core/themes/app_colors.dart';
import 'package:flutter/material.dart';

class GradientIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final bool isDark;
  final double size;

  const GradientIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.isDark = false,
    this.size = 24,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: LinearGradient(
          colors: isDark
              ? AppColors.buttonDarkGradient
              : AppColors.buttonLightGradient,
        ),
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon, color: Colors.white, size: size),
      ),
    );
  }
}
