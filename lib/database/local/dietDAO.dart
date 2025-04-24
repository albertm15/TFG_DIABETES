import 'package:diabetes_tfg_app/database/local/databaseManager.dart';
import 'package:diabetes_tfg_app/models/dietModel.dart';

class DietDAO {
  final insatnceDB = DatabaseManager.instance;

  //getAll
  Future<List<DietModel>> getAll() async {
    final db = await insatnceDB.db;
    List<Map<String, dynamic>> data = await db.query('Diets');

    List<DietModel> diets = [];
    for (Map<String, dynamic> log in data) {
      diets.add(DietModel.fromMap(log));
    }

    return diets;
  }

  //insert
  Future<int> insert(DietModel diet) async {
    final db = await insatnceDB.db;
    int id = await db.insert('Diets', diet.toMap());

    return id;
  }

  //update
  Future<int> update(DietModel diet) async {
    final db = await insatnceDB.db;
    int id = await db
        .update('Diets', diet.toMap(), where: 'id = ?', whereArgs: [diet.id]);

    return id;
  }

  //delete
  Future<int> delete(DietModel diet) async {
    final db = await insatnceDB.db;
    int id = await db.delete('Diets', where: 'id = ?', whereArgs: [diet.id]);

    return id;
  }
}
