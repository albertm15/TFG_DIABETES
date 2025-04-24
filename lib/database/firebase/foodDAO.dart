import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:diabetes_tfg_app/database/local/databaseManager.dart';
import 'package:diabetes_tfg_app/models/foodModel.dart';

class FoodDAOFB {
  final insatnceDB = DatabaseManager.instance;

  //getAll
  Future<List<FoodModel>> getAll() async {
    QuerySnapshot snapshot;
    final connectivity = await Connectivity().checkConnectivity();

    if (!connectivity.contains(ConnectivityResult.wifi) &&
        !connectivity.contains(ConnectivityResult.mobile)) {
      snapshot = await FirebaseFirestore.instance
          .collection("Food")
          .get(GetOptions(source: Source.cache));
    } else {
      snapshot = await FirebaseFirestore.instance.collection("Food").get();
    }

    List<FoodModel> logs = [];
    for (var doc in snapshot.docs) {
      logs.add(FoodModel.fromMap(doc.data() as Map<String, dynamic>));
    }

    return logs;
  }

  //insert
  Future<void> insert(FoodModel food) async {
    await FirebaseFirestore.instance
        .collection("Food")
        .doc(food.id)
        .set(food.toMap());
  }

  //update
  Future<void> update(FoodModel food) async {
    await FirebaseFirestore.instance
        .collection("Food")
        .doc(food.id)
        .update(food.toMap());
  }

  //delete
  Future<void> delete(FoodModel food) async {
    await FirebaseFirestore.instance.collection("Food").doc(food.id).delete();
  }
}
