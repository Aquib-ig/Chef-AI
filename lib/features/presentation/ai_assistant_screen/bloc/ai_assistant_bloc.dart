import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:chef_ai/features/models/recipe.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

part 'ai_assistant_event.dart';
part 'ai_assistant_state.dart';

class AiAssistantBloc extends Bloc<AiAssistantEvent, AiAssistantState> {
  static const String _apiKey = '8fe072ee6b224ae7b7d370941de3565e';

  AiAssistantBloc() : super(const AiAssistantInitial()) {
    on<AddIngredientEvent>(_onAddIngredient);
    on<RemoveIngredientEvent>(_onRemoveIngredient);
    on<GetRecipeSuggestionsEvent>(_onGetRecipeSuggestions);
    on<ClearRecipesEvent>(_onClearRecipes);
  }

  void _onAddIngredient(AddIngredientEvent event, Emitter<AiAssistantState> emit) {
    final currentIngredients = _getCurrentIngredients(state);
    if (!currentIngredients.contains(event.ingredient.trim())) {
      final updatedIngredients = [...currentIngredients, event.ingredient.trim()];
      emit(AiAssistantInitial(ingredients: updatedIngredients));
    }
  }

  void _onRemoveIngredient(RemoveIngredientEvent event, Emitter<AiAssistantState> emit) {
    final currentIngredients = _getCurrentIngredients(state);
    if (event.index >= 0 && event.index < currentIngredients.length) {
      final updatedIngredients = [...currentIngredients];
      updatedIngredients.removeAt(event.index);
      emit(AiAssistantInitial(ingredients: updatedIngredients));
    }
  }

  void _onClearRecipes(ClearRecipesEvent event, Emitter<AiAssistantState> emit) {
    final currentIngredients = _getCurrentIngredients(state);
    emit(AiAssistantInitial(ingredients: currentIngredients));
  }

  Future<void> _onGetRecipeSuggestions(
    GetRecipeSuggestionsEvent event,
    Emitter<AiAssistantState> emit,
  ) async {
    if (event.ingredients.isEmpty) {
      emit(AiAssistantError(
        ingredients: event.ingredients,
        message: 'Please add some ingredients first!',
      ));
      return;
    }

    emit(AiAssistantLoading(event.ingredients));

    try {
      // Use Spoonacular AI to find recipes by ingredients
      final recipes = await _getSpoonacularAIRecipes(event.ingredients);
      
      if (recipes.isNotEmpty) {
        emit(AiAssistantLoaded(
          ingredients: event.ingredients,
          recipes: recipes,
        ));
      } else {
        emit(AiAssistantError(
          ingredients: event.ingredients,
          message: 'No recipes found. Try adding more common ingredients!',
        ));
      }
    } catch (e) {
      emit(AiAssistantError(
        ingredients: event.ingredients,
        message: 'Failed to get AI suggestions. Please check your internet connection.',
      ));
    }
  }

  Future<List<Recipe>> _getSpoonacularAIRecipes(List<String> ingredients) async {
    try {
      // Step 1: Use Spoonacular AI to find recipes by ingredients
      final ingredientString = ingredients.join(',+');
      final findByIngredientsUrl = Uri.parse(
        'https://api.spoonacular.com/recipes/findByIngredients?ingredients=$ingredientString&number=5&ranking=1&ignorePantry=true&apiKey=$_apiKey'
      );

      final findResponse = await http.get(findByIngredientsUrl);
      
      if (findResponse.statusCode == 200) {
        final List foundRecipes = json.decode(findResponse.body);
        final List<Recipe> detailedRecipes = [];

        // Step 2: Get detailed information for each recipe from Spoonacular AI
        for (var recipeData in foundRecipes.take(10)) {
          final recipeId = recipeData['id'];
          
          // Get detailed recipe information
          final detailUrl = Uri.parse(
            'https://api.spoonacular.com/recipes/$recipeId/information?includeNutrition=false&apiKey=$_apiKey'
          );

          final detailResponse = await http.get(detailUrl);
          
          if (detailResponse.statusCode == 200) {
            final detailData = json.decode(detailResponse.body);
            
            // Convert Spoonacular data to our Recipe model
            final recipe = _convertSpoonacularToRecipe(detailData);
            detailedRecipes.add(recipe);
          }
        }

        return detailedRecipes;
      } else if (findResponse.statusCode == 402) {
        throw Exception('API quota exceeded');
      } else {
        throw Exception('Failed to fetch recipes');
      }
    } catch (e) {
      log('Spoonacular AI Error: $e');
      rethrow;
    }
  }

