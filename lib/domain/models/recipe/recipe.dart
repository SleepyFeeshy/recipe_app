import '../recipe_ingredient/recipe_ingredient.dart';
import '../ingredient/ingredient.dart';

class Recipe{
  Recipe({required this.id, required this.name, required this.ingredients});
  // Recipe({required this.id, required this.name});

  final String id;
  final String name;
  final List<Ingredient> ingredients;
}

final egg = Ingredient(id: '23ccf8fc-0f77-447b-9a96-87060adff05c', name: 'Egg');
final rice = Ingredient(id: '17ec56c4-ca61-441d-8737-ba4202a4f4fb', name: 'Rice');
final steak = Ingredient(id: '9180a4ae-9b19-41d2-914e-f3a4b94671e6', name: 'Steak');

final riceAndEgg = Recipe(id: '4b75e160-97e8-489f-a056-95e7d7e9d5e4', name: 'Rice with egg', ingredients: [egg, rice]);
final riceAndSteak = Recipe(id: 'f48e3f86-0de5-4477-b06d-cccbec44d963', name: 'Rice with steak', ingredients: [steak, rice]);

final Set<Recipe> allSampleRecipes = {
  riceAndEgg,
  riceAndSteak
};