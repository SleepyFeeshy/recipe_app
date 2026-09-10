import 'package:flutter/foundation.dart';
import 'package:recipe_app/data/repositories/shopping_list_repository.dart';

class ShoppingListViewModel extends ChangeNotifier{
    ShoppingListViewModel({required this._shoppingListRepository});

    final ShoppingListRepository _shoppingListRepository;
}