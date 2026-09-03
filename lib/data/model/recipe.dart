import 'ingredient.dart';

class Recipe {
  Recipe({required this.id, required this.name});

  final int id;  
  final String name;
}

final egg = Recipe(id: 1, name: 'Egg');
final rice = Recipe(id: 2, name: 'Rice');

final Set<Recipe> allRecipes = {
  egg,
  rice
};