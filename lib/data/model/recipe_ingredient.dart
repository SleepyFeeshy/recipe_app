class RecipeIngredientEntity {
  RecipeIngredientEntity({required this.id, required this.ingredientId, required this.recipeId});

  final String id;
  final String ingredientId;
  final String recipeId;
}

class FullRecipeIngredientEntity {
  FullRecipeIngredientEntity({required this.id, required this.recipeId, required this.recipeName, required this.ingredientId, required this.ingredientName});

  final String id;
  final String recipeId;
  final String recipeName;
  final String ingredientId;
  final String ingredientName;

}