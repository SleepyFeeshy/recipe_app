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
  String recipeQuery = '';
  // late List<Recipe> recipeList = [];
  // final List<Recipe> recipeList = context.read<List<Recipe>>();

  @override
  void initState() {
    super.initState();
    recipeTextController.addListener(() => setState((){}));
    // widget.recipeViewModel.add.addListener(_onAdd);
  }

  void _onSearch() {
    setState(() {
      recipeQuery = recipeTextController.text;
    });
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
                  onChanged: (string){ _onSearch();},
                  decoration: 
                  InputDecoration(
                    hintText: "Search for a recipe",
                    suffixIcon: IconButton(
                      onPressed: () {
                        recipeTextController.clear();
                        _onSearch();
                      }, 
                      icon: Icon(Icons.clear))),
                ),
                for (final Recipe recipe in widget.recipeViewModel.recipes.where((recipe) {
                  return recipe.name.toLowerCase().contains(recipeQuery.toLowerCase());
                }))
                // for (final Recipe recipe in allSampleRecipes)
                  RecipeCard(recipe: recipe)]
            )
        )
      ],
    );
  }
}