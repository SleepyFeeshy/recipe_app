class Recipe {
  Recipe({required this.name});

  final String name;  
}

final egg = Recipe(name: 'Egg');
final rice = Recipe(name: 'Rice');

final Set<Recipe> allRecipes = {
  egg,
  rice
};