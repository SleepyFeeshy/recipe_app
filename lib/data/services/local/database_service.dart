import 'package:path/path.dart';
import 'package:recipe_app/data/model/ingredient.dart';
import 'package:recipe_app/data/model/recipe.dart';
import 'package:recipe_app/data/model/recipe_ingredient.dart';
import 'package:recipe_app/data/model/shopping_list.dart';
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

  // #docregion Shopping Lists Table
  static const String _shoppingListTableName = 'shopping_lists';
  static const String _shoppingListIdColumnName = '_id';
  static const String _shoppingListColumnName ="_shopping_list";
  static const String _shoppingListCreatedAtColumnName ='_created_at';
  // #endregion Shopping Lists Table

  // #docregion Shopping Items Table
  static const String _shoppingItemTableName = 'shopping_items';
  static const String _shoppingItemIdColumnName = '_id';
  static  const String _shoppingItemShoppingListIdColumnName =  "_shopping_list_id";
  static const String _shoppingItemIngredientIdColumnName ='_ingredient_id';
  // #endregion Shopping Lists Items Table

  DatabaseService({required this.databaseFactory, this.isTest = false});
  bool isTest;
  
  final DatabaseFactory databaseFactory;

  Database? _database;

  bool isOpen() => _database != null;

  // #docregion Open Database
  Future<void> open() async {
    String databasePath = isTest ? 'recipe_journal-test.db' : 'recipe_journal.db';
    _database = await databaseFactory.openDatabase(
      join(await databaseFactory.getDatabasesPath(), databasePath),
      options: OpenDatabaseOptions(
        onCreate: (db, version) async {
          var batch = db.batch();
          batch.execute('''CREATE TABLE $_recipeTableName(
              $_recipeIdColumnName TEXT PRIMARY KEY, 
              $_recipeColumnName TEXT NOT NULL
            )''');

          batch.execute('''CREATE TABLE $_ingredientTableName(
            $_ingredientIdColumnName TEXT PRIMARY KEY,
            $_ingredientColumnName TEXT NOT NULL,
            UNIQUE($_ingredientColumnName)
          )''');

          batch.execute('''CREATE TABLE $_recipeIngredientTableName(
            $_recipeIngredientIdColumnName TEXT PRIMARY KEY,
            $_recipeFkIdColumnName TEXT NOT NULL,
            $_ingredientFkIdColumnName TEXT NOT NULL,
            FOREIGN KEY($_recipeFkIdColumnName) REFERENCES $_recipeTableName($_recipeIdColumnName) ON DELETE CASCADE,
            FOREIGN KEY($_ingredientFkIdColumnName) REFERENCES $_ingredientTableName($_ingredientIdColumnName) ON DELETE CASCADE,
            UNIQUE ($_recipeFkIdColumnName, $_ingredientFkIdColumnName)
          )''');

          batch.execute('''CREATE TABLE $_shoppingListTableName(
            $_shoppingItemIdColumnName TEXT PRIMARY KEY,
            $_shoppingListColumnName TEXT NOT NULL,
            $_shoppingListCreatedAtColumnName TEXT NOT NULL
          )''');

          batch.execute('''CREATE TABLE $_shoppingItemTableName(
            $_shoppingItemIdColumnName TEXT PRIMARY KEY,
            $_shoppingItemShoppingListIdColumnName TEXT NOT NULL,
            $_ingredientFkIdColumnName TEXT NOT NULL,
            FOREIGN KEY($_shoppingItemShoppingListIdColumnName) REFERENCES $_shoppingListTableName($_shoppingListIdColumnName) ON DELETE CASCADE,
            FOREIGN KEY($_ingredientFkIdColumnName) REFERENCES $_ingredientTableName($_ingredientIdColumnName) ON DELETE CASCADE,
            UNIQUE ($_shoppingItemShoppingListIdColumnName, $_ingredientFkIdColumnName)
          )''');
          await batch.commit();          
        },
        version: 1
      ),
    );
  }
  // #enddocregion Open Database

  // #docregion delete Database
  Future<void> delete() async {
    String databaseFile = isTest ? 'recipe_journal-test.db' : 'recipe_journal.db';
    String databasePath = await databaseFactory.getDatabasesPath();
    print('deleting DB');
    await databaseFactory.deleteDatabase(join(databasePath, 'recipe_journal-test.db'));
  }
  // #enddocregion delete Database

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

  // #docregion Delete Recipe
  Future<Result<void>> deleteRecipe(String recipeId) async {
    try {
      final deletedRecipe = await _database!.delete(
        _recipeTableName, where: "$_recipeIdColumnName = ?", whereArgs: [recipeId],
      );
      return Result.ok(null);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }
  // #enddocregion Delete Recipe

  // #docregion Create Ingredient
  Future<Result<IngredientEntity>> insertIngredient(String ingredient) async {
    try {
      final String id =  uuid.v4();
      await _database!.insert(_ingredientTableName, {
          _ingredientIdColumnName: id,
          _ingredientColumnName: ingredient
        },
        conflictAlgorithm: ConflictAlgorithm.fail
      );
      return Result.ok(IngredientEntity(id: id, name: ingredient));
    } on DatabaseException catch (e) {
      if (e.isUniqueConstraintError()) {
        final fetchedIngredients = await _database!.query(_ingredientTableName,
          columns: [_ingredientColumnName, _ingredientIdColumnName],
          where: "LOWER($_ingredientColumnName) = ?",
          whereArgs: [ingredient.toLowerCase()],
          limit: 1
        );
        final list = fetchedIngredients
        .map(
          (element) => IngredientEntity(
            id: element[_ingredientIdColumnName] as String,
            name: element[_ingredientColumnName] as String,
          ),
        )
        .toList();
        return Result.ok(list[0]);
        // return Result.error(e);
      }
      return Result.error(e);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }
  // #enddocregion Create Ingredient

  // #docregion Delete Ingredient
  Future<Result<void>> deleteIngredient(String ingredientId) async {
    try {
      final deletedIngredient = await _database!.delete(
        _ingredientTableName, where: "$_ingredientIdColumnName = ?", whereArgs: [ingredientId],
      );
      return Result.ok(null);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }
  // #enddocregion Delete Ingredient

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

  // #docregion GetAll Ingredients
  Future<Result<List<IngredientEntity>>> getAllIngredients() async {
    try {
      final entries = await _database!.query(
        _ingredientTableName, columns: [_ingredientIdColumnName, _ingredientColumnName],
      );
      final list = entries
        .map(
          (element) => IngredientEntity(
            id: element[_ingredientIdColumnName] as String,
            name: element[_ingredientColumnName] as String,
          ),
        )
        .toList();
      return Result.ok(list);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }
  // #enddocregion GetAll Ingredients

  // #docregion Fetch Ingredients with Recipe ID
  Future<Result<List<IngredientEntity>>> fetchIngredientsWithRecipeId(String recipeId) async {
    try {
      final entries = await _database!.rawQuery(
        '''
          SELECT d._id, d._ingredient 
          FROM $_recipeIngredientTableName as t
          INNER JOIN $_ingredientTableName as d
          on t._ingredient_id = d._id
          WHERE t._recipe_id = $recipeId
        '''
      );
      final list = entries.map((element) {
        return IngredientEntity(
          id: element[_ingredientIdColumnName] as String,
          name: element[_ingredientColumnName] as String,
        );
      }).toList();
      return Result.ok(list);
    }
    on Exception catch (e) {
      return Result.error(e);
    }
  }
  // #enddocregion Fetch Ingredients with Recipe ID

  // #docregion Fetch Ingredients with Recipe ID
  Future<Result<List<FullRecipeIngredientEntity>>> fetchFullRecipeData() async {
    try {
      final entries = await _database!.rawQuery(
        '''
          SELECT ri.$_recipeIngredientIdColumnName, r.$_recipeColumnName, i.$_ingredientColumnName, r.$_recipeIdColumnName as recipeId, i.$_ingredientIdColumnName as ingredientId
          FROM $_recipeIngredientTableName as ri
          JOIN $_ingredientTableName as i
          ON ri._ingredient_id = i._id
          JOIN $_recipeTableName as r
          ON ri._recipe_id = r._id
        '''
      );
      final list = entries.map((element) {
        return FullRecipeIngredientEntity(
          id: element[_recipeIngredientIdColumnName] as String,
          recipeId: element["recipeId"] as String,
          recipeName: element[_recipeColumnName] as String,
          ingredientId: element["ingredientId"] as String,
          ingredientName: element[_ingredientColumnName] as String,
        );
      }).toList();
      return Result.ok(list);
    }
    on Exception catch (e) {
      return Result.error(e);
    }
  }
  // #enddocregion Fetch Ingredients with Recipe ID

  // #docregion Fetch Shopping Lists
  Future<Result<List<ShoppingListEntity>>> fetchShoppingLists() async {
    try {
      final entries = await _database!.query(
        _shoppingListTableName, columns: [_shoppingItemIdColumnName, _shoppingListColumnName, _shoppingListCreatedAtColumnName],
      );
      final list = entries
        .map(
          (element) => ShoppingListEntity(
            id: element[_shoppingItemIdColumnName] as String,
            name: element[_shoppingListColumnName] as String,
            createdAt: element[_shoppingListCreatedAtColumnName] as String
          ),
        )
        .toList();
      return Result.ok(list);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }
  // #enddocregion Fetch Shopping Lists

  // #docregion Create Shopping List
  Future<Result<ShoppingListEntity>> insertShoppingList(String title) async {
    final String id =  uuid.v4();
    try {
      await _database!.insert(_shoppingListTableName, {
        _shoppingListColumnName: title,
        _shoppingListIdColumnName: id,
        _shoppingListCreatedAtColumnName: ""
      });
      return Result.ok(ShoppingListEntity(createdAt: "", id: id, name: title));
    } on Exception catch(e) {
      return Result.error(e);
    }
  }
  // #enddocregion Create Shopping List

  // #docregion Delete Shopping List
  Future<Result<void>> deleteShoppingList(String shoppingListId) async {
    try {
      await _database!.delete(_shoppingListTableName, 
      where: "$_shoppingItemIdColumnName = ?",
      whereArgs: [shoppingListId]
      );
      return Result.ok(null);
    } on Exception catch(e) {
      return Result.error(e);
    }
  }
  // #enddocregion Delete Shopping List

  // #docregion Create Shopping List Item
  Future<Result<void>> insertShoppingListItem(String shoppingListId, String ingredientId) async {
    try {
      await _database!.insert(_shoppingItemTableName, {
          _shoppingItemIdColumnName: shoppingListId,
          _shoppingItemShoppingListIdColumnName: shoppingListId,
          _ingredientFkIdColumnName: ingredientId,
        }
      );
      return Result.ok(null);
    } on Exception catch(e) {
      return Result.error(e);
    }
  }

  // Future<Result<List<ShoppingListEntity>>> insertShoppingListItem(String shoppingListItem) async {
  //   try {
  //     await _database!.insert(
  //       _shoppingListTableName, {
  //         _shoppingItemIngredientIdColumnName
  //       })
  //   }
  // }
}