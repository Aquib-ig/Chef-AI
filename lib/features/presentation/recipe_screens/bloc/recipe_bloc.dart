import 'dart:convert';
import 'dart:math';

import 'package:chef_ai/features/models/recipe.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

part 'recipe_event.dart';
part 'recipe_state.dart';

class RecipeBloc extends Bloc<RecipeEvent, RecipeState> {
  final String baseUrl = "https://dummyjson.com";
  List<Recipe> _allRecipes = [];
  List<Recipe> _recommendedRecipe = [];
  List<Recipe> _filteredRecipes = [];

  List<Recipe> get recommendedRecipe => _recommendedRecipe;

  RecipeBloc() : super(RecipeInitial()) {
    on<FetchRecipes>(_onFetchRecipes);
    on<CategorySelected>(_onCategorySelected);
    on<SearchRecipes>(_onSearchRecipes);
  }

  // Fetch recipes from API
  Future<void> _onFetchRecipes(
    FetchRecipes event,
    Emitter<RecipeState> emit,
  ) async {
    emit(RecipeLoading());

    try {
      // Make HTTP GET request
      final response = await http.get(Uri.parse("$baseUrl/recipes?limit=0"));

      if (response.statusCode == 200) {
        // Parse JSON response
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        final List<dynamic> data = jsonResponse["recipes"];

        // Convert to Recipe objects
        _allRecipes = data.map((item) => Recipe.fromJson(item)).toList();

        // Create a recommended recipes (10 random recipes)
        _recommendedRecipe = List.from(_allRecipes);
        _recommendedRecipe.shuffle(Random());
        _recommendedRecipe = _recommendedRecipe.take(10).toList();

        // // Initialize filtered recipes with all recipes
        //  _allRecipes;

        // Initially show all recipe
        emit(RecipeLoaded(recipes: _allRecipes));
      } else {
        emit(
          RecipeError(
            message: "Failed to load recipes: ${response.statusCode}",
          ),
        );
      }
    } catch (e) {
      emit(RecipeError(message: "Failed to fetch recipes: ${e.toString()}"));
    }
  }

  void _onCategorySelected(CategorySelected event, Emitter<RecipeState> emit) {
    if (_allRecipes.isEmpty) return;
    List<Recipe> filteredRecipe;
    if (event.category == "All") {
      filteredRecipe = _allRecipes;
    } else {
      filteredRecipe = _allRecipes.where((recipe) {
        final mealType = recipe.mealType ?? [];

        // Helper function to normalize strings for comparison
        String normalize(String s) =>
            s.replaceAll(RegExp(r'\s+'), '').toLowerCase();
        final selectedCategory = normalize(event.category);

        //Check if any category matches any meal type
        final inMealType = mealType.any(
          (meal) => normalize(meal) == selectedCategory,
        );

        return inMealType;
      }).toList();
    }
    emit(RecipeLoaded(recipes: filteredRecipe));
  }

  void _onSearchRecipes(SearchRecipes event, Emitter<RecipeState> emit) {
    if (event.query.isEmpty) {
      _filteredRecipes = _allRecipes;
    } else {
      _filteredRecipes = _allRecipes.where((recipe) {
        final query = event.query.toLowerCase();
        final name = (recipe.name ?? "").toLowerCase();
        final ingredient = (recipe.ingredients ?? []).join(" ").toLowerCase();

        return name.contains(query) || ingredient.contains(query);
      }).toList();
    }
    emit(RecipeLoaded(recipes: _filteredRecipes));
  }
}
