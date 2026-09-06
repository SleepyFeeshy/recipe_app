import 'dart:async';

import 'package:flutter/material.dart';
import 'package:recipe_app/domain/models/ingredient/ingredient.dart';

import '../../../domain/models/recipe/recipe.dart';
import '../../../data/repositories/ingredient_repository.dart';

import '../../../utils/command.dart';
import '../../../utils/result.dart';

import '../../../domain/models/recipe/recipe.dart';

List<Recipe> generateSeedData() {
  return allSampleRecipes.toList();
}

// ViewModel of Recipe
class IngredientViewModel extends ChangeNotifier {
  // Repository placeholder
  // RecipeViewModel({required this.recipeRepository}) : _recipesNotifier = ValueNotifier(generateSeedData());
  IngredientViewModel({required this._ingredientRepository}) {
    load = Command0<void>(_load)..execute();
  }
  final IngredientRepository _ingredientRepository;
  
  // Load Recipe items from repository
  late Command0<void> load;

  List<Ingredient> _ingredients = [];
  List<Ingredient> get ingredients => _ingredients;

  Future<Result<void>> _load() async {
    try {
      final result = await _ingredientRepository.fetchIngredients();
      switch (result) {
        case Ok<List<Ingredient>>():
          _ingredients = result.value;
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