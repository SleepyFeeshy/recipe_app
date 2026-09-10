import 'package:flutter/foundation.dart';
import 'package:recipe_app/data/repositories/shopping_list_repository.dart';
import 'package:recipe_app/domain/models/recipe/recipe.dart';
import 'package:recipe_app/domain/models/shopping_list/shopping_list.dart';
import 'package:recipe_app/utils/command.dart';
import 'package:recipe_app/utils/result.dart';

class ShoppingListViewModel extends ChangeNotifier{
    ShoppingListViewModel({required this._shoppingListRepository}) {
        load = Command0<void>(_load)..execute();
    }

    late Command0<void> load;

    final ShoppingListRepository _shoppingListRepository;

    List<ShoppingList> _shoppingLists = [];
    List<ShoppingList> get shoppingLists => _shoppingLists;

    Future<Result<void>> _load() async {
    try {
      final result = await _shoppingListRepository.fetchShoppingLists();
      switch (result) {
        case Ok<List<ShoppingList>>():
          _shoppingLists = result.value;
          return Result.ok(null);
        case Error():
          return Result.error(result.error);
      }
    } on Exception catch (e) {
      return Result.error(e);
    } finally {
      notifyListeners();
    }
  }
}