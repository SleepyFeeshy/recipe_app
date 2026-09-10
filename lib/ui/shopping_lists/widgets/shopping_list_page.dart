import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:recipe_app/ui/shopping_lists/widgets/shopping_list_list.dart';

class ShoppingListPage extends StatelessWidget {
  ShoppingListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Shopping Lists")),
      body: ShoppingListList()
    );
  }
}