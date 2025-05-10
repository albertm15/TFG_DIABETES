import 'package:diabetes_tfg_app/database/local/databaseManager.dart';
import 'package:diabetes_tfg_app/models/InsulinLogModel.dart';
import 'package:intl/intl.dart';

class InsulinLogDAO {
  final insatnceDB = DatabaseManager.instance;

  //getAll
  Future<List<InsulinLogModel>> getAll() async {
    final db = await insatnceDB.db;
    List<Map<String, dynamic>> data =
        await db.query('InsulinLogs', orderBy: 'date DESC');

    List<InsulinLogModel> insulinLogs = [];
    for (Map<String, dynamic> log in data) {
      insulinLogs.add(InsulinLogModel.fromMap(log));
    }

    return insulinLogs;
  }

  //insert
  Future<int> insert(InsulinLogModel insulinLog) async {
    final db = await insatnceDB.db;
    int id = await db.insert('InsulinLogs', insulinLog.toMap());

    return id;
  }

  //update
  Future<int> update(InsulinLogModel insulinLog) async {
    final db = await insatnceDB.db;
    int id = await db.update('InsulinLogs', insulinLog.toMap(),
        where: 'id = ?', whereArgs: [insulinLog.id]);

    return id;
  }

  //delete
  Future<int> delete(InsulinLogModel insulinLog) async {
    final db = await insatnceDB.db;
    int id = await db
        .delete('InsulinLogs', where: 'id = ?', whereArgs: [insulinLog.id]);

    return id;
  }

  //getWeekLogs
  Future<List<InsulinLogModel>> getWeekLogs() async {
    final db = await insatnceDB.db;
    List<Map<String, dynamic>> data = await db.query('InsulinLogs',
        orderBy: 'time DESC',
        where: "date <= ? and date >= ?",
        whereArgs: [
          DateFormat("yyyy-MM-dd").format(DateTime.now()),
          DateFormat("yyyy-MM-dd")
              .format(DateTime.now().subtract(Duration(days: 7)))
        ]);

    List<InsulinLogModel> glucoseLogs = [];
    for (Map<String, dynamic> log in data) {
      glucoseLogs.add(InsulinLogModel.fromMap(log));
    }

    return glucoseLogs;
  }

  //getById
  Future<List<InsulinLogModel>> getById(String id) async {
    final db = await insatnceDB.db;
    List<Map<String, dynamic>> data =
        await db.query('InsulinLogs', where: "id = ?", whereArgs: [id]);

    List<InsulinLogModel> glucoseLogs = [];
    for (Map<String, dynamic> log in data) {
      glucoseLogs.add(InsulinLogModel.fromMap(log));
    }

    return glucoseLogs;
  }
}
