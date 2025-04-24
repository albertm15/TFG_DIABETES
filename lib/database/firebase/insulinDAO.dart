import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:diabetes_tfg_app/database/local/databaseManager.dart';
import 'package:diabetes_tfg_app/models/insulinModel.dart';

class InsulinDAOFB {
  final insatnceDB = DatabaseManager.instance;

  //getAll
  Future<List<InsulinModel>> getAll() async {
    QuerySnapshot snapshot;
    final connectivity = await Connectivity().checkConnectivity();

    if (!connectivity.contains(ConnectivityResult.wifi) &&
        !connectivity.contains(ConnectivityResult.mobile)) {
      snapshot = await FirebaseFirestore.instance
          .collection("Insulin")
          .get(GetOptions(source: Source.cache));
    } else {
      snapshot = await FirebaseFirestore.instance.collection("Insulin").get();
    }

    List<InsulinModel> logs = [];
    for (var doc in snapshot.docs) {
      logs.add(InsulinModel.fromMap(doc.data() as Map<String, dynamic>));
    }

    return logs;
  }

  //insert
  Future<void> insert(InsulinModel insulin) async {
    await FirebaseFirestore.instance
        .collection("Insulin")
        .doc(insulin.id)
        .set(insulin.toMap());
  }

  //update
  Future<void> update(InsulinModel insulin) async {
    await FirebaseFirestore.instance
        .collection("Insulin")
        .doc(insulin.id)
        .update(insulin.toMap());
  }

  //delete
  Future<void> delete(InsulinModel insulin) async {
    await FirebaseFirestore.instance
        .collection("Insulin")
        .doc(insulin.id)
        .delete();
  }
}
