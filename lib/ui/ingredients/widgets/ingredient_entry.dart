import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipe_app/domain/models/ingredient/ingredient.dart';
import 'package:recipe_app/ui/ingredients/view_models/ingredient_viewmodel.dart';

class IngredientEntry extends StatelessWidget {
  const IngredientEntry({super.key, required this.ingredient});

  final Ingredient ingredient;

  @override
  Widget build(BuildContext conetxt) {
    return ListTile(
            title: Text(ingredient.name),
            trailing: Consumer<IngredientViewModel>(builder: (context, ingredientViewModel, child) {
              return IconButton(
              onPressed: () async {
                await ingredientViewModel.delete.execute(ingredient);
              }, 
              icon: Icon(Icons.delete));
            })
          );
  }
}