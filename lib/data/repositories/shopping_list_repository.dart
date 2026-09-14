import 'package:recipe_app/data/model/shopping_list.dart';
import 'package:recipe_app/domain/models/shopping_list/shopping_list.dart';
import 'package:recipe_app/utils/result.dart';

import '../services/local/database_service.dart';

class ShoppingListRepository {
  ShoppingListRepository({required this._database});

  final DatabaseService _database;

  Future<Result<List<ShoppingList>>> fetchShoppingLists() async {
    if (!_database.isOpen()) {
      await _database.open();
    }

    final result = await _database.fetchShoppingLists();
    switch (result) {
      case Ok<List<ShoppingListEntity>>():
        var shoppingListEntities = result.value;
        var shoppingLists = shoppingListEntities.map((shoppingListEntity) {
          return ShoppingList(id: shoppingListEntity.id, name: shoppingListEntity.name, createdAt: shoppingListEntity.createdAt);
        }).toList();
        return Result.ok(shoppingLists);
      case Error():
        return Result.error(result.error);
    }
  }

  Future<Result<ShoppingList>> createShoppingList(ShoppingList shoppingList) async {
    if (!_database.isOpen()) {
      await _database.open();
    }

    ShoppingListEntity shoppingListEntity;

    final result = await _database.insertShoppingList(shoppingList.name);
    switch (result) {
      case Ok<ShoppingListEntity>():
        shoppingListEntity = result.value;
        return Result.ok(ShoppingList(createdAt: shoppingListEntity.createdAt, name: shoppingListEntity.name, id: shoppingListEntity.id));
      case Error():
        return Result.error(result.error);
    }
  }
}