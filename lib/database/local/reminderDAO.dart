import 'package:diabetes_tfg_app/database/local/databaseManager.dart';
import 'package:diabetes_tfg_app/models/reminderModel.dart';
import 'package:intl/intl.dart';

class ReminderDAO {
  final insatnceDB = DatabaseManager.instance;

  //getAll
  Future<List<ReminderModel>> getAll() async {
    final db = await insatnceDB.db;
    List<Map<String, dynamic>> data =
        await db.query('Reminders', orderBy: 'date DESC');

    List<ReminderModel> reminders = [];
    for (Map<String, dynamic> log in data) {
      reminders.add(ReminderModel.fromMap(log));
    }

    return reminders;
  }

  //insert
  Future<int> insert(ReminderModel reminder) async {
    final db = await insatnceDB.db;
    int id = await db.insert('Reminders', reminder.toMap());

    return id;
  }

  //update
  Future<int> update(ReminderModel reminder) async {
    final db = await insatnceDB.db;
    int id = await db.update('Reminders', reminder.toMap(),
        where: 'id = ?', whereArgs: [reminder.id]);

    return id;
  }

  //delete
  Future<int> delete(ReminderModel reminder) async {
    final db = await insatnceDB.db;
    int id =
        await db.delete('Reminders', where: 'id = ?', whereArgs: [reminder.id]);

    return id;
  }

  //getWeekLogs
  Future<List<ReminderModel>> getWeekLogs() async {
    final db = await insatnceDB.db;
    List<Map<String, dynamic>> data = await db.query('Reminders',
        orderBy: 'time DESC',
        where: "date <= ? and date >= ?",
        whereArgs: [
          DateFormat("yyyy-MM-dd").format(DateTime.now()),
          DateFormat("yyyy-MM-dd")
              .format(DateTime.now().subtract(Duration(days: 7)))
        ]);

    List<ReminderModel> logs = [];
    for (Map<String, dynamic> log in data) {
      logs.add(ReminderModel.fromMap(log));
    }

    return logs;
  }

  //getWeekLogs
  Future<List<ReminderModel>> getByDay(String day) async {
    final db = await insatnceDB.db;
    List<Map<String, dynamic>> data = await db.query('Reminders',
        orderBy: 'time DESC', where: "date = ?", whereArgs: [day]);

    List<ReminderModel> logs = [];
    for (Map<String, dynamic> log in data) {
      logs.add(ReminderModel.fromMap(log));
    }

    return logs;
  }
}
