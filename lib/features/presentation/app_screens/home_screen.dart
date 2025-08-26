import 'package:chef_ai/core/themes/app_colors.dart';
import 'package:chef_ai/features/presentation/ai_assistant_screen/ai_assistant_page.dart';
import 'package:chef_ai/features/presentation/profile_screens/profile_page.dart';
import 'package:chef_ai/features/presentation/recipe_screens/recipe_screen.dart';
import 'package:chef_ai/features/presentation/save_recipe_screens/saved_recipes_page.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  // List of pages
  final List<Widget> _pages = [
    const RecipeScreen(),
    const AIAssistantPage(),
    const SavedRecipesPage(),
    const ProfileSettingsScreen(),
  ];

  // Navigation icons
  final List<IconData> _icons = [
    Icons.home_rounded,
    Icons.psychology_rounded,
    Icons.bookmark_rounded,
    Icons.person_rounded,
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      extendBody: true,
      body: IndexedStack(index: _currentIndex, children: _pages),
      bottomNavigationBar: CurvedNavigationBar(
        index: _currentIndex,
        height: 65,
        items: _icons
            .map((icon) => Icon(icon, size: 28, color: Colors.white))
            .toList(),
        color: isDark ? AppColors.primaryDark : AppColors.primaryLight,
        buttonBackgroundColor: isDark
            ? AppColors.secondaryDark
            : AppColors.secondaryLight,
        backgroundColor: Colors.transparent,
        animationCurve: Curves.easeInOutCubic,
        animationDuration: const Duration(milliseconds: 400),
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
