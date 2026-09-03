import 'package:path/path.dart';
import 'package:recipe_app/data/model/recipe.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';
import '../../../utils/result.dart';

var uuid = Uuid();

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

  // #docregion Recipe Ingredients Table
  static const String _recipeIngredientTableName = 'recipe_ingredients';
  static const String _recipeIngredientIdColumnName = '_id';
  static const String _recipeIngredientColumnName ='_recipe_ingredient';
  static const String _recipeFkIdColumnName = '_recipe_id';
  static const String _ingredientFkIdColumnName = '_ingredient_id';
  static const String _quantity = '_ingredient_id';
  static const String _unit = '_ingredient_id';
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
        onCreate: (db, version) async {
          var batch = db.batch();
          batch.execute('''CREATE TABLE $_recipeTableName(
              $_recipeIdColumnName TEXT PRIMARY KEY, 
              $_recipeColumnName TEXT
            )''');

          batch.execute('''CREATE TABLE $_ingredientTableName(
            $_ingredientIdColumnName TEXT PRIMARY KEY,
            $_ingredientColumnName TEXT
          )''');

          batch.execute('''CREATE TABLE $_recipeIngredientTableName(
            $_recipeIngredientIdColumnName TEXT PRIMARY KEY,
            $_recipeIngredientColumnName TEXT,
            $_recipeFkIdColumnName TEXT,
            $_ingredientFkIdColumnName TEXT,
            FOREIGN KEY($_recipeFkIdColumnName) REFERENCES $_recipeTableName($_recipeIdColumnName),
            FOREIGN KEY($_ingredientFkIdColumnName) REFERENCES $_ingredientTableName($_ingredientIdColumnName)
          )''');
          await batch.commit();          
        },
        version: 1
      ),
    );
  }
  // #enddocregion Open

  // #docregion Insert
  Future<Result<RecipeEntity>> insert(String recipe) async {
    try {
      final String id =  uuid.v4();
      await _database!.insert(_recipeTableName, {
        _ingredientIdColumnName: id,
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
            id: element[_recipeIdColumnName] as String,
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