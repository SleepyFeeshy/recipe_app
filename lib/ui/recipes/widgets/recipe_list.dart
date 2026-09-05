import 'package:flutter/material.dart';
import '../view_models/recipe_viewmodel.dart';

import 'package:provider/provider.dart';
import '../../../domain/models/recipe/recipe.dart';
import '../../../ui/recipes/widgets/recipe_card.dart';

class RecipesList extends StatelessWidget {
  const RecipesList({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverFillRemaining(
          child: Consumer<RecipeViewModel>(
            builder: (context, recipeViewModel, child) {
              return ListView(
                children: [
                  // for (final Recipe recipe in recipeViewModel.recipes)
                  for (final Recipe recipe in allSampleRecipes)
                    RecipeCard(recipe: recipe)]
              );
            }
          )
        )
      ],
    );
  }
}