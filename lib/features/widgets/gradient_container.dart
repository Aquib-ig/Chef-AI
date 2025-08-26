import 'package:chef_ai/core/themes/app_colors.dart';
import 'package:flutter/material.dart';

class GradientContainer extends StatelessWidget {
  final Widget child;
  final bool isDark;

  const GradientContainer({
    super.key,
    required this.child,
    this.isDark = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? AppColors.darkWarmGradient
              : AppColors.lightWarmGradient,
        ),
      ),
      child: child,
    );
  }
}
