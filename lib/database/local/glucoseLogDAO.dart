import 'package:diabetes_tfg_app/database/local/databaseManager.dart';
import 'package:diabetes_tfg_app/models/gluoseLogModel.dart';

class GlucoseLogDAO {
  final insatnceDB = DatabaseManager.instance;

  //getAll
  Future<List<GlucoseLogModel>> getAll() async {
    final db = await insatnceDB.db;
    List<Map<String, dynamic>> data =
        await db.query('GlucoseLogs', orderBy: 'date DESC');

    List<GlucoseLogModel> glucoseLogs = [];
    for (Map<String, dynamic> log in data) {
      glucoseLogs.add(GlucoseLogModel.fromMap(log));
    }

    return glucoseLogs;
  }

  //insert
  Future<int> insert(GlucoseLogModel glucoseLog) async {
    final db = await insatnceDB.db;
    int id = await db.insert('GlucoseLogs', glucoseLog.toMap());

    return id;
  }

  //update
  Future<int> update(GlucoseLogModel glucoseLog) async {
    final db = await insatnceDB.db;
    int id = await db.update('GlucoseLogs', glucoseLog.toMap(),
        where: 'id = ?', whereArgs: [glucoseLog.id]);

    return id;
  }

  //delete
  Future<int> delete(GlucoseLogModel glucoseLog) async {
    final db = await insatnceDB.db;
    int id = await db
        .delete('GlucoseLogs', where: 'id = ?', whereArgs: [glucoseLog.id]);

    return id;
  }
}
