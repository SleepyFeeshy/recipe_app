import 'package:flutter/material.dart';
import 'package:recipe_app/data/repositories/recipe_repository.dart';
import 'package:recipe_app/domain/models/ingredient/ingredient.dart';
import 'package:recipe_app/ui/ingredients/view_models/ingredient_viewmodel.dart';
import 'package:recipe_app/ui/recipes/view_models/recipe_viewmodel.dart';
import 'package:provider/provider.dart';

import '../../../domain/models/recipe/recipe.dart';
class CreateRecipeForm extends StatefulWidget{
  CreateRecipeForm({super.key, required this.recipeViewModel, required this.ingredientViewModel});

   final RecipeViewModel recipeViewModel;
   final IngredientViewModel ingredientViewModel;

  @override
  State<CreateRecipeForm> createState() => _CreateRecipeFormState();
}

class _CreateRecipeFormState extends State<CreateRecipeForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  List<Ingredient> inputIngredients = [];
  late TextEditingController inputIngredientController;
  late TextEditingController recipeTitleController;

  void _addIngredient(String ingredient) {
    setState(() {
      inputIngredients.add(Ingredient(id: "", name: ingredient));
    });
  }

  @override
  void initState() {
    super.initState();
    inputIngredientController = TextEditingController();
    recipeTitleController = TextEditingController();
    // widget.recipeViewModel.add.addListener(_onAdd);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: <Widget>[
          TextFormField(
            controller: recipeTitleController,
            decoration: const InputDecoration(hintText: 'Enter recipe title')
          ),
          Padding(
            padding: const .symmetric(vertical: 16.0),
            child:  ElevatedButton(
              onPressed: () async {
                  await widget.recipeViewModel.add.execute(Recipe(
                    id: "",
                    name: recipeTitleController.text,
                    ingredients: inputIngredients
                  ));
                  await widget.ingredientViewModel.load.execute();
                }
              , 
              child: const Text("Create Recipe"))
            
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
          )
        ]
      )
    );
  }
}