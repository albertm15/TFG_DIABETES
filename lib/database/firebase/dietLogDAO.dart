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
    String uid = AuthServiceManager.getCurrentUserUID();

    if (!connectivity.contains(ConnectivityResult.wifi) &&
        !connectivity.contains(ConnectivityResult.mobile)) {
      snapshot = await FirebaseFirestore.instance
          .collection("DietLog")
          .where("userId", isEqualTo: uid)
          .get(GetOptions(source: Source.cache));
    } else {
      snapshot = await FirebaseFirestore.instance
          .collection("DietLog")
          .where("userId", isEqualTo: uid)
          .get();
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
            .collection("DietLog")
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

      List<DietLogModel> logs = [];
      for (var doc in snapshot.docs) {
        logs.add(DietLogModel.fromMap(doc.data() as Map<String, dynamic>));
      }
      return logs;
    } else {
      return List.empty();
    }
  }

  //getById
  Future<List<DietLogModel>> getById(String id) async {
    if (AuthServiceManager.checkIfLogged()) {
      String uid = AuthServiceManager.getCurrentUserUID();
      QuerySnapshot snapshot;
      final connectivity = await Connectivity().checkConnectivity();
      if (!connectivity.contains(ConnectivityResult.wifi) &&
          !connectivity.contains(ConnectivityResult.mobile)) {
        snapshot = await FirebaseFirestore.instance
            .collection("DietLog")
            .where("userId", isEqualTo: uid)
            .where("id", isEqualTo: id)
            .get(GetOptions(source: Source.cache));
      } else {
        snapshot = await FirebaseFirestore.instance
            .collection("DietLog")
            .where("userId", isEqualTo: uid)
            .where("id", isEqualTo: id)
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

  //getTodayLogs
  Future<List<DietLogModel>> getTodayLogs() async {
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
                isEqualTo: DateFormat("yyyy-MM-dd").format(DateTime.now()))
            .orderBy("time")
            .get(GetOptions(source: Source.cache));
      } else {
        snapshot = await FirebaseFirestore.instance
            .collection("DietLog")
            .where("userId", isEqualTo: uid)
            .where("date",
                isEqualTo: DateFormat("yyyy-MM-dd").format(DateTime.now()))
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

  //getCustomDateRangeLogs
  Future<List<DietLogModel>> getCustomDateRangeLogs(
      String initial, String end) async {
    if (AuthServiceManager.checkIfLogged()) {
      String uid = AuthServiceManager.getCurrentUserUID();
      QuerySnapshot snapshot;
      final connectivity = await Connectivity().checkConnectivity();
      if (!connectivity.contains(ConnectivityResult.wifi) &&
          !connectivity.contains(ConnectivityResult.mobile)) {
        snapshot = await FirebaseFirestore.instance
            .collection("DietLog")
            .where("userId", isEqualTo: uid)
            .where("date", isGreaterThanOrEqualTo: initial)
            .where("date", isLessThanOrEqualTo: end)
            .orderBy("date")
            .orderBy("time")
            .get(GetOptions(source: Source.cache));
      } else {
        snapshot = await FirebaseFirestore.instance
            .collection("DietLog")
            .where("userId", isEqualTo: uid)
            .where("date", isGreaterThanOrEqualTo: initial)
            .where("date", isLessThanOrEqualTo: end)
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
