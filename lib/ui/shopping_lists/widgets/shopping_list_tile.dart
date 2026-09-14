import 'package:flutter/material.dart';
import 'package:recipe_app/domain/models/shopping_list/shopping_list.dart';
import 'package:recipe_app/ui/shopping_lists/widgets/shopping_list_info_page.dart';
import 'package:recipe_app/ui/shopping_lists/widgets/shopping_lists_page.dart';

class ShoppingListTile extends StatelessWidget {
  ShoppingListTile({super.key, required this.shoppingList});

  final ShoppingList shoppingList;

  @override
  Widget build(BuildContext context) {
    return Card(
     child: InkWell(
      onTap: () {
        Navigator.of(context , rootNavigator: true).push(
          MaterialPageRoute(builder: (context) {
            return ShoppingListInfoPage(shoppingList: shoppingList);
          })
        );
      },
      child: ListTile(
        title: Text(shoppingList.name)
      )
     ) 
    );
  }
}