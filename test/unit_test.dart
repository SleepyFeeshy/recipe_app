import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:recipe_app/data/model/ingredient.dart';
import 'package:recipe_app/data/model/recipe.dart';
import 'package:recipe_app/data/model/recipe_ingredient.dart';
import 'package:recipe_app/data/model/shopping_list.dart';
import 'package:recipe_app/data/repositories/recipe_ingredient_repository.dart';
import 'package:recipe_app/data/repositories/shopping_list_repository.dart';
import 'package:recipe_app/domain/models/ingredient/ingredient.dart';
import 'package:recipe_app/domain/models/recipe/recipe.dart';
import 'package:recipe_app/domain/models/recipe_ingredient/recipe_ingredient.dart';
import 'package:recipe_app/domain/models/shopping_list/shopping_list.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'package:recipe_app/data/repositories/recipe_repository.dart';
import 'package:recipe_app/data/repositories/ingredient_repository.dart';
import 'package:recipe_app/data/services/local/database_service.dart';
import 'package:uuid/uuid.dart';
import 'package:recipe_app/utils/result.dart';
import 'package:test/test.dart';
var uuid = Uuid();

void main() async {
  late DatabaseService databaseService;
  late RecipeRepository recipeRepository;
  late IngredientRepository ingredientRepository;
  late RecipeIngredientRepository recipeIngredientRepository;
  late ShoppingListRepository shoppingListRepository;
  // String path = await getDatabasesPath() + 'recipe_journal.db';
  // // Delete the database file completely
  // await deleteDatabase(path);
  
  setUpAll(() async {
    // Fresh in-memory DB for every single test
    // Chrome has no SQLite functionality, can't access local files
    if (kIsWeb) {
      throw UnsupportedError('Platform not supported.');
    } else if (Platform.isLinux || Platform.isWindows || Platform.isMacOS) {
      // Initialize FFI SQLite
      // sqfliteFfiInit();
      sqfliteFfiInit();
      databaseService = DatabaseService(databaseFactory: databaseFactoryFfi, isTest: true);
    } else {
      databaseService = DatabaseService(databaseFactory: databaseFactory, isTest: true);
    }

    recipeRepository = RecipeRepository(database: databaseService);
    ingredientRepository = IngredientRepository(database: databaseService);
    recipeIngredientRepository = RecipeIngredientRepository(database: databaseService);
    shoppingListRepository = ShoppingListRepository(database: databaseService);
  });

  tearDownAll(() async {
      await databaseService.delete();
  });
  
  group('Ingredient insert', () {
    late String fishId;

    test('New ingredient is correctly inserted, returns object', () async {
      final result = await ingredientRepository.createIngredient("Fish");
      expect(result, isA<Ok>());
      final ingredient = (result as Ok<IngredientEntity>).value;
      fishId = ingredient.id ;

      expect(ingredient.name, "Fish"); 
      expect(ingredient.id, isNotEmpty);
    });

    test('Inserting existing ingredient returns the existing ingredient', () async {
      final result = await ingredientRepository.createIngredient("Fish");
      // print(result);
      expect(result, isA<Ok>());
      final ingredient = (result as Ok<IngredientEntity>).value;
      expect(ingredient.name, "Fish");
      expect(ingredient.id, fishId);
    });
  });

  group('Recipe insert', () {
    setUpAll(() async {
      await ingredientRepository.createIngredient("Fish");
      await ingredientRepository.createIngredient("Lettuce");

    });

    test('Create recipe', () async {
      final Recipe testRecipe = Recipe(id: '', name: 'Steak and eggs', 
        ingredients: [
          Ingredient(id: '', name: 'Steak'),
          Ingredient(id: '', name: 'Egg')
        ]
      );

      // Create recipe
      var recipeResult = await databaseService.insertRecipe("Steak and eggs");
      expect(recipeResult, isA<Ok<RecipeEntity>>());
      var recipe = (recipeResult as Ok<RecipeEntity>).value;

      // Create ingredients
      for (Ingredient ingredient in testRecipe.ingredients) {
        var ingredientResult = await databaseService.insertIngredient(ingredient.name);
        expect(ingredientResult, isA<Ok<IngredientEntity>>());
        var resultIngredientEntity = (ingredientResult as Ok<IngredientEntity>).value;
        var newRecipeIngredient = await databaseService.insertRecipeIngredient(resultIngredientEntity.id, recipe.id);
        expect(newRecipeIngredient, isA<Ok<RecipeIngredientEntity>>());
      }
    });

    test('Fetch newly created recipe', () async {
      final Result<List<Recipe>> fetchedRecipes = await recipeRepository.fetchRecipes();
      final List<Recipe> recipes = (fetchedRecipes as Ok<List<Recipe>>).value;
      expect(recipes[0].name, "Steak and eggs");
      expect(recipes[0].ingredients.length, 2);
    });

    test('Create recipe from object', () async {
      final Recipe testRecipe = Recipe(id: '', name: 'Steak and Fish', 
        ingredients: [
          Ingredient(id: '', name: 'Steak'),
          Ingredient(id: '', name: 'Fish')
        ]
      );

      final createFromObject = await recipeRepository.createRecipeFromObject(testRecipe);
      // print((createFromObject as Error<void>).error);
      expect(createFromObject, isA<Ok>());
      final Result<List<Recipe>> fetchedRecipes = await recipeRepository.fetchRecipes();
      final List<Recipe> recipes = (fetchedRecipes as Ok<List<Recipe>>).value;
      expect(recipes[1].name, "Steak and Fish");
    });
  });
  
  group('Shopping List insert', () {
    test('Create shopping list via databaseService', () async {
      final result = await databaseService.insertShoppingList("Test");
      expect(result, isA<Ok>());

      final delete = await databaseService.deleteShoppingList((result as Ok<ShoppingListEntity>).value.id);
      expect(delete, isA<Ok>());
    });

    test('Create shopping list via shoppingListRepository', () async {
      ShoppingList shoppingList = ShoppingList(id: "", name: "Test", createdAt: "");
      final result = await shoppingListRepository.createShoppingList(shoppingList);
      expect(result, isA<Ok>());
    });

    test('Create shopping list item via databaseService', () async {
      var ingredientResult = await databaseService.insertIngredient("Potato");
      var ingredientName = (ingredientResult as Ok<IngredientEntity>).value.name;
      var ingredientId = (ingredientResult as Ok<IngredientEntity>).value.id;
      expect(ingredientName, "Potato");

      var shoppingListResult = await databaseService.insertShoppingList("Shopping List");
      expect(shoppingListResult, isA<Ok>());
      var shoppingListid = (shoppingListResult as Ok<ShoppingListEntity>).value.id;      

      var shoppingItemResult = await databaseService.insertShoppingListItem(shoppingListid, ingredientId);
      expect(shoppingItemResult, isA<Ok>());
    });
  });
}

