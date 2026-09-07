// import '../model/recipe.dart';
import 'dart:io';

import 'package:recipe_app/data/model/ingredient.dart';
import 'package:recipe_app/data/model/recipe.dart';
import 'package:recipe_app/data/model/recipe_ingredient.dart';

import '../../domain/models/recipe/recipe.dart';
import '../../domain/models/ingredient/ingredient.dart';
import '../services/local/database_service.dart';
import '../../utils/result.dart';

class RecipeRepository {
  RecipeRepository({required this._database});

  final DatabaseService _database;

  // #docregion Recipe CRUD
  // Future<Result<List<Recipe>>> fetchRecipes() async {
  //   final Result<List<RecipeEntity>> result;
  //   final Result<List<IngredientEntity>> ingredients;

  //   final List<Recipe> recipes;
  //   if (!_database.isOpen()) {
  //       await _database.open();
  //   }

  //   result = await _database.getAllRecipes();
  //   switch (result) {
  //     case Ok<List<RecipeEntity>>():
  //       recipes = result.value.map((recipeEntity) {
  //           // Fetch ingredients of recipe
  //           // ingredients = await _database.fetchIngredientsWithRecipeId(recipeEntity.id);
  //           return Recipe(
  //             id: recipeEntity.id,
  //             name: recipeEntity.name,
  //             ingredients: []
  //           );
  //         }
  //       ).toList();
  //       return Result.ok(recipes);
  //     case Error():
  //       return Result.error(result.error);
  //   }
  // }

  Future<Result<List<Recipe>>> fetchRecipes() async {
    final Result<List<FullRecipeIngredientEntity>> result;
    // final List<RecipeIngredient> = recipeIngredients;
    if (!_database.isOpen()) {
      await _database.open();
    }
    result = await _database.fetchFullRecipeData();
    switch (result) {
      case Ok<List<FullRecipeIngredientEntity>>():
        var fullRecipeIngredients = result.value;
        // Extract recipes
        var recipes = fullRecipeIngredients.map((recipeIngredient) {
          return (
            recipeId: recipeIngredient.recipeId,
            recipeName: recipeIngredient.recipeName,
          );
        }).toSet();
        print(recipes);
        var returnVal = recipes.map((recipeName) {
          var ingredients = fullRecipeIngredients.where(
            (fullRecipeIngredient) =>
                fullRecipeIngredient.recipeId == recipeName.recipeId,
          );
          return Recipe(
            id: recipeName.recipeId,
            name: recipeName.recipeName,
            ingredients: ingredients.map((ingredient) {
              return Ingredient(
                id: ingredient.ingredientId,
                name: ingredient.ingredientName,
              );
            }).toList(),
          );
        }).toList();
        return Result.ok(returnVal);
      case Error():
        return Result.error(result.error);
    }
  }

  // Future<Result<RecipeEntity>> createRecipe(String recipe) async {
  //     if (!_database.isOpen()) {
  //         await _database.open();
  //     }
  //     return _database.insertRecipe(recipe);
  // }

  Future<Result<RecipeEntity>> createRecipe(String recipe) async {
    if (!_database.isOpen()) {
      await _database.open();
    }
    return _database.insertRecipe(recipe);
  }

  Future<Result<void>> createRecipeFromObject(Recipe recipe) async {
    if (!_database.isOpen()) {
      await _database.open();
    }

    // Create recipe
    var recipeResult = await _database.insertRecipe(recipe.name);
    final List<Ingredient> returnIngredients = [];
    switch (recipeResult) {
      case Ok<RecipeEntity>():
        // Create ingredients
        for (Ingredient ingredient in recipe.ingredients) {
          var ingredientResult = await _database.insertIngredient(
            ingredient.name,
          );
          switch (ingredientResult) {
            case Ok<IngredientEntity>():
              var newRecipeIngredient = await _database.insertRecipeIngredient(
                ingredientResult.value.id,
                recipeResult.value.id,
              );
              switch (newRecipeIngredient) {
                case Ok<RecipeIngredientEntity>():
                  print(ingredient.name);
                case Error():
                  return Result.error(newRecipeIngredient.error);
              }
            case Error():
              return Result.error(ingredientResult.error);
          }
          
        }
      case Error():
        return Result.error(recipeResult.error);
    }
    return Result.ok(null);
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
