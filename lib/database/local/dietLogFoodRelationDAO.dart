import 'package:diabetes_tfg_app/database/local/databaseManager.dart';
import 'package:diabetes_tfg_app/models/dietLogFoodRelationModel.dart';

class DietLogFoodRelationDAO {
  final insatnceDB = DatabaseManager.instance;

  //getAll
  Future<List<DietLogFoodRelationModel>> getAll() async {
    final db = await insatnceDB.db;
    List<Map<String, dynamic>> data = await db.query('DietFoodRelation');

    //añadir creation date para este modelo

    List<DietLogFoodRelationModel> foodRelations = [];
    for (Map<String, dynamic> log in data) {
      foodRelations.add(DietLogFoodRelationModel.fromMap(log));
    }

    return foodRelations;
  }

  //insert
  Future<int> insert(DietLogFoodRelationModel foodRelation) async {
    final db = await insatnceDB.db;
    int id = await db.insert('DietFoodRelation', foodRelation.toMap());

    return id;
  }

  //update
  Future<int> update(DietLogFoodRelationModel foodRelation) async {
    final db = await insatnceDB.db;
    int id = await db.update('DietFoodRelation', foodRelation.toMap(),
        where: 'id = ?', whereArgs: [foodRelation.id]);

    return id;
  }

  //delete
  Future<int> delete(DietLogFoodRelationModel foodRelation) async {
    final db = await insatnceDB.db;
    int id = await db.delete('DietFoodRelation',
        where: 'id = ?', whereArgs: [foodRelation.id]);

    return id;
  }

  //getById
  Future<List<DietLogFoodRelationModel>> getById(String id) async {
    final db = await insatnceDB.db;
    List<Map<String, dynamic>> data =
        await db.query('DietFoodRelation', where: "id = ?", whereArgs: [id]);

    List<DietLogFoodRelationModel> glucoseLogs = [];
    for (Map<String, dynamic> log in data) {
      glucoseLogs.add(DietLogFoodRelationModel.fromMap(log));
    }

    return glucoseLogs;
  }

  //getByDietLogId
  Future<List<DietLogFoodRelationModel>> getByDietLogId(String id) async {
    final db = await insatnceDB.db;
    List<Map<String, dynamic>> data = await db
        .query('DietFoodRelation', where: "dietLogId = ?", whereArgs: [id]);

    List<DietLogFoodRelationModel> glucoseLogs = [];
    for (Map<String, dynamic> log in data) {
      glucoseLogs.add(DietLogFoodRelationModel.fromMap(log));
    }

    return glucoseLogs;
  }
}
