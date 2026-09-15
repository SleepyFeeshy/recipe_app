import 'package:recipe_app/data/model/shopping_list.dart';
import 'package:recipe_app/domain/models/ingredient/ingredient.dart';
import 'package:recipe_app/domain/models/shopping_list/shopping_list.dart';
import 'package:recipe_app/domain/models/shopping_list/shopping_list_item.dart';
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
        // Fetch shopping list items
        var shoppingLists = shoppingListEntities.map((shoppingListEntity) {
          return ShoppingList(id: shoppingListEntity.id, name: shoppingListEntity.name, createdAt: shoppingListEntity.createdAt, shoppingListItems: []);
        }).toList();
        return Result.ok(shoppingLists);
      case Error():
        return Result.error(result.error);
    }
  }

  Future<Result<List<ShoppingList>>> fetchFullShoppingListData() async {
    if (!_database.isOpen()) {
      await _database.open();
    }

    final result = await _database.fetchFullShoppingListData();
    switch (result) {
      case Ok<List<FullShoppingListEntity>>():
        var shoppingListEntities = result.value;
        // Fetch shopping list items
        var shoppingLists = shoppingListEntities.map((shoppingListEntity) {
          return ShoppingList(id: shoppingListEntity.id, name: shoppingListEntity.name, createdAt: shoppingListEntity.createdAt, shoppingListItems: []);
        }).toList().toSet();
        var shoppingListData = shoppingLists.map((shoppingList) {
          var shoppingListItems = shoppingListEntities.toList().where((element) => element.id == shoppingList.id).map((shoppingListEntity) {
            return ShoppingListItem(
              id: "", 
              name: "", 
              ingredient: Ingredient(id: shoppingListEntity.ingredientId, name: shoppingListEntity.ingredientName), 
              createdAt: "");}).toList();
          return ShoppingList(id: shoppingList.id, name: shoppingList.name, createdAt: shoppingList.createdAt, shoppingListItems: shoppingListItems);
        }).toList();
        return Result.ok(shoppingListData);
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
        // Create shopping list items
        for (ShoppingListItem shoppingListItem in shoppingList.shoppingListItems) {
          // Insert shopping list item into database
          await _database.insertShoppingListItem(shoppingListEntity.id, shoppingListItem.ingredient.id);
        }
        return Result.ok(ShoppingList(createdAt: shoppingListEntity.createdAt, name: shoppingListEntity.name, id: shoppingListEntity.id, shoppingListItems: []));
      case Error():
        return Result.error(result.error);
    }
  }

  Future<Result<void>> deleteShoppingList(ShoppingList shoppingList) async {
    if (!_database.isOpen()) {
      await _database.open();
    }

    print(shoppingList.id);
    final result = await _database.deleteShoppingList(shoppingList.id);
    switch (result) {
      case Ok<void>():
        // shoppingListEntity = result.value;
        return Result.ok(null);
      case Error():
        return Result.error(result.error);
    }
  }
}