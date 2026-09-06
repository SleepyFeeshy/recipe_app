import 'package:flutter/material.dart';
import 'package:recipe_app/ui/recipes/widgets/create_recipe_page.dart';
import '../../recipes/widgets/recipe_list.dart';

class RecipesScreen extends StatelessWidget{
  const RecipesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Recipes"),
      ),
      body: RecipesList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
            await Navigator.of(context, rootNavigator: true).push(
              MaterialPageRoute(
                builder: (context) => CreateRecipePage())
            );
          },    
        child: const Icon(Icons.add))
      );
  }
}