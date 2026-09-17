import 'package:flutter/material.dart';
import 'package:recipe_app/domain/models/ingredient/ingredient.dart';
import '../../../domain/models/recipe/recipe.dart';
import '../view_models/recipe_viewmodel.dart';
import 'package:provider/provider.dart';

class RecipePage extends StatelessWidget {
  RecipePage({super.key, required this.recipe});

  final Recipe recipe;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(recipe.name),
        actions: [
          Consumer<RecipeViewModel>(
          builder: (context, recipeViewModel, child) { return IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () async {
              Navigator.of(context).pop();
              await recipeViewModel.delete.execute(recipe);
            },);})
        ]
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        textDirection: TextDirection.ltr,
        children: [
          ListView(
            shrinkWrap: true,
            children: [
              Text("Ingredients", textAlign: TextAlign.left,),
              for (Ingredient ingredient in recipe.ingredients) 
              ListTile(
                title: Text(ingredient.name),
              )
            ],
          )
          
        ],
      )
    );
  }
}