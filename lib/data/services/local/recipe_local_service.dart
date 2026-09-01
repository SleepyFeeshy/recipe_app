import 'package:path/path.dart';
import 'package:recipe_app/domain/models/recipe/recipe.dart';
import 'package:sqflite/sqflite.dart';

class RecipeLocalService {
  // #docregion Table
  static const String _recipeTableName = 'recipes';
  static const String _idColumnName = '_id';
  static const String _recipeColumnName ='_recipe';
  // #endregion Table

  RecipeLocalService({required this.databaseFactory});

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
            'CREATE TABLE $_recipeTableName($_idColumnName INTEGER PRIMARY KEY AUTOINCREMENT, $_recipeColumnName TEXT)',
          );
        },
        version: 1
      ),
    );
  }
  // #enddocregion Open

  // #docregion Insert
  Future<void> insert(String recipe) async {
    try {
      final id = await _database!.insert(_recipeTableName, {
        _recipeColumnName: recipe
      });
    } on Exception catch (e) {
      print('Error inserting');
    }
  }
  // #enddocregion Insert

  // #docregion GetAll
  Future<List<Recipe>> getAll() async {
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
      return list;
    } on Exception catch (e) {
      print("Error getAll()");
      return [];
    }
  }
}