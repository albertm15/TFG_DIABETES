import 'package:diabetes_tfg_app/database/local/databaseManager.dart';
import 'package:diabetes_tfg_app/models/insulinModel.dart';

class InsulinDAO {
  final insatnceDB = DatabaseManager.instance;

  //getAll
  Future<List<InsulinModel>> getAll() async {
    final db = await insatnceDB.db;
    List<Map<String, dynamic>> data = await db.query('Insulins');

    List<InsulinModel> insulins = [];
    for (Map<String, dynamic> log in data) {
      insulins.add(InsulinModel.fromMap(log));
    }

    return insulins;
  }

  //insert
  Future<int> insert(InsulinModel insulin) async {
    final db = await insatnceDB.db;
    int id = await db.insert('Insulins', insulin.toMap());

    return id;
  }

  //update
  Future<int> update(InsulinModel insulin) async {
    final db = await insatnceDB.db;
    int id = await db.update('Insulins', insulin.toMap(),
        where: 'id = ?', whereArgs: [insulin.id]);

    return id;
  }

  //delete
  Future<int> delete(InsulinModel insulin) async {
    final db = await insatnceDB.db;
    int id =
        await db.delete('Insulins', where: 'id = ?', whereArgs: [insulin.id]);

    return id;
  }
}
