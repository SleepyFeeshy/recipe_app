import 'package:recipe_app/domain/models/ingredient/ingredient.dart';

class ShoppingListItem {
  ShoppingListItem({required this.id, required this.name, required this.ingredient, required this.createdAt});

  final String id;  
  final String name;
  final Ingredient ingredient;
  final String createdAt;
}