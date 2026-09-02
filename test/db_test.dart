import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'package:recipe_app/data/repositories/recipe_repository.dart';
import 'package:recipe_app/data/services/local/database_service.dart';

void main() async {
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
  final recipes = await recipeRepository.fetchRecipes();
  print(await databaseFactoryFfi.getDatabasesPath()); // Get database path
}