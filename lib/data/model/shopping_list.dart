class ShoppingListEntity {
  ShoppingListEntity({required this.id, required this.name, required this.createdAt});

  final String id;  
  final String name;
  final String createdAt;
}

class FullShoppingListEntity {
  FullShoppingListEntity({required this.id, required this.shoppingListId, required this.name, required this.createdAt, required this.ingredientId, required this.ingredientName});

  final String id;  
  final String shoppingListId;
  final String name;
  final String createdAt;

  final String ingredientId;
  final String ingredientName;
}