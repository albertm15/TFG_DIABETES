import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diabetes_tfg_app/database/firebase/authServiceManager.dart';
import 'package:diabetes_tfg_app/database/local/databaseManager.dart';
import 'package:diabetes_tfg_app/models/gluoseLogModel.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:intl/intl.dart';

class GlucoseLogDAOFB {
  final insatnceDB = DatabaseManager.instance;

  //getAll
  Future<List<GlucoseLogModel>> getAll() async {
    QuerySnapshot snapshot;
    print("check connection");
    final connectivity = await Connectivity().checkConnectivity();
    print("connection checked");
    print(connectivity);
    if (!connectivity.contains(ConnectivityResult.wifi) &&
        !connectivity.contains(ConnectivityResult.mobile)) {
      print("NO connection");
      snapshot = await FirebaseFirestore.instance
          .collection("glucoseLog")
          .get(const GetOptions(source: Source.cache));
    } else {
      print("OK connection");
      snapshot =
          await FirebaseFirestore.instance.collection("glucoseLog").get();
    }
    /*QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection("glucoseLog").get();*/

    List<GlucoseLogModel> glucoseLogs = [];

    for (var doc in snapshot.docs) {
      glucoseLogs
          .add(GlucoseLogModel.fromMap(doc.data() as Map<String, dynamic>));
    }

    return glucoseLogs;
  }

  //insert
  Future<void> insert(GlucoseLogModel glucoseLog) async {
    await FirebaseFirestore.instance
        .collection("glucoseLog")
        .doc(glucoseLog.id)
        .set(glucoseLog.toMap());
  }

  //update
  Future<void> update(GlucoseLogModel glucoseLog) async {
    await FirebaseFirestore.instance
        .collection("glucoseLog")
        .doc(glucoseLog.id)
        .update(glucoseLog.toMap());
  }

  //delete
  Future<void> delete(GlucoseLogModel glucoseLog) async {
    await FirebaseFirestore.instance
        .collection("glucoseLog")
        .doc(glucoseLog.id)
        .delete();
  }

  //getTodayLogs
  Future<List<GlucoseLogModel>> getTodayLogs() async {
    if (AuthServiceManager.checkIfLogged()) {
      String uid = AuthServiceManager.getCurrentUserUID();
      QuerySnapshot snapshot;
      final connectivity = await Connectivity().checkConnectivity();
      if (!connectivity.contains(ConnectivityResult.wifi) &&
          !connectivity.contains(ConnectivityResult.mobile)) {
        snapshot = await FirebaseFirestore.instance
            .collection("glucoseLog")
            .where("userId", isEqualTo: uid)
            .where("date",
                isEqualTo: DateFormat("dd-MM-yyyy").format(DateTime.now()))
            .get(GetOptions(source: Source.cache));
      } else {
        snapshot = await FirebaseFirestore.instance
            .collection("glucoseLog")
            .where("userId", isEqualTo: uid)
            .where("date",
                isEqualTo: DateFormat("dd-MM-yyyy").format(DateTime.now()))
            .get();
      }

      List<GlucoseLogModel> logs = [];
      for (var doc in snapshot.docs) {
        logs.add(GlucoseLogModel.fromMap(doc.data() as Map<String, dynamic>));
      }
      return logs;
    } else {
      return List.empty();
    }
  }
}
