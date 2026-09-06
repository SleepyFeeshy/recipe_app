import 'package:flutter/material.dart';
import '../widgets/create_recipe_form.dart';

class CreateRecipePage extends StatelessWidget{
  CreateRecipePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create Recipe")
      ),
      body: CreateRecipeForm()
    );
  }
}