import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:diabetes_tfg_app/database/firebase/authServiceManager.dart';
import 'package:diabetes_tfg_app/database/local/databaseManager.dart';
import 'package:diabetes_tfg_app/models/exerciceLogModel.dart';
import 'package:intl/intl.dart';

class ExerciceLogDAOFB {
  final insatnceDB = DatabaseManager.instance;

  //getAll
  Future<List<ExerciceLogModel>> getAll() async {
    QuerySnapshot snapshot;
    final connectivity = await Connectivity().checkConnectivity();

    if (!connectivity.contains(ConnectivityResult.wifi) &&
        !connectivity.contains(ConnectivityResult.mobile)) {
      snapshot = await FirebaseFirestore.instance
          .collection("ExerciceLog")
          .get(GetOptions(source: Source.cache));
    } else {
      snapshot =
          await FirebaseFirestore.instance.collection("ExerciceLog").get();
    }

    List<ExerciceLogModel> logs = [];
    for (var doc in snapshot.docs) {
      logs.add(ExerciceLogModel.fromMap(doc.data() as Map<String, dynamic>));
    }

    return logs;
  }

  //insert
  Future<void> insert(ExerciceLogModel exerciceLog) async {
    await FirebaseFirestore.instance
        .collection("ExerciceLog")
        .doc(exerciceLog.id)
        .set(exerciceLog.toMap());
  }

  //update
  Future<void> update(ExerciceLogModel exerciceLog) async {
    await FirebaseFirestore.instance
        .collection("ExerciceLog")
        .doc(exerciceLog.id)
        .update(exerciceLog.toMap());
  }

  //delete
  Future<void> delete(ExerciceLogModel exerciceLog) async {
    await FirebaseFirestore.instance
        .collection("ExerciceLog")
        .doc(exerciceLog.id)
        .delete();
  }

  //getWeekLogs
  Future<List<ExerciceLogModel>> getLast7DaysLogs() async {
    if (AuthServiceManager.checkIfLogged()) {
      String uid = AuthServiceManager.getCurrentUserUID();
      QuerySnapshot snapshot;
      final connectivity = await Connectivity().checkConnectivity();
      if (!connectivity.contains(ConnectivityResult.wifi) &&
          !connectivity.contains(ConnectivityResult.mobile)) {
        snapshot = await FirebaseFirestore.instance
            .collection("ExerciceLog")
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
            .collection("ExerciceLog")
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

      List<ExerciceLogModel> logs = [];
      for (var doc in snapshot.docs) {
        logs.add(ExerciceLogModel.fromMap(doc.data() as Map<String, dynamic>));
      }
      return logs;
    } else {
      return List.empty();
    }
  }
}
