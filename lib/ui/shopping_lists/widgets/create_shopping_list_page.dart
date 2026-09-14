import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:recipe_app/ui/ingredients/view_models/ingredient_viewmodel.dart';
import 'package:recipe_app/ui/recipes/view_models/recipe_viewmodel.dart';
import 'package:recipe_app/ui/shopping_lists/view_models/shopping_list_viewmodel.dart';
import 'package:recipe_app/ui/shopping_lists/widgets/create_shopping_list_form.dart';

class CreateShoppingListPage extends StatelessWidget{
  CreateShoppingListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create Shopping List"),
      ),
      body: Consumer3<RecipeViewModel, IngredientViewModel, ShoppingListViewModel>(builder: (context, recipeViewModel, ingredientViewModel, shoppingListViewmodel, child) {
        return CreateShoppingListForm(recipeViewModel: recipeViewModel, ingredientViewModel: ingredientViewModel, shoppingListViewModel: shoppingListViewmodel);
      }),
    );
  }
}