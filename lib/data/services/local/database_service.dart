import 'package:path/path.dart';
import 'package:recipe_app/data/model/recipe.dart';
import 'package:sqflite/sqflite.dart';

import '../../../utils/result.dart';

class DatabaseService {
  // #docregion Table
  static const String _recipeTableName = 'recipes';
  static const String _idColumnName = '_id';
  static const String _recipeColumnName ='_recipe';
  // #endregion Table

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
              $_idColumnName INTEGER PRIMARY KEY AUTOINCREMENT, 
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
  Future<Result<Recipe>> insert(String recipe) async {
    try {
      final id = await _database!.insert(_recipeTableName, {
        _recipeColumnName: recipe
      });
      return Result.ok(Recipe(id: id, name: recipe));
    } on Exception catch (e) {
      return Result.error(e);
    }
  }
  // #enddocregion Insert

  // #docregion GetAll
  Future<Result<List<Recipe>>> getAll() async {
    try {
      final entries = await _database!.query(
        _recipeTableName, columns: [_idColumnName, _recipeColumnName],
      );
      final list = entries
        .map(
          (element) => Recipe(
            id: element[_idColumnName] as int,
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