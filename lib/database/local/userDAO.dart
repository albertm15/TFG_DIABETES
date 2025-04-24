import 'package:diabetes_tfg_app/database/local/databaseManager.dart';
import 'package:diabetes_tfg_app/models/userModel.dart';

class UserDAO {
  final insatnceDB = DatabaseManager.instance;

  //getAll
  Future<List<UserModel>> getAll() async {
    final db = await insatnceDB.db;
    List<Map<String, dynamic>> data = await db.query('Users');

    List<UserModel> users = [];
    for (Map<String, dynamic> log in data) {
      users.add(UserModel.fromMap(log));
    }

    return users;
  }

  //insert
  Future<int> insert(UserModel user) async {
    final db = await insatnceDB.db;
    int id = await db.insert('Users', user.toMap());

    return id;
  }

  //update
  Future<int> update(UserModel user) async {
    final db = await insatnceDB.db;
    int id = await db
        .update('Users', user.toMap(), where: 'id = ?', whereArgs: [user.id]);

    return id;
  }

  //delete
  Future<int> delete(UserModel user) async {
    final db = await insatnceDB.db;
    int id = await db.delete('Users', where: 'id = ?', whereArgs: [user.id]);

    return id;
  }

  //getById
  Future<List<UserModel>> getById(String id) async {
    final db = await insatnceDB.db;
    List<Map<String, dynamic>> data =
        await db.query('Users', where: 'id = ?', whereArgs: [id]);

    List<UserModel> users = [];
    for (Map<String, dynamic> log in data) {
      users.add(UserModel.fromMap(log));
    }

    return users;
  }
}
