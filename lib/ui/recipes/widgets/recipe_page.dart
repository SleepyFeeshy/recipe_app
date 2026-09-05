import 'package:flutter/material.dart';
import 'package:recipe_app/domain/models/ingredient/ingredient.dart';
import '../../../domain/models/recipe/recipe.dart';

class RecipePage extends StatelessWidget {
  RecipePage({super.key, required this.recipe});

  final Recipe recipe;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(recipe.name)
      ),
      body: Column(
        children: [
          Text("Ingredients"),
          for (Ingredient ingredient in recipe.ingredients) 
            Text(ingredient.name)
        ],
      )
    );
  }
}