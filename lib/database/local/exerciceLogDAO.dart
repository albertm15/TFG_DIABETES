import 'package:diabetes_tfg_app/database/local/databaseManager.dart';
import 'package:diabetes_tfg_app/models/exerciceLogModel.dart';

class ExerciceLogDAO {
  final insatnceDB = DatabaseManager.instance;

  //getAll
  Future<List<ExerciceLogModel>> getAll() async {
    final db = await insatnceDB.db;
    List<Map<String, dynamic>> data =
        await db.query('ExerciceLogs', orderBy: 'date DESC');

    List<ExerciceLogModel> exerciceLogs = [];
    for (Map<String, dynamic> log in data) {
      exerciceLogs.add(ExerciceLogModel.fromMap(log));
    }

    return exerciceLogs;
  }

  //insert
  Future<int> insert(ExerciceLogModel exerciceLog) async {
    final db = await insatnceDB.db;
    int id = await db.insert('ExerciceLogs', exerciceLog.toMap());

    return id;
  }

  //update
  Future<int> update(ExerciceLogModel exerciceLog) async {
    final db = await insatnceDB.db;
    int id = await db.update('ExerciceLogs', exerciceLog.toMap(),
        where: 'id = ?', whereArgs: [exerciceLog.id]);

    return id;
  }

  //delete
  Future<int> delete(ExerciceLogModel exerciceLog) async {
    final db = await insatnceDB.db;
    int id = await db
        .delete('ExerciceLogs', where: 'id = ?', whereArgs: [exerciceLog.id]);

    return id;
  }
}
