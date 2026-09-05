import 'package:path/path.dart';
import 'package:recipe_app/data/model/ingredient.dart';
import 'package:recipe_app/data/model/recipe.dart';
import 'package:recipe_app/data/model/recipe_ingredient.dart';
import 'package:recipe_app/domain/models/recipe_ingredient/recipe_ingredient.dart';
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

  // #docregion Open Database
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
  // #enddocregion Open Database

  // #docregion Insert Recipe
  Future<Result<RecipeEntity>> insertRecipe(String recipe) async {
    try {
      final String id =  uuid.v4();
      await _database!.insert(_recipeTableName, {
        _recipeIdColumnName: id,
        _recipeColumnName: recipe
      });
      return Result.ok(RecipeEntity(id: id, name: recipe));
    } on Exception catch (e) {
      return Result.error(e);
    }
  }
  // #enddocregion Insert Recipe

  // #docregion GetAll Recipes
  Future<Result<List<RecipeEntity>>> getAllRecipes() async {
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
  // #enddocregion GetAll Recipes

  // #docregion Create Ingredient
  Future<Result<IngredientEntity>> insertIngredient(String ingredient) async {
    try {
      final String id =  uuid.v4();
      await _database!.insert(_ingredientTableName, {
        _ingredientIdColumnName: id,
        _ingredientColumnName: ingredient
      });
      return Result.ok(IngredientEntity(id: id, name: ingredient));
    } on Exception catch (e) {
      return Result.error(e);
    }
  }
  // #enddocregion Create Ingredient

  // #docregion Create RecipeIngredient
  Future<Result<RecipeIngredientEntity>> insertRecipeIngredient(String ingredientId, String recipeId) async {
    try {
      final String id =  uuid.v4();
      await _database!.insert(_recipeIngredientTableName, {
        _recipeIngredientIdColumnName: id,
        _recipeFkIdColumnName: recipeId,
        _ingredientFkIdColumnName: ingredientId
      });
      return Result.ok(RecipeIngredientEntity(id: id, ingredientId: ingredientId, recipeId: recipeId));
    } on Exception catch (e) {
      return Result.error(e);
    }
  }
  // #enddocregion Create Ingredient

  // #docregion Fetch Ingredients with Recipe ID
  
  // #enddocregion Fetch Ingredients with Recipe ID
}