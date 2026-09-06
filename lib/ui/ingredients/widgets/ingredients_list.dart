import 'package:flutter/material.dart';
import 'package:recipe_app/domain/models/ingredient/ingredient.dart';
import 'package:recipe_app/ui/ingredients/view_models/ingredient_viewmodel.dart';
import 'package:provider/provider.dart';
import '../view_models/ingredient_viewmodel.dart';

class IngredientsList extends StatelessWidget {
  const IngredientsList({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverFillRemaining(
          child: Consumer<IngredientViewModel>(
            builder: (context, ingredientViewModel, child) {
              return ListView(
                children: [
                  for (final Ingredient ingredient in ingredientViewModel.ingredients)
                  // for (final Recipe recipe in allSampleRecipes)
                    ListTile(
                      title: Text(ingredient.name),
                    )
                ]
              );
            }
          )
        )
      ],
    );
  }
}