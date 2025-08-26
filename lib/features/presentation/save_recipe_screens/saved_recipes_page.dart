import 'package:chef_ai/core/themes/app_colors.dart';
import 'package:chef_ai/features/presentation/save_recipe_screens/widgets/save_recipe_tile.dart';
import 'package:chef_ai/features/widgets/gradient_container.dart';
import 'package:flutter/material.dart';

class SavedRecipesPage extends StatefulWidget {
  const SavedRecipesPage({super.key});

  @override
  State<SavedRecipesPage> createState() => _SavedRecipesPageState();
}

class _SavedRecipesPageState extends State<SavedRecipesPage> {
  // Mock saved recipes data - Replace with actual data from your state management
  List<Map<String, dynamic>> savedRecipes = [
    {
      'id': 1,
      'imageUrl': 'https://spoonacular.com/recipeImages/715538-556x370.jpg',
      'title': 'What to make for dinner tonight?? Bruschetta!',
      'description': 'Delicious Italian appetizer with fresh tomatoes',
      'prepTimeMinutes': 15,
      'cookTimeMinutes': 10,
      'rating': 4.5,
      'reviewCount': 127,
    },
    {
      'id': 2,
      'imageUrl': 'https://spoonacular.com/recipeImages/716429-556x370.jpg',
      'title': 'Pasta with Garlic, Scallions, and Black Pepper',
      'description': 'Simple yet flavorful pasta dish',
      'prepTimeMinutes': 10,
      'cookTimeMinutes': 20,
      'rating': 4.8,
      'reviewCount': 89,
    },
    {
      'id': 3,
      'imageUrl': 'https://spoonacular.com/recipeImages/782585-556x370.jpg',
      'title': 'Cannellini Bean and Kale Soup',
      'description': 'Healthy and hearty soup perfect for cold days',
      'prepTimeMinutes': 20,
      'cookTimeMinutes': 45,
      'rating': 4.2,
      'reviewCount': 156,
    },
    {
      'id': 4,
      'imageUrl': 'https://spoonacular.com/recipeImages/716426-556x370.jpg',
      'title': 'Cauliflower, Brown Rice, and Vegetable Fried Rice',
      'description': 'Healthy twist on classic fried rice',
      'prepTimeMinutes': 15,
      'cookTimeMinutes': 25,
      'rating': 4.0,
      'reviewCount': 203,
    },
    {
      'id': 5,
      'imageUrl': 'https://spoonacular.com/recipeImages/715497-556x370.jpg',
      'title': 'Berry Banana Breakfast Smoothie',
      'description': 'Nutritious start to your day',
      'prepTimeMinutes': 5,
      'cookTimeMinutes': 0,
      'rating': 4.7,
      'reviewCount': 312,
    },
  ];

  void _removeRecipe(int recipeId) {
    setState(() {
      savedRecipes.removeWhere((recipe) => recipe['id'] == recipeId);
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Recipe removed from saved'),
        backgroundColor: AppColors.errorColor,
        action: SnackBarAction(
          label: 'Undo',
          textColor: Colors.white,
          onPressed: () {
            // TODO: Implement undo functionality
          },
        ),
      ),
    );
  }

  void _openRecipeDetail(Map<String, dynamic> recipe) {
    // TODO: Navigate to recipe detail screen
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opening ${recipe['title']}'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: GradientContainer(
        isDark: isDark,
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: (isDark ? AppColors.primaryDark : AppColors.primaryLight)
                            .withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.bookmark_rounded,
                        color: isDark ? AppColors.primaryDark : AppColors.primaryLight,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Saved Recipes',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: isDark
                                ? AppColors.textPrimaryDark
                                : AppColors.textPrimaryLight,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const Spacer(),
                    Text(
                      '${savedRecipes.length} recipes',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: isDark
                                ? AppColors.textSecondaryDark
                                : AppColors.textSecondaryLight,
                          ),
                    ),
                  ],
                ),
              ),

              // Saved Recipes List
              Expanded(
                child: savedRecipes.isEmpty
                    ? _buildEmptyState(isDark)
                    : Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: ListView.builder(
                          itemCount: savedRecipes.length,
                          itemBuilder: (context, index) {
                            final recipe = savedRecipes[index];
                            return SavedRecipeTile(
                              imageUrl: recipe['imageUrl'],
                              title: recipe['title'],
                              description: recipe['description'],
                              prepTimeMinutes: recipe['prepTimeMinutes'],
                              cookTimeMinutes: recipe['cookTimeMinutes'],
                              rating: recipe['rating'].toDouble(),
                              reviewCount: recipe['reviewCount'],
                              onTap: () => _openRecipeDetail(recipe),
                              onRemove: () => _removeRecipe(recipe['id']),
                            );
                          },
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(bool isDark) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: (isDark ? AppColors.primaryDark : AppColors.primaryLight)
                    .withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.bookmark_border,
                size: 64,
                color: isDark ? AppColors.primaryDark : AppColors.primaryLight,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'No Saved Recipes Yet',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: isDark
                        ? AppColors.textPrimaryDark
                        : AppColors.textPrimaryLight,
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Start exploring recipes and save your favorites here!',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: isDark
                        ? AppColors.textSecondaryDark
                        : AppColors.textSecondaryLight,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: LinearGradient(
                  colors: isDark
                      ? AppColors.buttonDarkGradient
                      : AppColors.buttonLightGradient,
                ),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () {
                    // TODO: Navigate to home/browse recipes
                    Navigator.pop(context);
                  },
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    child: Text(
                      'Browse Recipes',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
