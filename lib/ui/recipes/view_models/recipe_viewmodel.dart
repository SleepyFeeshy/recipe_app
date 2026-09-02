import 'dart:async';

import 'package:flutter/material.dart';

import '../../../domain/models/recipe/recipe.dart';
import '../../../data/repositories/recipe_repository.dart';

import '../../../utils/command.dart';
import '../../../utils/result.dart';

List<Recipe> generateSeedData() {
  return allRecipes.toList();
}

// ViewModel of Recipe
class RecipeViewModel extends ChangeNotifier {
  // Repository placeholder
  // RecipeViewModel({required this.recipeRepository}) : _recipesNotifier = ValueNotifier(generateSeedData());
  RecipeViewModel({required this._recipeRepository}) {
    load = Command0<void>(_load)..execute();
  }
  final RecipeRepository _recipeRepository;
  
  // Load Recipe items from repository
  late Command0<void> load;

  List<Recipe> _recipes = [];
  List<Recipe> get recipes => _recipes;

  Future<Result<void>> _load() async {
    try {
      final result = await _recipeRepository.fetchRecipes();
      switch (result) {
        case Ok<List<Recipe>>():
          _recipes = result.value;
          return Result.ok(null);
        case Error():
          return Result.error(result.error);
      }
    } on Exception catch (e) {
      return Result.error(e);
    } finally {
      notifyListeners();
    }
  }
}