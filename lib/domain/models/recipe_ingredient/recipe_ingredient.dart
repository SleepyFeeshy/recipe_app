class RecipeIngredient {
  RecipeIngredient({required this.id,  required this.recipeId, required this.ingredientId, required this.ingredientName });

  final String id;
  final String recipeId;
  final String ingredientId;
  final String ingredientName;
}

class FullRecipeIngredient {
  FullRecipeIngredient({required this.id,  required this.recipeId, required this.recipeName, required this.ingredientId, required this.ingredientName });

  final String id;
  final String recipeId;
  final String recipeName;
  final String ingredientId;
  final String ingredientName;
}