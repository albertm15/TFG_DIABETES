import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:diabetes_tfg_app/database/firebase/authServiceManager.dart';
import 'package:diabetes_tfg_app/database/local/databaseManager.dart';
import 'package:diabetes_tfg_app/models/InsulinLogModel.dart';
import 'package:intl/intl.dart';

class InsulinLogDAOFB {
  final insatnceDB = DatabaseManager.instance;

  //getAll
  Future<List<InsulinLogModel>> getAll() async {
    QuerySnapshot snapshot;
    final connectivity = await Connectivity().checkConnectivity();
    String uid = AuthServiceManager.getCurrentUserUID();

    if (!connectivity.contains(ConnectivityResult.wifi) &&
        !connectivity.contains(ConnectivityResult.mobile)) {
      snapshot = await FirebaseFirestore.instance
          .collection("InsulinLog")
          .where("userId", isEqualTo: uid)
          .get(GetOptions(source: Source.cache));
    } else {
      snapshot = await FirebaseFirestore.instance
          .collection("InsulinLog")
          .where("userId", isEqualTo: uid)
          .get();
    }

    List<InsulinLogModel> logs = [];
    for (var doc in snapshot.docs) {
      logs.add(InsulinLogModel.fromMap(doc.data() as Map<String, dynamic>));
    }

    return logs;
  }

  //insert
  Future<void> insert(InsulinLogModel insulinLog) async {
    await FirebaseFirestore.instance
        .collection("InsulinLog")
        .doc(insulinLog.id)
        .set(insulinLog.toMap());
  }

  //update
  Future<void> update(InsulinLogModel insulinLog) async {
    await FirebaseFirestore.instance
        .collection("InsulinLog")
        .doc(insulinLog.id)
        .update(insulinLog.toMap());
  }

  //delete
  Future<void> delete(InsulinLogModel insulinLog) async {
    await FirebaseFirestore.instance
        .collection("InsulinLog")
        .doc(insulinLog.id)
        .delete();
  }

  //getWeekLogs
  Future<List<InsulinLogModel>> getLast7DaysLogs() async {
    if (AuthServiceManager.checkIfLogged()) {
      String uid = AuthServiceManager.getCurrentUserUID();
      QuerySnapshot snapshot;
      final connectivity = await Connectivity().checkConnectivity();
      if (!connectivity.contains(ConnectivityResult.wifi) &&
          !connectivity.contains(ConnectivityResult.mobile)) {
        snapshot = await FirebaseFirestore.instance
            .collection("InsulinLog")
            .where("userId", isEqualTo: uid)
            .where("date",
                isGreaterThanOrEqualTo: DateFormat("yyyy-MM-dd")
                    .format(DateTime.now().subtract(Duration(days: 7))))
            .where("date",
                isLessThanOrEqualTo:
                    DateFormat("yyyy-MM-dd").format(DateTime.now()))
            .orderBy("date")
            .orderBy("time")
            .get(GetOptions(source: Source.cache));
      } else {
        snapshot = await FirebaseFirestore.instance
            .collection("InsulinLog")
            .where("userId", isEqualTo: uid)
            .where("date",
                isGreaterThanOrEqualTo: DateFormat("yyyy-MM-dd")
                    .format(DateTime.now().subtract(Duration(days: 7))))
            .where("date",
                isLessThanOrEqualTo:
                    DateFormat("yyyy-MM-dd").format(DateTime.now()))
            .orderBy("date")
            .orderBy("time")
            .get();
      }

      List<InsulinLogModel> logs = [];
      for (var doc in snapshot.docs) {
        logs.add(InsulinLogModel.fromMap(doc.data() as Map<String, dynamic>));
      }
      return logs;
    } else {
      return List.empty();
    }
  }

  //getById
  Future<List<InsulinLogModel>> getById(String id) async {
    if (AuthServiceManager.checkIfLogged()) {
      String uid = AuthServiceManager.getCurrentUserUID();
      QuerySnapshot snapshot;
      final connectivity = await Connectivity().checkConnectivity();
      if (!connectivity.contains(ConnectivityResult.wifi) &&
          !connectivity.contains(ConnectivityResult.mobile)) {
        snapshot = await FirebaseFirestore.instance
            .collection("InsulinLog")
            .where("userId", isEqualTo: uid)
            .where("id", isEqualTo: id)
            .get(GetOptions(source: Source.cache));
      } else {
        snapshot = await FirebaseFirestore.instance
            .collection("InsulinLog")
            .where("userId", isEqualTo: uid)
            .where("id", isEqualTo: id)
            .get();
      }

      List<InsulinLogModel> logs = [];
      for (var doc in snapshot.docs) {
        logs.add(InsulinLogModel.fromMap(doc.data() as Map<String, dynamic>));
      }
      return logs;
    } else {
      return List.empty();
    }
  }
}
