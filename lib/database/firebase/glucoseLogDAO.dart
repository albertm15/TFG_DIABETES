import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diabetes_tfg_app/database/firebase/authServiceManager.dart';
import 'package:diabetes_tfg_app/database/local/databaseManager.dart';
import 'package:diabetes_tfg_app/models/gluoseLogModel.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:intl/intl.dart';

class GlucoseLogDAOFB {
  final insatnceDB = DatabaseManager.instance;

  //getAll
  Future<List<GlucoseLogModel>> getAll() async {
    QuerySnapshot snapshot;
    print("check connection");
    final connectivity = await Connectivity().checkConnectivity();
    String uid = AuthServiceManager.getCurrentUserUID();
    print("connection checked");
    print(connectivity);
    if (!connectivity.contains(ConnectivityResult.wifi) &&
        !connectivity.contains(ConnectivityResult.mobile)) {
      print("NO connection");
      snapshot = await FirebaseFirestore.instance
          .collection("glucoseLog")
          .where("userId", isEqualTo: uid)
          .get(const GetOptions(source: Source.cache));
    } else {
      print("OK connection");
      snapshot = await FirebaseFirestore.instance
          .collection("glucoseLog")
          .where("userId", isEqualTo: uid)
          .get();
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
                isEqualTo: DateFormat("yyyy-MM-dd").format(DateTime.now()))
            .orderBy("time")
            .get(GetOptions(source: Source.cache));
      } else {
        snapshot = await FirebaseFirestore.instance
            .collection("glucoseLog")
            .where("userId", isEqualTo: uid)
            .where("date",
                isEqualTo: DateFormat("yyyy-MM-dd").format(DateTime.now()))
            .orderBy("time")
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

  //getWeekLogs
  Future<List<GlucoseLogModel>> getLast7DaysLogs() async {
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
            .collection("glucoseLog")
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

      List<GlucoseLogModel> logs = [];
      for (var doc in snapshot.docs) {
        logs.add(GlucoseLogModel.fromMap(doc.data() as Map<String, dynamic>));
      }
      return logs;
    } else {
      return List.empty();
    }
  }

  //getLast30DaysLogs
  Future<List<GlucoseLogModel>> getLast30DaysLogs() async {
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
                isGreaterThanOrEqualTo: DateFormat("yyyy-MM-dd")
                    .format(DateTime.now().subtract(Duration(days: 30))))
            .where("date",
                isLessThanOrEqualTo:
                    DateFormat("yyyy-MM-dd").format(DateTime.now()))
            .orderBy("date")
            .orderBy("time")
            .get(GetOptions(source: Source.cache));
      } else {
        snapshot = await FirebaseFirestore.instance
            .collection("glucoseLog")
            .where("userId", isEqualTo: uid)
            .where("date",
                isGreaterThanOrEqualTo: DateFormat("yyyy-MM-dd")
                    .format(DateTime.now().subtract(Duration(days: 30))))
            .where("date",
                isLessThanOrEqualTo:
                    DateFormat("yyyy-MM-dd").format(DateTime.now()))
            .orderBy("date")
            .orderBy("time")
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

  //getLast90DaysLogs
  Future<List<GlucoseLogModel>> getLast90DaysLogs() async {
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
                isGreaterThanOrEqualTo: DateFormat("yyyy-MM-dd")
                    .format(DateTime.now().subtract(Duration(days: 90))))
            .where("date",
                isLessThanOrEqualTo:
                    DateFormat("yyyy-MM-dd").format(DateTime.now()))
            .orderBy("date")
            .orderBy("time")
            .get(GetOptions(source: Source.cache));
      } else {
        snapshot = await FirebaseFirestore.instance
            .collection("glucoseLog")
            .where("userId", isEqualTo: uid)
            .where("date",
                isGreaterThanOrEqualTo: DateFormat("yyyy-MM-dd")
                    .format(DateTime.now().subtract(Duration(days: 90))))
            .where("date",
                isLessThanOrEqualTo:
                    DateFormat("yyyy-MM-dd").format(DateTime.now()))
            .orderBy("date")
            .orderBy("time")
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

  //getById
  Future<List<GlucoseLogModel>> getById(String id) async {
    if (AuthServiceManager.checkIfLogged()) {
      String uid = AuthServiceManager.getCurrentUserUID();
      QuerySnapshot snapshot;
      final connectivity = await Connectivity().checkConnectivity();
      if (!connectivity.contains(ConnectivityResult.wifi) &&
          !connectivity.contains(ConnectivityResult.mobile)) {
        snapshot = await FirebaseFirestore.instance
            .collection("glucoseLog")
            .where("userId", isEqualTo: uid)
            .where("id", isEqualTo: id)
            .get(GetOptions(source: Source.cache));
      } else {
        snapshot = await FirebaseFirestore.instance
            .collection("glucoseLog")
            .where("userId", isEqualTo: uid)
            .where("id", isEqualTo: id)
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

  //getCustomDateRangeLogs
  Future<List<GlucoseLogModel>> getCustomDateRangeLogs(
      String initial, String end) async {
    if (AuthServiceManager.checkIfLogged()) {
      String uid = AuthServiceManager.getCurrentUserUID();
      QuerySnapshot snapshot;
      final connectivity = await Connectivity().checkConnectivity();
      if (!connectivity.contains(ConnectivityResult.wifi) &&
          !connectivity.contains(ConnectivityResult.mobile)) {
        snapshot = await FirebaseFirestore.instance
            .collection("glucoseLog")
            .where("userId", isEqualTo: uid)
            .where("date", isGreaterThanOrEqualTo: initial)
            .where("date", isLessThanOrEqualTo: end)
            .orderBy("date")
            .orderBy("time")
            .get(GetOptions(source: Source.cache));
      } else {
        snapshot = await FirebaseFirestore.instance
            .collection("glucoseLog")
            .where("userId", isEqualTo: uid)
            .where("date", isGreaterThanOrEqualTo: initial)
            .where("date", isLessThanOrEqualTo: end)
            .orderBy("date")
            .orderBy("time")
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
