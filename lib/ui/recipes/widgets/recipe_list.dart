import 'package:flutter/material.dart';
import '../view_models/recipe_viewmodel.dart';

import 'package:provider/provider.dart';
import '../../../domain/models/recipe/recipe.dart';
import '../../../ui/recipes/widgets/recipe_card.dart';
import '../../../ui/recipes/widgets/recipe_page.dart';

class RecipesList extends StatefulWidget {
  const RecipesList({super.key});
  @override
  State<RecipesList> createState() => _RecipesListState();

}

class _RecipesListState extends State<RecipesList> {
  SearchController recipeSearchController = SearchController();

  @override
  void initState() {
    super.initState();
    // widget.recipeViewModel.add.addListener(_onAdd);
  }

  @override
  void dispose() {
    recipeSearchController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverFillRemaining(
          child: Consumer<RecipeViewModel>(
            builder: (context, recipeViewModel, child) {
              return ListView(
                children: [
                  SearchAnchor.bar(
                searchController: recipeSearchController,
                // builder: (BuildContext context, SearchController recipeSearchController) {
                //   return IconButton(
                //     icon: const Icon(Icons.search),
                //     onPressed: () {
                //       recipeSearchController.openView();
                //     },
                //   );
                // }, 
                suggestionsBuilder: (BuildContext context, SearchController recipeSearchController) {
                  return [for (Recipe recipe in recipeViewModel.recipes)
                    ListTile(
                      title: Text(recipe.name),
                      onTap: () async{
                        recipeSearchController.closeView('');
                        await Navigator.of(context, rootNavigator: true).push(
                            MaterialPageRoute(
                              builder: (context) => RecipePage(recipe: recipe))
                          );
                      }
                    )];
                }),
                  for (final Recipe recipe in recipeViewModel.recipes)
                  // for (final Recipe recipe in allSampleRecipes)
                    RecipeCard(recipe: recipe)]
              );
            }
          )
        )
      ],
    );
  }
}