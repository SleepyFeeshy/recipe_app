import 'package:flutter/material.dart';
import 'package:recipe_app/data/repositories/recipe_repository.dart';
import 'package:recipe_app/ui/recipes/view_models/recipe_viewmodel.dart';

class CreateRecipeForm extends StatefulWidget{
  CreateRecipeForm({super.key});

  @override
  State<CreateRecipeForm> createState() => _CreateRecipeFormState();
}

class _CreateRecipeFormState extends State<CreateRecipeForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: <Widget>[
          TextFormField(
            decoration: const InputDecoration(hintText: 'Enter recipe title')
          ),
          Padding(
            padding: const .symmetric(vertical: 16.0),
            child: ElevatedButton(
              onPressed: (){}, 
              child: const Text("Create Recipe"))
          )
        ]
      )
    );
  }
}