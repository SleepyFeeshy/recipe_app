import 'package:path/path.dart';
import 'package:recipe_app/data/model/recipe.dart';
import 'package:sqflite/sqflite.dart';

import '../../../utils/result.dart';

class DatabaseService {
  // #docregion Recipes Table
  static const String _recipeTableName = 'recipes';
  static const String _recipeIdColumnName = '_id';
  static const String _recipeColumnName ='_recipe';
  // #endregion Recipes Table

  // #docregion Ingredients Table
  static const String _ingredientTableName = 'ingredients';
  static const String _ingredientIdColumnName = '_id';
  static const String _ingredientColumnName ='_ingredient';
  // #endregion Ingredients Table

  DatabaseService({required this.databaseFactory});

  final DatabaseFactory databaseFactory;

  Database? _database;

  bool isOpen() => _database != null;

  // #docregion Open
  Future<void> open() async {
    _database = await databaseFactory.openDatabase(
      join(await databaseFactory.getDatabasesPath(), 'recipe_journal.db'),
      options: OpenDatabaseOptions(
        onCreate: (db, version) {
          return db.execute(
            '''
            CREATE TABLE $_recipeTableName(
              $_recipeIdColumnName INTEGER PRIMARY KEY AUTOINCREMENT, 
              $_recipeColumnName TEXT
            )''',
          );
        },
        version: 1
      ),
    );
  }
  // #enddocregion Open

  // #docregion Insert
  Future<Result<RecipeEntity>> insert(String recipe) async {
    try {
      final id = await _database!.insert(_recipeTableName, {
        _recipeColumnName: recipe
      });
      return Result.ok(RecipeEntity(id: id, name: recipe));
    } on Exception catch (e) {
      return Result.error(e);
    }
  }
  // #enddocregion Insert

  // #docregion GetAll
  Future<Result<List<RecipeEntity>>> getAll() async {
    try {
      final entries = await _database!.query(
        _recipeTableName, columns: [_recipeIdColumnName, _recipeColumnName],
      );
      final list = entries
        .map(
          (element) => RecipeEntity(
            id: element[_recipeIdColumnName] as int,
            name: element[_recipeColumnName] as String,
          ),
        )
        .toList();
      return Result.ok(list);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }
}