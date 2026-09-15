import 'package:recipe_app/domain/models/shopping_list/shopping_list_item.dart';

class ShoppingList {
  ShoppingList({required this.id, required this.name, required this.createdAt, required this.shoppingListItems});

  final String id;  
  final String name;
  final String createdAt;
  final List<ShoppingListItem> shoppingListItems;
}