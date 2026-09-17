import 'package:flutter/material.dart';
import '../view_models/recipe_viewmodel.dart';

import 'package:provider/provider.dart';
import '../../../domain/models/recipe/recipe.dart';
import '../../../ui/recipes/widgets/recipe_card.dart';
import '../../../ui/recipes/widgets/recipe_page.dart';

class RecipesList extends StatefulWidget {
  const RecipesList({super.key, required this.recipeViewModel});
  final RecipeViewModel recipeViewModel;
  @override
  State<RecipesList> createState() => _RecipesListState();

}

class _RecipesListState extends State<RecipesList> {
  // SearchController recipeSearchController = SearchController();
  final TextEditingController recipeTextController = TextEditingController();
  List<Recipe> recipeList = [];

  @override
  void initState() {
    recipeList = widget.recipeViewModel.recipes;
    super.initState();
    // widget.recipeViewModel.add.addListener(_onAdd);
  }

  @override
  void dispose() {
    recipeTextController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverFillRemaining(
          child: ListView(
                children: [
                  TextField(
                    controller: recipeTextController,
                    onChanged: (string) {
                      setState(() {
                        recipeList = widget.recipeViewModel.recipes.where((recipe) => recipe.name.toLowerCase().contains(recipeTextController.text.toLowerCase())).toList();
                      });
                    },
                  ),
                  for (final Recipe recipe in recipeList)
                  // for (final Recipe recipe in allSampleRecipes)
                    RecipeCard(recipe: recipe)]
              )
        )
      ],
    );
  }
}