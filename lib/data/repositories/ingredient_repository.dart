import 'dart:io';

import 'package:recipe_app/data/model/ingredient.dart';
import 'package:recipe_app/data/model/recipe.dart';
import 'package:recipe_app/domain/models/ingredient/ingredient.dart';

import '../../domain/models/recipe/recipe.dart';
import '../services/local/database_service.dart';
import '../../utils/result.dart';

class IngredientRepository {
  IngredientRepository({required this._database});

  final DatabaseService _database;

  // #docregion Ingredient CRUD
  Future<Result<IngredientEntity>> createIngredient(String ingredient) async {
    if (!_database.isOpen()) {
        await _database.open();
    }
    return _database.insertIngredient(ingredient);
  }
  // #enddocregion Ingredient CRUD

  // #docregion Ingredient CRUD
  Future<Result<void>> deleteIngredient(String ingredientId) async {
    if (!_database.isOpen()) {
        await _database.open();
    }
    return _database.deleteIngredient(ingredientId);
  }
  // #enddocregion Ingredient CRUD

  // #docregion Ingredient CRUD
  Future<Result<List<Ingredient>>> fetchIngredients() async {
    final Result<List<IngredientEntity>> result;
    if (!_database.isOpen()) {
        await _database.open();
    }
    result = await _database.getAllIngredients();
    print(result);
    switch (result) {
      case Ok<List<IngredientEntity>>():
        final ingredients = result.value.map((ingredientEntity) {
          return Ingredient(
            id: ingredientEntity.id,
            name: ingredientEntity.name
          );
        }).toList();
        return Result.ok(ingredients);
      case Error():
        return Result.error(result.error);
    } 
  }
  // #enddocregion Ingredient CRUD
}