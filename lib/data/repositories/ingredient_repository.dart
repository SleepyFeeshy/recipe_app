import 'dart:io';

import 'package:recipe_app/data/model/ingredient.dart';
import 'package:recipe_app/data/model/recipe.dart';

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
}