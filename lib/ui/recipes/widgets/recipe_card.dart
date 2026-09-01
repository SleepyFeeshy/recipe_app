import 'package:flutter/material.dart';

class RecipeCard extends StatelessWidget {
  const RecipeCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Center (
      child: Card(
        child: Column(children: [
          const Text("Egg")
        ],)
      )
    );
  }
}