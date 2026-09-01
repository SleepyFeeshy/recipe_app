import '../../domain/models/recipe/recipe.dart';
import '../services/local/recipe_local_service.dart';

class RecipeRepository {
    RecipeRepository({required this._recipeLocalDatabase});

    final RecipeLocalService _recipeLocalDatabase;

    Future<List<Recipe>> fetchRecipes() async {
        if (!_recipeLocalDatabase.isOpen()) {
            await _recipeLocalDatabase.open();
        }
        return _recipeLocalDatabase.getAll();
    }
}