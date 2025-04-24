import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:diabetes_tfg_app/database/local/databaseManager.dart';
import 'package:diabetes_tfg_app/models/dietLogModel.dart';

class DietLogDAOFB {
  final insatnceDB = DatabaseManager.instance;

  //getAll
  Future<List<DietLogModel>> getAll() async {
    QuerySnapshot snapshot;
    final connectivity = await Connectivity().checkConnectivity();

    if (!connectivity.contains(ConnectivityResult.wifi) &&
        !connectivity.contains(ConnectivityResult.mobile)) {
      snapshot = await FirebaseFirestore.instance
          .collection("DietLog")
          .get(GetOptions(source: Source.cache));
    } else {
      snapshot = await FirebaseFirestore.instance.collection("DietLog").get();
    }

    List<DietLogModel> logs = [];
    for (var doc in snapshot.docs) {
      logs.add(DietLogModel.fromMap(doc.data() as Map<String, dynamic>));
    }

    return logs;
  }

  //insert
  Future<void> insert(DietLogModel dietLog) async {
    await FirebaseFirestore.instance
        .collection("DietLog")
        .doc(dietLog.id)
        .set(dietLog.toMap());
  }

  //update
  Future<void> update(DietLogModel dietLog) async {
    await FirebaseFirestore.instance
        .collection("DietLog")
        .doc(dietLog.id)
        .update(dietLog.toMap());
  }

  //delete
  Future<void> delete(DietLogModel dietLog) async {
    await FirebaseFirestore.instance
        .collection("DietLog")
        .doc(dietLog.id)
        .delete();
  }
}
