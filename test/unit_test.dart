import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:recipe_app/data/model/ingredient.dart';
import 'package:recipe_app/data/model/recipe.dart';
import 'package:recipe_app/data/repositories/recipe_ingredient_repository.dart';
import 'package:recipe_app/domain/models/ingredient/ingredient.dart';
import 'package:recipe_app/domain/models/recipe/recipe.dart';
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
  // String path = await getDatabasesPath() + 'recipe_journal.db';
  // // Delete the database file completely
  // await deleteDatabase(path);
  
  setUp(() async {
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
  });

  
  
  group('Ingredient insert', () {
    tearDownAll(() async {
      await databaseService.delete();
    });

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

    test('New recipe is created', () async {
      // create ingredients
      await ingredientRepository.createIngredient("Fish");
      await ingredientRepository.createIngredient("Lettuce");
    });
  });
}

