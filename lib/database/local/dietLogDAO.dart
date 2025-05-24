import 'package:diabetes_tfg_app/database/local/databaseManager.dart';
import 'package:diabetes_tfg_app/models/dietLogModel.dart';
import 'package:intl/intl.dart';

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

  //getWeekLogs
  Future<List<DietLogModel>> getWeekLogs() async {
    final db = await insatnceDB.db;
    List<Map<String, dynamic>> data = await db.query('DietLogs',
        orderBy: 'time DESC',
        where: "date <= ? and date >= ?",
        whereArgs: [
          DateFormat("yyyy-MM-dd").format(DateTime.now()),
          DateFormat("yyyy-MM-dd")
              .format(DateTime.now().subtract(Duration(days: 7)))
        ]);

    List<DietLogModel> glucoseLogs = [];
    for (Map<String, dynamic> log in data) {
      glucoseLogs.add(DietLogModel.fromMap(log));
    }

    return glucoseLogs;
  }

  //getById
  Future<List<DietLogModel>> getById(String id) async {
    final db = await insatnceDB.db;
    List<Map<String, dynamic>> data =
        await db.query('DietLogs', where: "id = ?", whereArgs: [id]);

    List<DietLogModel> glucoseLogs = [];
    for (Map<String, dynamic> log in data) {
      glucoseLogs.add(DietLogModel.fromMap(log));
    }

    return glucoseLogs;
  }

  //getTodayLogs
  Future<List<DietLogModel>> getTodayLogs() async {
    final db = await insatnceDB.db;
    List<Map<String, dynamic>> data = await db.query('DietLogs',
        orderBy: 'time DESC',
        where: "date = ?",
        whereArgs: [DateFormat("yyyy-MM-dd").format(DateTime.now())]);

    List<DietLogModel> glucoseLogs = [];
    for (Map<String, dynamic> log in data) {
      glucoseLogs.add(DietLogModel.fromMap(log));
    }

    return glucoseLogs;
  }

  //getCustomDateRangeLogs
  Future<List<DietLogModel>> getCustomDateRangeLogs(
      String initial, String end) async {
    final db = await insatnceDB.db;
    List<Map<String, dynamic>> data = await db.query('DietLogs',
        orderBy: 'time DESC',
        where: "date >= ? and date <= ?",
        whereArgs: [initial, end]);

    List<DietLogModel> glucoseLogs = [];
    for (Map<String, dynamic> log in data) {
      glucoseLogs.add(DietLogModel.fromMap(log));
    }

    return glucoseLogs;
  }
}
