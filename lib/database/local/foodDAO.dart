import 'package:diabetes_tfg_app/database/local/databaseManager.dart';
import 'package:diabetes_tfg_app/models/foodModel.dart';

class FoodDAO {
  final insatnceDB = DatabaseManager.instance;

  //getAll
  Future<List<FoodModel>> getAll() async {
    final db = await insatnceDB.db;
    List<Map<String, dynamic>> data = await db.query('Foods');

    List<FoodModel> foods = [];
    for (Map<String, dynamic> log in data) {
      foods.add(FoodModel.fromMap(log));
    }

    return foods;
  }

  //insert
  Future<int> insert(FoodModel food) async {
    final db = await insatnceDB.db;
    int id = await db.insert('Foods', food.toMap());

    return id;
  }

  //update
  Future<int> update(FoodModel food) async {
    final db = await insatnceDB.db;
    int id = await db
        .update('Foods', food.toMap(), where: 'id = ?', whereArgs: [food.id]);

    return id;
  }

  //delete
  Future<int> delete(FoodModel food) async {
    final db = await insatnceDB.db;
    int id = await db.delete('Foods', where: 'id = ?', whereArgs: [food.id]);

    return id;
  }

  //getById
  Future<List<FoodModel>> getById(String id) async {
    final db = await insatnceDB.db;
    List<Map<String, dynamic>> data =
        await db.query('Foods', where: "id = ?", whereArgs: [id]);

    List<FoodModel> glucoseLogs = [];
    for (Map<String, dynamic> log in data) {
      glucoseLogs.add(FoodModel.fromMap(log));
    }

    return glucoseLogs;
  }
}
