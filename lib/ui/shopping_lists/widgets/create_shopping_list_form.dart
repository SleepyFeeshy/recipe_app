import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:recipe_app/domain/models/ingredient/ingredient.dart';
import 'package:recipe_app/domain/models/recipe/recipe.dart';
import 'package:recipe_app/ui/recipes/view_models/recipe_viewmodel.dart';

class CreateShoppingListForm extends StatefulWidget{
  CreateShoppingListForm({super.key, required this.recipeViewModel});

  final RecipeViewModel recipeViewModel;
  
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
                  Navigator.of(context).pop();
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
              TextField(
                controller: inputIngredientController,
                decoration: const InputDecoration(hintText: "Enter ingredient"),
              ),
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