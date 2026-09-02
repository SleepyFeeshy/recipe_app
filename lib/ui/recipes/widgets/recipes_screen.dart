import 'package:flutter/material.dart';
import '../../recipes/widgets/recipe_list.dart';

class RecipesScreen extends StatelessWidget{
  const RecipesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RecipesList()
    );
  }
}