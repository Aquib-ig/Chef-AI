import 'package:chef_ai/features/models/recipe.dart';
import 'package:chef_ai/features/presentation/ai_assistant_screen/bloc/ai_assistant_bloc.dart';
import 'package:chef_ai/features/presentation/ai_assistant_screen/recipe_detail_page.dart';
import 'package:chef_ai/features/widgets/gradient_button.dart';
import 'package:chef_ai/features/widgets/gradient_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AIAssistantPage extends StatefulWidget {
  const AIAssistantPage({super.key});

  @override
  State<AIAssistantPage> createState() => _AIAssistantPageState();
}

class _AIAssistantPageState extends State<AIAssistantPage> {
  final TextEditingController _ingredientsController = TextEditingController();

  void _addIngredient() {
    if (_ingredientsController.text.trim().isNotEmpty) {
      context.read<AiAssistantBloc>().add(
        AddIngredientEvent(_ingredientsController.text.trim()),
      );
      _ingredientsController.clear();
    }
  }

  void _removeIngredient(int index) {
    context.read<AiAssistantBloc>().add(RemoveIngredientEvent(index));
  }

  void _getSuggestions(List<String> ingredients) {
    context.read<AiAssistantBloc>().add(GetRecipeSuggestionsEvent(ingredients));
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      // Remove any background color from Scaffold
      backgroundColor: Colors.transparent,
      // Make sure the body takes full space
      extendBodyBehindAppBar: true,
      extendBody: true,
      body: GradientContainer(
        isDark: isDark,
        child: SizedBox(
          // Make container take full screen dimensions
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: BlocBuilder<AiAssistantBloc, AiAssistantState>(
                builder: (context, state) {
                  final ingredients = _getCurrentIngredients(state);

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Icon(
                              Icons.psychology_rounded,
                              color: Theme.of(context).colorScheme.primary,
                              size: 28,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'AI Chef Assistant',
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Tell me what you have, I\'ll suggest recipes!',
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 30),

                      // Add Ingredients Section
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.orange.withOpacity(0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'What ingredients do you have?',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: _ingredientsController,
                                    decoration: const InputDecoration(
                                      hintText: 'e.g., tomatoes, onions, chicken...',
                                      prefixIcon: Icon(Icons.add_circle_outline),
                                    ),
                                    onSubmitted: (_) => _addIngredient(),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                GradientButton(
                                  text: 'Add',
                                  isDark: isDark,
                                  onPressed: _addIngredient,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Ingredients List
                      if (ingredients.isNotEmpty) ...[
                        Text(
                          'Your Ingredients (${ingredients.length})',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surface,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.orange.withOpacity(0.1),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: ingredients.asMap().entries.map((entry) {
                              return Chip(
                                label: Text(entry.value),
                                deleteIcon: const Icon(Icons.close, size: 18),
                                onDeleted: () => _removeIngredient(entry.key),
                                backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                                deleteIconColor: Theme.of(context).colorScheme.primary,
                                labelStyle: TextStyle(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontWeight: FontWeight.w500,
                                ),
                              );
                            }).toList(),
                          ),
                        ),

                        const SizedBox(height: 30),

                        // Get Suggestions Button
                        SizedBox(
                          width: double.infinity,
                          child: GradientButton(
                            text: state is AiAssistantLoading
                                ? 'AI is thinking...'
                                : 'Get AI Recipe Suggestions',
                            isDark: isDark,
                            onPressed: (state is AiAssistantLoading)
                                ? null
                                : () => _getSuggestions(ingredients),
                          ),
                        ),
                      ],

                      const SizedBox(height: 30),

                      // Recipe Results
                      if (state is AiAssistantLoading) ...[
                        Center(
                          child: Column(
                            children: [
                              CircularProgressIndicator(
                                color: Theme.of(context).colorScheme.primary,
                                strokeWidth: 3,
                              ),
                              const SizedBox(height: 20),
                              Text(
                                '🤖 AI is analyzing your ingredients...',
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Finding the perfect recipes for you!',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ),
                      ] else if (state is AiAssistantError) ...[
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: Colors.red.withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.error_outline, color: Colors.red),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'AI Error',
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      state.message,
                                      style: const TextStyle(color: Colors.red),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ] else if (state is AiAssistantLoaded) ...[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '🍳 AI Recipe Suggestions (${state.recipes.length})',
                                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    context.read<AiAssistantBloc>().add(ClearRecipesEvent());
                                  },
                                  child: const Text('Clear Results'),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Powered by Spoonacular AI',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Colors.grey[600],
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                            const SizedBox(height: 16),
                            ...state.recipes.map(
                              (recipe) => _buildRecipeCard(recipe, context),
                            ),
                          ],
                        ),
                      ],

                      const SizedBox(height: 30),

                      // Tips Section
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Theme.of(context).colorScheme.secondary.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.lightbulb_outline,
                                  color: Theme.of(context).colorScheme.secondary,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Tips for better AI suggestions',
                                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                    color: Theme.of(context).colorScheme.secondary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            _buildTipItem('Add main proteins (chicken, beef, fish)', context),
                            _buildTipItem('Include vegetables you have', context),
                            _buildTipItem('Mention spices and herbs', context),
                            _buildTipItem('Try combinations like "pasta, tomato, cheese"', context),
                          ],
                        ),
                      ),

                      // Add extra padding at bottom to ensure content is not cut off
                      const SizedBox(height: 100),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<String> _getCurrentIngredients(AiAssistantState state) {
    switch (state) {
      case AiAssistantInitial():
        return state.ingredients;
      case AiAssistantLoading():
        return state.ingredients;
      case AiAssistantLoaded():
        return state.ingredients;
      case AiAssistantError():
        return state.ingredients;
    }
  }

Widget _buildRecipeCard(Recipe recipe, BuildContext context) {
  return GestureDetector(
    onTap: () {
      // Navigate to recipe detail page
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RecipeDetailPage(recipe: recipe),
        ),
      );
    },
    child: Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.orange.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  recipe.name ?? 'Unknown Recipe',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              if (recipe.rating != null && recipe.rating! > 0)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.star, color: Colors.orange, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        recipe.rating!.toStringAsFixed(1),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              if (recipe.prepTimeMinutes != null && recipe.prepTimeMinutes! > 0) ...[
                Icon(Icons.schedule, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(
                  '${recipe.prepTimeMinutes! + (recipe.cookTimeMinutes ?? 0)} min',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(width: 16),
              ],
              if (recipe.servings != null) ...[
                Icon(Icons.people, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(
                  '${recipe.servings} servings',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(width: 16),
              ],
              if (recipe.difficulty != null) ...[
                Icon(Icons.signal_cellular_alt, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(
                  recipe.difficulty!,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ],
          ),
          const SizedBox(height: 16),
          
          // Preview of instructions
          if (recipe.instructions != null && recipe.instructions!.isNotEmpty) ...[
            Text(
              'Recipe Preview:',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              recipe.instructions!.first,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey[600],
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 12),
          ],

          // Tap to view indicator
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.touch_app,
                  size: 16,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 6),
                Text(
                  'Tap to view full recipe',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}


  Widget _buildTipItem(String text, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('• ', style: Theme.of(context).textTheme.bodyMedium),
          Expanded(
            child: Text(text, style: Theme.of(context).textTheme.bodyMedium),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _ingredientsController.dispose();
    super.dispose();
  }
}
