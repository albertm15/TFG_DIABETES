import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:diabetes_tfg_app/database/firebase/authServiceManager.dart';
import 'package:diabetes_tfg_app/database/local/databaseManager.dart';
import 'package:diabetes_tfg_app/models/dietLogModel.dart';
import 'package:intl/intl.dart';

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

  //getWeekLogs
  Future<List<DietLogModel>> getLast7DaysLogs() async {
    if (AuthServiceManager.checkIfLogged()) {
      String uid = AuthServiceManager.getCurrentUserUID();
      QuerySnapshot snapshot;
      final connectivity = await Connectivity().checkConnectivity();
      if (!connectivity.contains(ConnectivityResult.wifi) &&
          !connectivity.contains(ConnectivityResult.mobile)) {
        snapshot = await FirebaseFirestore.instance
            .collection("DietLog")
            .where("userId", isEqualTo: uid)
            .where("date",
                isGreaterThanOrEqualTo: DateFormat("dd-MM-yyyy")
                    .format(DateTime.now().subtract(Duration(days: 7))))
            .where("date",
                isLessThanOrEqualTo:
                    DateFormat("dd-MM-yyyy").format(DateTime.now()))
            .orderBy("date")
            .orderBy("time")
            .get(GetOptions(source: Source.cache));
      } else {
        snapshot = await FirebaseFirestore.instance
            .collection("DietLog")
            .where("userId", isEqualTo: uid)
            .where("date",
                isGreaterThanOrEqualTo: DateFormat("dd-MM-yyyy")
                    .format(DateTime.now().subtract(Duration(days: 7))))
            .where("date",
                isLessThanOrEqualTo:
                    DateFormat("dd-MM-yyyy").format(DateTime.now()))
            .orderBy("date")
            .orderBy("time")
            .get();
      }

      List<DietLogModel> logs = [];
      for (var doc in snapshot.docs) {
        logs.add(DietLogModel.fromMap(doc.data() as Map<String, dynamic>));
      }
      return logs;
    } else {
      return List.empty();
    }
  }
}
