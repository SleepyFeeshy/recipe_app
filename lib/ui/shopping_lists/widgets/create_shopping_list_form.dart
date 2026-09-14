import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:recipe_app/domain/models/ingredient/ingredient.dart';
import 'package:recipe_app/domain/models/recipe/recipe.dart';
import 'package:recipe_app/domain/models/shopping_list/shopping_list.dart';
import 'package:recipe_app/ui/ingredients/view_models/ingredient_viewmodel.dart';
import 'package:recipe_app/ui/ingredients/widgets/ingredients_list.dart';
import 'package:recipe_app/ui/recipes/view_models/recipe_viewmodel.dart';
import 'package:recipe_app/ui/shopping_lists/view_models/shopping_list_viewmodel.dart';

class CreateShoppingListForm extends StatefulWidget{
  CreateShoppingListForm({super.key, required this.recipeViewModel, required this.ingredientViewModel, required this.shoppingListViewModel});

  final RecipeViewModel recipeViewModel;
  final IngredientViewModel ingredientViewModel;
  final ShoppingListViewModel shoppingListViewModel;

  @override
  State<CreateShoppingListForm> createState() => _CreateShoppingListFormState();
}

class _CreateShoppingListFormState extends State<CreateShoppingListForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  List<Ingredient> inputIngredients = [];
  List<Recipe> inputRecipes = [];
  late TextEditingController inputIngredientController;
  late TextEditingController shoppingListTitleController;

  final SearchController recipeSearchController = SearchController();
  final SearchController ingredientSearchController = SearchController();

  void _addIngredient(String inputIngredient) {
    setState(() {
      inputIngredients.add(Ingredient(id: "", name: inputIngredient));
    });
  }

  void _addRecipe(Recipe inputRecipe) {
    setState(() {
      inputRecipes.add(inputRecipe);
    });
  }

  @override
  void initState() {
    super.initState();
    inputIngredientController = TextEditingController();
    shoppingListTitleController = TextEditingController();
    // widget.recipeViewModel.add.addListener(_onAdd);
  }

  @override
  void dispose() {
    inputIngredientController.dispose();
    shoppingListTitleController.dispose();
    recipeSearchController.dispose();
    ingredientSearchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          TextFormField(
            controller: shoppingListTitleController,
            decoration: const InputDecoration(hintText: "Enter Shopping List Title"),
          ),
          Padding(
            padding: const .symmetric(vertical: 16.0),
            child:  ElevatedButton(
              onPressed: () async {
                  // print(shoppingListTitleController.text);
                  final shoppingList = ShoppingList(createdAt: "", id: "", name: shoppingListTitleController.text);
                  await widget.shoppingListViewModel.add.execute(shoppingList);
                  // print(inputIngredients.map((ingredient) {return ingredient.name;}));
                  // Navigator.of(context).pop();
                  // await widget.recipeViewModel.add.execute(Recipe(
                  //   id: "",
                  //   name: recipeTitleController.text,
                  //   ingredients: inputIngredients
                  // ));
                  // await widget.ingredientViewModel.load.execute();
                }
              , 
              child: const Text("Create Shopping List"))
          ),
          ListView(
            shrinkWrap: true,
            children: [
              // for (String ingredient in ["Egg", "Steak",])
              //   ListTile(
              //     title: Text(ingredient)),
              for (Ingredient ingredient in inputIngredients)
                ListTile(title: Text(ingredient.name)),
              SearchAnchor.bar(
                searchController: ingredientSearchController,
                // builder: (BuildContext context, SearchController recipeSearchController) {
                //   return IconButton(
                //     icon: const Icon(Icons.search),
                //     onPressed: () {
                //       recipeSearchController.openView();
                //     },
                //   );
                // }, 
                suggestionsBuilder: (BuildContext context, SearchController ingredientSearchController) {
                  return [for (Ingredient ingredient in widget.ingredientViewModel.ingredients)
                    ListTile(
                      title: Text(ingredient.name),
                      onTap: (){
                        setState(() {
                          // inputIngredients.addAll(recipe.ingredients);
                          _addIngredient(ingredient.name);
                          // ingredientSearchController.clear();
                          // ingredientSearchController.closeView(ingredient.name);
                          ingredientSearchController.closeView('');
                        });
                      }
                    )];
                }),
              Padding(
                padding: const .symmetric(vertical: 16.0),
                child: ElevatedButton(
                  onPressed: (){
                      _addIngredient(inputIngredientController.text);
                      inputIngredientController.clear();
                    }, 
                  child: const Text("Add ingredient"))
              )
            ],
          ),
          ListView(
            shrinkWrap: true,
            children: [
              // for (String ingredient in ["Egg", "Steak",])
              //   ListTile(
              //     title: Text(ingredient)),
              for (Recipe recipe in inputRecipes)
                ListTile(title: Text(recipe.name)),
              SearchAnchor.bar(
                searchController: recipeSearchController,
                // builder: (BuildContext context, SearchController recipeSearchController) {
                //   return IconButton(
                //     icon: const Icon(Icons.search),
                //     onPressed: () {
                //       recipeSearchController.openView();
                //     },
                //   );
                // }, 
                suggestionsBuilder: (BuildContext context, SearchController recipeSearchController) {
                  return [for (Recipe recipe in widget.recipeViewModel.recipes)
                    ListTile(
                      title: Text(recipe.name),
                      onTap: (){
                        setState(() {
                          inputIngredients.addAll(recipe.ingredients);
                          recipeSearchController.closeView(recipe.name);
                        });
                      }
                    )];
                }),
              Padding(
                padding: const .symmetric(vertical: 16.0),
                child: ElevatedButton(
                  onPressed: (){
                      // _addIngredient(inputIngredientController.text);
                      // inputIngredientController.clear();
                    }, 
                  child: const Text("Add recipe"))
              )
            ],
          )
        ],
      ),
    );
  } 
}