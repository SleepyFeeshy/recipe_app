import 'package:flutter/material.dart';
import 'routing/router.dart';

import 'package:provider/provider.dart';
import 'ui/recipes/view_models/recipe_viewmodel.dart';

import 'data/repositories/recipe_repository.dart';
import 'domain/models/recipe/recipe.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => RecipeViewModel())
      ],
      child: const MainApp()
    )
  );


}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  // This widget is the root of your application.
  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Recipe Journal',
      theme: ThemeData(
        colorScheme: .fromSeed(seedColor: Colors.deepPurple),
      ),
      routerConfig: router,
    );
  }
}