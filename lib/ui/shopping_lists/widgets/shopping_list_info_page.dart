import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipe_app/domain/models/shopping_list/shopping_list.dart';
import 'package:recipe_app/ui/shopping_lists/view_models/shopping_list_viewmodel.dart';

class ShoppingListInfoPage extends StatelessWidget{
  ShoppingListInfoPage({super.key, required this.shoppingList});

  final ShoppingList shoppingList;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(shoppingList.name),
        actions: [
          Consumer<ShoppingListViewModel>(builder: (context, shoppingListViewModel, child) {
            return IconButton(
              onPressed: () async{
                Navigator.of(context, rootNavigator: true).pop();
                await shoppingListViewModel.delete.execute(shoppingList);
              }, 
              icon: Icon(Icons.delete));
          })
        ],
      ),
      body: Text(shoppingList.name),
    );
  }
}