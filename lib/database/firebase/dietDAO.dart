import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:diabetes_tfg_app/database/local/databaseManager.dart';
import 'package:diabetes_tfg_app/models/dietModel.dart';

class DietDAOFB {
  final insatnceDB = DatabaseManager.instance;

  //getAll
  Future<List<DietModel>> getAll() async {
    QuerySnapshot snapshot;
    final connectivity = await Connectivity().checkConnectivity();

    if (!connectivity.contains(ConnectivityResult.wifi) &&
        !connectivity.contains(ConnectivityResult.mobile)) {
      snapshot = await FirebaseFirestore.instance
          .collection("Diet")
          .get(GetOptions(source: Source.cache));
    } else {
      snapshot = await FirebaseFirestore.instance.collection("Diet").get();
    }

    List<DietModel> logs = [];
    for (var doc in snapshot.docs) {
      logs.add(DietModel.fromMap(doc.data() as Map<String, dynamic>));
    }

    return logs;
  }

  //insert
  Future<void> insert(DietModel diet) async {
    await FirebaseFirestore.instance
        .collection("Diet")
        .doc(diet.id)
        .set(diet.toMap());
  }

  //update
  Future<void> update(DietModel diet) async {
    await FirebaseFirestore.instance
        .collection("Diet")
        .doc(diet.id)
        .update(diet.toMap());
  }

  //delete
  Future<void> delete(DietModel diet) async {
    await FirebaseFirestore.instance.collection("Diet").doc(diet.id).delete();
  }
}
