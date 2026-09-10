import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:recipe_app/ui/recipes/view_models/recipe_viewmodel.dart';
import 'package:recipe_app/ui/shopping_lists/view_models/shopping_list_viewmodel.dart';

class ShoppingListList extends StatelessWidget{
  ShoppingListList({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<RecipeViewModel, ShoppingListViewModel>(builder: (context, recipeViewModel, shoppingListViewModel, child) {
      return Text("Shopping List");

    });
  }
}