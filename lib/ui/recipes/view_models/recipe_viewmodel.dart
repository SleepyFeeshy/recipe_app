import 'dart:async';

import 'package:flutter/material.dart';
import 'package:recipe_app/data/model/recipe.dart';
import 'package:recipe_app/data/model/recipe_ingredient.dart';
import 'package:recipe_app/domain/models/ingredient/ingredient.dart';
import 'package:recipe_app/domain/models/recipe_ingredient/recipe_ingredient.dart';

import '../../../domain/models/recipe/recipe.dart';
import '../../../data/repositories/recipe_repository.dart';
import '../../../data/repositories/recipe_ingredient_repository.dart';
import '../../../data/repositories/ingredient_repository.dart';

import '../../../utils/command.dart';
import '../../../utils/result.dart';

import '../../../domain/models/recipe/recipe.dart';

List<Recipe> generateSeedData() {
  return allSampleRecipes.toList();
}

// ViewModel of Recipe
class RecipeViewModel extends ChangeNotifier {
  // Repository placeholder
  // RecipeViewModel({required this.recipeRepository}) : _recipesNotifier = ValueNotifier(generateSeedData());
  RecipeViewModel({required this._recipeRepository, required this._recipeIngredientRepository}) {
    load = Command0<void>(_load)..execute();
    add = Command1<void, Recipe>(_add);
    delete = Command1<void, Recipe>(_delete);
  }
  final RecipeRepository _recipeRepository;
  final RecipeIngredientRepository _recipeIngredientRepository;
  
  // Load Recipe items from repository
  late Command0<void> load;

  // Add Recipe item
  late Command1<void, Recipe> add;
  late Command1<void, Recipe> delete;

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

  Future<Result<void>> _add(Recipe recipe) async {
    try {
      final result = await _recipeRepository.createRecipeFromObject(recipe);
      switch (result) {
        case Ok<void>():
          await load.execute();
          return Result.ok(null);
        case Error():
          return Result.error(result.error);
      } 
    } on Exception catch(e) {
      return Result.error(e);
    } finally {
      notifyListeners();
    }
  }

  Future<Result<void>> _delete(Recipe recipe) async {
    try {
      final result = await _recipeRepository.deleteRecipe(recipe.id);
      switch (result) {
        case Ok<void>():
          await load.execute();
          return Result.ok(null);
        case Error():
          return Result.error(result.error);
      } 
    } on Exception catch(e) {
      return Result.error(e);
    } finally {
      notifyListeners();
    }
  }
}