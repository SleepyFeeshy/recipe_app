import '../recipe_ingredient/recipe_ingredient.dart';

class Recipe{
  // Recipe({required this.id, required this.name, required this.ingredients});
  Recipe({required this.id, required this.name});

  final int id;
  final String name;
  // final List<RecipeIngredient> ingredients;
}

final egg = Recipe(id: 1, name: 'Egg');
final rice = Recipe(id: 2, name: 'Rice');

final Set<Recipe> allRecipes = {
  egg,
  rice
};