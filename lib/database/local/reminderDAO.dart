import 'package:diabetes_tfg_app/database/local/databaseManager.dart';
import 'package:diabetes_tfg_app/models/reminderModel.dart';

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
}
