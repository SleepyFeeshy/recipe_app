// import '../model/recipe.dart';
import 'dart:io';

import 'package:recipe_app/data/model/ingredient.dart';
import 'package:recipe_app/data/model/recipe.dart';

import '../../domain/models/recipe/recipe.dart';
import '../services/local/database_service.dart';
import '../../utils/result.dart';

class RecipeRepository {
    RecipeRepository({required this._database});

    final DatabaseService _database;

    // #docregion Recipe CRUD
    Future<Result<List<Recipe>>> fetchRecipes() async {
      final Result<List<RecipeEntity>> result;
      final List<Recipe> recipes;
      if (!_database.isOpen()) {
          await _database.open();
      }

      result = await _database.getAllRecipes();
      switch (result) {
        case Ok<List<RecipeEntity>>():
          recipes = result.value.map((recipeEntity) {
              // Fetch ingredients of recipe
              return Recipe(
                id: recipeEntity.id,
                name: recipeEntity.name,
                ingredients: []
              );
            }
          ).toList();
          return Result.ok(recipes);
        case Error():
          return Result.error(result.error);
      }
    }

    Future<Result<RecipeEntity>> createRecipe(String recipe) async {
        if (!_database.isOpen()) {
            await _database.open();
        }
        return _database.insertRecipe(recipe);
    }

    Future<void> seedRecipes(List recipes) async {
        if (!_database.isOpen()) {
            await _database.open();
        }
        for (Recipe recipe in recipes) {
            await _database.insertRecipe(recipe.name);
        }
    }
    // #enddocregion Recipe CRUD
}