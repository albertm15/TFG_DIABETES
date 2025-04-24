import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:diabetes_tfg_app/database/local/databaseManager.dart';
import 'package:diabetes_tfg_app/models/userModel.dart';

class UserDAOFB {
  final insatnceDB = DatabaseManager.instance;

  //getAll
  Future<List<UserModel>> getAll() async {
    QuerySnapshot snapshot;
    final connectivity = await Connectivity().checkConnectivity();

    if (!connectivity.contains(ConnectivityResult.wifi) &&
        !connectivity.contains(ConnectivityResult.mobile)) {
      snapshot = await FirebaseFirestore.instance
          .collection("User")
          .get(GetOptions(source: Source.cache));
    } else {
      snapshot = await FirebaseFirestore.instance.collection("User").get();
    }

    List<UserModel> logs = [];
    for (var doc in snapshot.docs) {
      logs.add(UserModel.fromMap(doc.data() as Map<String, dynamic>));
    }

    return logs;
  }

  //insert
  Future<void> insert(UserModel user) async {
    print("insert user");
    await FirebaseFirestore.instance
        .collection("User")
        .doc(user.id)
        .set(user.toMap());
    print("fin insert user");
  }

  //update
  Future<void> update(UserModel user) async {
    await FirebaseFirestore.instance
        .collection("User")
        .doc(user.id)
        .update(user.toMap());
  }

  //delete
  Future<void> delete(UserModel user) async {
    await FirebaseFirestore.instance.collection("User").doc(user.id).delete();
  }

  //getById
  Future<List<UserModel>> getById(String id) async {
    QuerySnapshot snapshot;
    final connectivity = await Connectivity().checkConnectivity();

    if (!connectivity.contains(ConnectivityResult.wifi) &&
        !connectivity.contains(ConnectivityResult.mobile)) {
      snapshot = await FirebaseFirestore.instance
          .collection("User")
          .where("id", isEqualTo: id)
          .get(GetOptions(source: Source.cache));
    } else {
      snapshot = await FirebaseFirestore.instance
          .collection("User")
          .where("id", isEqualTo: id)
          .get();
    }

    List<UserModel> logs = [];
    for (var doc in snapshot.docs) {
      logs.add(UserModel.fromMap(doc.data() as Map<String, dynamic>));
    }

    return logs;
  }
}