  Recipe _convertSpoonacularToRecipe(Map<String, dynamic> spoonacularData) {
    // Extract ingredients from Spoonacular AI response
    List<String> ingredientsList = [];
    if (spoonacularData['extendedIngredients'] != null) {
      ingredientsList = (spoonacularData['extendedIngredients'] as List)
          .map((ingredient) => ingredient['original'].toString())
          .toList();
    }

    // Extract instructions from Spoonacular AI response
    List<String> instructionsList = [];
    if (spoonacularData['analyzedInstructions'] != null &&
        (spoonacularData['analyzedInstructions'] as List).isNotEmpty) {
      final steps = spoonacularData['analyzedInstructions'][0]['steps'] as List;
      instructionsList = steps
          .map((step) => step['step'].toString())
          .where((step) => step.isNotEmpty)
          .toList();
    }

    // If no structured instructions, try to parse from instructions field
    if (instructionsList.isEmpty && spoonacularData['instructions'] != null) {
      final instructionsText = spoonacularData['instructions'].toString();
      if (instructionsText.isNotEmpty) {
        // Clean and split instructions
        instructionsList = instructionsText
            .replaceAll(RegExp(r'<[^>]*>'), '') // Remove HTML tags
            .split(RegExp(r'\.(?=\s[A-Z0-9])|[\n\r]+')) // Split by sentences
            .map((instruction) => instruction.trim())
            .where((instruction) => instruction.isNotEmpty && instruction.length > 10)
            .toList();
      }
    }

    // Extract dietary tags and cuisine
    // List<String> tags = [];
    // if (spoonacularData['cuisines'] != null) {
    //   tags.addAll((spoonacularData['cuisines'] as List).cast<String>());
    // }
    // if (spoonacularData['diets'] != null) {
    //   tags.addAll((spoonacularData['diets'] as List).cast<String>());
    // }
    // if (spoonacularData['dishTypes'] != null) {
    //   tags.addAll((spoonacularData['dishTypes'] as List).cast<String>());
    // }

    // Extract meal types
    List<String> mealTypes = [];
    if (spoonacularData['dishTypes'] != null) {
      mealTypes = (spoonacularData['dishTypes'] as List).cast<String>();
    }

    // Determine difficulty based on ready time and steps
    String difficulty = 'Easy';
    final readyTime = spoonacularData['readyInMinutes'] ?? 30;
    final stepCount = instructionsList.length;
    
    if (readyTime > 60 || stepCount > 8) {
      difficulty = 'Hard';
    } else if (readyTime > 30 || stepCount > 5) {
      difficulty = 'Medium';
    }

    // Extract cuisine
    String cuisine = 'International';
    if (spoonacularData['cuisines'] != null && 
        (spoonacularData['cuisines'] as List).isNotEmpty) {
      cuisine = (spoonacularData['cuisines'] as List).first.toString();
    }

    // Create Recipe object with Spoonacular AI data
    return Recipe(
      id: spoonacularData['id'],
      name: spoonacularData['title'] ?? 'AI Generated Recipe',
      ingredients: ingredientsList,
      instructions: instructionsList,
      prepTimeMinutes: spoonacularData['preparationMinutes'] ?? 15,
      cookTimeMinutes: spoonacularData['cookingMinutes'] ?? (readyTime - 15),
      servings: spoonacularData['servings'] ?? 4,
      difficulty: difficulty,
      cuisine: cuisine,
      caloriesPerServing: _extractCalories(spoonacularData),
      // tags: tags,
      userId: null,
      image: spoonacularData['image'],
      rating: _calculateRating(spoonacularData),
      reviewCount: spoonacularData['aggregateLikes'] ?? 0,
      mealType: mealTypes,
    );
  }

  int? _extractCalories(Map<String, dynamic> data) {
    if (data['nutrition'] != null && data['nutrition']['nutrients'] != null) {
      final nutrients = data['nutrition']['nutrients'] as List;
      for (var nutrient in nutrients) {
        if (nutrient['name'] == 'Calories') {
          return (nutrient['amount'] as num).round();
        }
      }
    }
    return null;
  }

  double? _calculateRating(Map<String, dynamic> data) {
    if (data['spoonacularScore'] != null) {
      // Convert spoonacular score (0-100) to 5-star rating
      return (data['spoonacularScore'] as num) / 20.0;
    }
    return null;
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
}
