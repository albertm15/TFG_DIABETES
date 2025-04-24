import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:diabetes_tfg_app/database/local/databaseManager.dart';
import 'package:diabetes_tfg_app/models/dietLogFoodRelationModel.dart';

class DietLogFoodRelationDAOFB {
  final insatnceDB = DatabaseManager.instance;

  //getAll
  Future<List<DietLogFoodRelationModel>> getAll() async {
    QuerySnapshot snapshot;
    final connectivity = await Connectivity().checkConnectivity();

    if (!connectivity.contains(ConnectivityResult.wifi) &&
        !connectivity.contains(ConnectivityResult.mobile)) {
      snapshot = await FirebaseFirestore.instance
          .collection("DietFoodRelation")
          .get(GetOptions(source: Source.cache));
    } else {
      snapshot =
          await FirebaseFirestore.instance.collection("DietFoodRelation").get();
    }

    List<DietLogFoodRelationModel> logs = [];
    for (var doc in snapshot.docs) {
      logs.add(
          DietLogFoodRelationModel.fromMap(doc.data() as Map<String, dynamic>));
    }

    return logs;
  }

  //insert
  Future<void> insert(DietLogFoodRelationModel foodRelation) async {
    await FirebaseFirestore.instance
        .collection("DietFoodRelation")
        .doc(foodRelation.id)
        .set(foodRelation.toMap());
  }

  //update
  Future<void> update(DietLogFoodRelationModel foodRelation) async {
    await FirebaseFirestore.instance
        .collection("DietFoodRelation")
        .doc(foodRelation.id)
        .update(foodRelation.toMap());
  }

  //delete
  Future<void> delete(DietLogFoodRelationModel foodRelation) async {
    await FirebaseFirestore.instance
        .collection("DietFoodRelation")
        .doc(foodRelation.id)
        .delete();
  }
}
