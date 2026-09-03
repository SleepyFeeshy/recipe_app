// import '../model/recipe.dart';
import 'package:recipe_app/data/model/recipe.dart';

import '../../domain/models/recipe/recipe.dart';
import '../services/local/database_service.dart';
import '../../utils/result.dart';
class RecipeRepository {
    RecipeRepository({required this._database});

    final DatabaseService _database;

    Future<List<Recipe>> fetchRecipes() async {
      final Result<List<RecipeEntity>> result;
      List<Recipe> recipes = [];
      if (!_database.isOpen()) {
          await _database.open();
      }

      result = await _database.getAll();
      switch (result) {
        case Ok<List<RecipeEntity>>():
          recipes = result.value.map((recipeEntity) {
              return Recipe(
                id: recipeEntity.id,
                name: recipeEntity.name
              );
            }
          ).toList();
          return recipes;
        case Error():
          print("error");
      }
      return [];
    }

    Future<Result<RecipeEntity>> createRecipe(String recipe) async {
        if (!_database.isOpen()) {
            await _database.open();
        }
        return _database.insert(recipe);
    }

    Future<void> seedRecipes(List recipes) async {
        if (!_database.isOpen()) {
            await _database.open();
        }
        for (Recipe recipe in recipes) {
            await _database.insert(recipe.name);
        }
    }
}