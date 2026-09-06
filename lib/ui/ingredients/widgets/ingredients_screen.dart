import 'package:flutter/material.dart';

import '../widgets/ingredients_list.dart';
class IngredientsScreen extends StatelessWidget {
  const IngredientsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Ingredients")),
      body: IngredientsList(),
    );
  }
}