import '../recipe_ingredient/recipe_ingredient.dart';

class Recipe{
  // Recipe({required this.id, required this.name, required this.ingredients});
  Recipe({required this.id, required this.name});

  final String id;
  final String name;
  // final List<RecipeIngredient> ingredients;
}

final egg = Recipe(id: '23ccf8fc-0f77-447b-9a96-87060adff05c', name: 'Egg');
final rice = Recipe(id: '17ec56c4-ca61-441d-8737-ba4202a4f4fb', name: 'Rice');

final Set<Recipe> allRecipes = {
  egg,
  rice
};