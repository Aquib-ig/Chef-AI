import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  ThemeCubit() : super(ThemeMode.system);

  // Toggle between light and dark theme
  void toggleTheme() {
    final newTheme = state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    emit(newTheme);
  }

  // Set specific theme
  void setTheme(ThemeMode themeMode) {
    emit(themeMode);
  }

  // Get current theme as boolean for switches
  bool get isDarkMode => state == ThemeMode.dark;
  
  // Get current theme as boolean considering system theme
  bool isDarkModeActive(BuildContext context) {
    if (state == ThemeMode.system) {
      return MediaQuery.of(context).platformBrightness == Brightness.dark;
    }
    return state == ThemeMode.dark;
  }
}
