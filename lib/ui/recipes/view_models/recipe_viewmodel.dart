import 'dart:async';

import 'package:flutter/material.dart';

import '../../../domain/models/recipe/recipe.dart';

List<Recipe> generateSeedData() {
  return allRecipes.toList();
}

// ViewModel of Recipe
class RecipeViewModel extends ChangeNotifier {
  // Repository placeholder
  RecipeViewModel() : _recipesNotifier = ValueNotifier(generateSeedData());
  final ValueNotifier<List<Recipe>> _recipesNotifier;
  List<Recipe> get recipes => _recipesNotifier.value;

  void dispose() {
    _recipesNotifier.dispose();
  }
}