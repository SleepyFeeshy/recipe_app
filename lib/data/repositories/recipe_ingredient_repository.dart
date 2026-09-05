import 'dart:io';

import 'package:recipe_app/data/model/ingredient.dart';
import 'package:recipe_app/data/model/recipe.dart';
import 'package:recipe_app/data/model/recipe_ingredient.dart';

import '../../domain/models/recipe_ingredient/recipe_ingredient.dart';
import '../services/local/database_service.dart';
import '../../utils/result.dart';

class RecipeIngredientRepository {
  RecipeIngredientRepository({required this._database});

  final DatabaseService _database;

  // #docregion Ingredient CRUD
  Future<Result<RecipeIngredient>> createRecipeIngredient(String recipeId, String ingredientId) async {
    final Result<RecipeIngredientEntity> result;
    final RecipeIngredient recipeIngredient;
      if (!_database.isOpen()) {
          await _database.open();
      }
      result = await _database.insertRecipeIngredient(ingredientId, recipeId);
      switch (result) {
        case Ok<RecipeIngredientEntity>():
          recipeIngredient = RecipeIngredient(
            id: result.value.id, 
            ingredientId: result.value.ingredientId,
            recipeId:   result.value.recipeId, 
            ingredientName: "TODO: ingredientName of recipeIngredient");
          return Result.ok(recipeIngredient);
        case Error():
          return Result.error(result.error);
      }
  }
  // #enddocregion Ingredient CRUD
}