import 'package:flutter/material.dart';
import 'package:recipe_app/ui/recipes/widgets/recipe_page.dart';
import '../../../domain/models/recipe/recipe.dart';

class RecipeCard extends StatelessWidget {
  const RecipeCard({super.key, required this.recipe});

  final Recipe recipe;

  @override
  Widget build(BuildContext context) {
    return Center (
      child: Card(
        child: InkWell(
          onTap: () async {
            await Navigator.of(context, rootNavigator: true).push(
              MaterialPageRoute(
                builder: (context) => RecipePage(recipe: recipe))
            );
          },
          splashColor: Colors.green.withAlpha(30),
          child: ListTile(
            title: Text(recipe.name)
          )
        ,)
      )
    );
  }
}