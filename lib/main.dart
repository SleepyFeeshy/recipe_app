import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'routing/router.dart';

import 'package:provider/provider.dart';
import 'ui/recipes/view_models/recipe_viewmodel.dart';

import 'data/repositories/recipe_repository.dart';
import 'data/services/local/database_service.dart';

import 'domain/models/recipe/recipe.dart';



void main() {
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
  RecipeRepository recipeRepository = RecipeRepository(database: databaseService);
  // recipeRepository.seedRecipes(['Egg', 'Rice']);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => RecipeViewModel(recipeRepository: recipeRepository))
      ],
      child: MainApp(
        recipeRepository: RecipeRepository(database: databaseService)
      )
    )
  );
}

class MainApp extends StatefulWidget {
  const MainApp({super.key, required this.recipeRepository});
  final RecipeRepository recipeRepository;

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
      theme: ThemeData(
        colorScheme: .fromSeed(seedColor: Colors.deepPurple),
      ),
      routerConfig: router,
    );
  }
}