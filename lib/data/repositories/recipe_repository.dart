import '../model/recipe.dart';
import '../services/local/database_service.dart';
import '../../utils/result.dart';
class RecipeRepository {
    RecipeRepository({required this._database});

    final DatabaseService _database;

    Future<Result<List<Recipe>>> fetchRecipes() async {
        if (!_database.isOpen()) {
            await _database.open();
        }
        return _database.getAll();
    }

    Future<Result<Recipe>> createRecipe(String recipe) async {
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