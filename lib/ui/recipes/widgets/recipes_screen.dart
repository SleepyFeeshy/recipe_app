import 'package:flutter/material.dart';
import 'package:recipe_app/ui/recipes/widgets/create_recipe_page.dart';
import '../../recipes/widgets/recipe_list.dart';

class RecipesScreen extends StatefulWidget{ 
  const RecipesScreen({super.key});

  @override
  State<RecipesScreen> createState() => _RecipesScreenState();
}
class _RecipesScreenState extends State<RecipesScreen> {
  final GlobalKey<_RecipesScreenState> _formKey = GlobalKey<_RecipesScreenState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Recipes"),
      ),
      body: RecipesList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
            await Navigator.of(context, rootNavigator: true).push(
              MaterialPageRoute(
                builder: (context) => CreateRecipePage())
            );
          },    
        child: const Icon(Icons.add))
      );
  }
}