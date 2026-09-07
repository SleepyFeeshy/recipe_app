import 'package:flutter/material.dart';
import 'package:recipe_app/ui/ingredients/view_models/ingredient_viewmodel.dart';
import 'package:recipe_app/ui/recipes/view_models/recipe_viewmodel.dart';
import '../widgets/create_recipe_form.dart';
import 'package:provider/provider.dart';
class CreateRecipePage extends StatelessWidget{
  CreateRecipePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create Recipe")
      ),
      body: Consumer2<RecipeViewModel, IngredientViewModel>(
        builder: (context, recipeViewModel, ingredientViewModel, child) {
          return CreateRecipeForm(recipeViewModel: recipeViewModel, ingredientViewModel: ingredientViewModel);
        }
      )
    );
  }
}