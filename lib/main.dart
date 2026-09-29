import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:recipe_app/data/repositories/ingredient_repository.dart';
import 'package:recipe_app/data/repositories/recipe_ingredient_repository.dart';
import 'package:recipe_app/data/repositories/shopping_list_repository.dart';
import 'package:recipe_app/domain/models/recipe_ingredient/recipe_ingredient.dart';
import 'package:recipe_app/ui/ingredients/view_models/ingredient_viewmodel.dart';
import 'package:recipe_app/ui/shopping_lists/view_models/shopping_list_viewmodel.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'routing/router.dart';

import 'package:provider/provider.dart';
import 'ui/recipes/view_models/recipe_viewmodel.dart';

import 'data/repositories/recipe_repository.dart';
import 'data/services/local/database_service.dart';

import 'data/model/recipe.dart';

import 'package:flutter_localizations/flutter_localizations.dart'
    as flutter_localizations;




void main() {  
  runApp(
    MultiProvider(
      providers: [
        Provider(create: (context) {
          late DatabaseService databaseService;
          // Chrome has no SQLite functionality, can't access local files
          if (kIsWeb) {
            throw UnsupportedError('Platform not supported.');
          } else if (Platform.isLinux || Platform.isWindows || Platform.isMacOS) {
            // Initialize FFI SQLite
            // sqfliteFfiInit();
            sqfliteFfiInit();
            databaseService = DatabaseService(databaseFactory: databaseFactoryFfi);
          } else {
            databaseService = DatabaseService(databaseFactory: databaseFactory);
          }
          return databaseService;
        }),
        Provider(create: (context) => RecipeRepository(database: context.read())),
        Provider(create: (context) => RecipeIngredientRepository(database: context.read())),
        Provider(create: (context) => IngredientRepository(database: context.read())),
        Provider(create: (context) => ShoppingListRepository(database: context.read())),
        ChangeNotifierProvider(create: (context) => RecipeViewModel(recipeRepository: context.read(), recipeIngredientRepository: context.read())),
        ChangeNotifierProvider(create: (context) => IngredientViewModel(ingredientRepository: context.read())),
        ChangeNotifierProvider(create: (context) => ShoppingListViewModel(shoppingListRepository: context.read()))
      ],
      child: MainApp(),
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
  
  // @override initState() {
  //   super.initState();
  // }
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Recipe Journal',
      localizationsDelegates: flutter_localizations.GlobalMaterialLocalizations.delegates,
      supportedLocales: [
        Locale('en'), // English
        // Locale('es'), // Spanish
      ],
      theme: ThemeData(
        colorScheme: .fromSeed(seedColor: Colors.deepPurple),
      ),
      routerConfig: router,
    );
  }
}