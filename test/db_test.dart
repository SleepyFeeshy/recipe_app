import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:recipe_app/data/model/ingredient.dart';
import 'package:recipe_app/data/model/recipe.dart';
import 'package:recipe_app/data/repositories/recipe_ingredient_repository.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'package:recipe_app/data/repositories/recipe_repository.dart';
import 'package:recipe_app/data/repositories/ingredient_repository.dart';
import 'package:recipe_app/data/services/local/database_service.dart';
import 'package:uuid/uuid.dart';
import 'package:recipe_app/utils/result.dart';

var uuid = Uuid();

void main() async {
  late DatabaseService databaseService;
  // close db if open

  // Chrome has no SQLite functionality, can't access local files
  if (kIsWeb) {
    throw UnsupportedError('Platform not supported.');
  } else if (Platform.isLinux || Platform.isWindows || Platform.isMacOS) {
    // Initialize FFI SQLite
    // sqfliteFfiInit();
    sqfliteFfiInit();
    databaseService = DatabaseService(databaseFactory: databaseFactoryFfi);
  } else {
    databaseService = DatabaseService(databaseFactory: databaseFactory);
  }

  // String path = await getDatabasesPath() + 'recipe_journal.db';
  // // Delete the database file completely
  // await deleteDatabase(path);
  
  RecipeRepository recipeRepository = RecipeRepository(database: databaseService);
  IngredientRepository ingredientRepository = IngredientRepository(database: databaseService);
  RecipeIngredientRepository recipeIngredientRepository = RecipeIngredientRepository(database: databaseService);

  // Delete tables

  // Seed ingredients
  final [eggId, riceId, steakId] = await Future.wait(["Egg", "Rice", "Steak"].map((ingredientString) async{
    var ingredient = await ingredientRepository.createIngredient(ingredientString);
    switch (ingredient) {
      case Ok<IngredientEntity>():
        return ingredient.value.id;
      case Error():
        print("Error");
    }
  }).toList());

  // Seed recipes
  final [eggAndRiceId, steakAndRiceId] = await Future.wait(["Egg and rice", "Steak and rice"].map((recipeString) async{
    var recipe = await recipeRepository.createRecipe(recipeString);
    switch (recipe) {
      case Ok<RecipeEntity>():
        return recipe.value.id;
      case Error():
        print("Error");
    }
  }).toList());

  // Seed recipe ingredients
  await recipeIngredientRepository.createRecipeIngredient(eggAndRiceId!, eggId!);
  await recipeIngredientRepository.createRecipeIngredient(eggAndRiceId!, riceId!);
  await recipeIngredientRepository.createRecipeIngredient(steakAndRiceId!, riceId!);
  await recipeIngredientRepository.createRecipeIngredient(steakAndRiceId!, steakId!);

  final recipes = await recipeRepository.fetchRecipes();
  print(await databaseFactoryFfi.getDatabasesPath()); // Get database path
}