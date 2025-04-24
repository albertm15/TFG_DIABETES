import 'package:diabetes_tfg_app/database/local/databaseManager.dart';
import 'package:diabetes_tfg_app/models/dietLogModel.dart';

class DietLogDAO {
  final insatnceDB = DatabaseManager.instance;

  //getAll
  Future<List<DietLogModel>> getAll() async {
    final db = await insatnceDB.db;
    List<Map<String, dynamic>> data =
        await db.query('DietLogs', orderBy: 'date DESC');

    List<DietLogModel> dietLogs = [];
    for (Map<String, dynamic> log in data) {
      dietLogs.add(DietLogModel.fromMap(log));
    }

    return dietLogs;
  }

  //insert
  Future<int> insert(DietLogModel dietLog) async {
    final db = await insatnceDB.db;
    int id = await db.insert('DietLogs', dietLog.toMap());

    return id;
  }

  //update
  Future<int> update(DietLogModel dietLog) async {
    final db = await insatnceDB.db;
    int id = await db.update('DietLogs', dietLog.toMap(),
        where: 'id = ?', whereArgs: [dietLog.id]);

    return id;
  }

  //delete
  Future<int> delete(DietLogModel dietLog) async {
    final db = await insatnceDB.db;
    int id =
        await db.delete('DietLogs', where: 'id = ?', whereArgs: [dietLog.id]);

    return id;
  }
}
