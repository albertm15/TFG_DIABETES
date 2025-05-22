import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:diabetes_tfg_app/database/firebase/authServiceManager.dart';
import 'package:diabetes_tfg_app/database/local/databaseManager.dart';
import 'package:diabetes_tfg_app/models/reminderModel.dart';
import 'package:intl/intl.dart';

class ReminderDAOFB {
  final insatnceDB = DatabaseManager.instance;

  //getAll
  Future<List<ReminderModel>> getAll() async {
    QuerySnapshot snapshot;
    final connectivity = await Connectivity().checkConnectivity();
    String uid = AuthServiceManager.getCurrentUserUID();

    if (!connectivity.contains(ConnectivityResult.wifi) &&
        !connectivity.contains(ConnectivityResult.mobile)) {
      snapshot = await FirebaseFirestore.instance
          .collection("Reminder")
          .where("userId", isEqualTo: uid)
          .get(GetOptions(source: Source.cache));
    } else {
      snapshot = await FirebaseFirestore.instance
          .collection("Reminder")
          .where("userId", isEqualTo: uid)
          .get();
    }

    List<ReminderModel> logs = [];
    for (var doc in snapshot.docs) {
      logs.add(ReminderModel.fromMap(doc.data() as Map<String, dynamic>));
    }

    return logs;
  }

  //insert
  Future<void> insert(ReminderModel reminder) async {
    await FirebaseFirestore.instance
        .collection("Reminder")
        .doc(reminder.id)
        .set(reminder.toMap());
  }

  //update
  Future<void> update(ReminderModel reminder) async {
    await FirebaseFirestore.instance
        .collection("Reminder")
        .doc(reminder.id)
        .update(reminder.toMap());
  }

  //delete
  Future<void> delete(ReminderModel reminder) async {
    await FirebaseFirestore.instance
        .collection("Reminder")
        .doc(reminder.id)
        .delete();
  }

  //getWeekLogs
  Future<List<ReminderModel>> getLast7DaysLogs() async {
    if (AuthServiceManager.checkIfLogged()) {
      String uid = AuthServiceManager.getCurrentUserUID();
      QuerySnapshot snapshot;
      final connectivity = await Connectivity().checkConnectivity();
      if (!connectivity.contains(ConnectivityResult.wifi) &&
          !connectivity.contains(ConnectivityResult.mobile)) {
        snapshot = await FirebaseFirestore.instance
            .collection("Reminder")
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
            .collection("Reminder")
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

      List<ReminderModel> logs = [];
      for (var doc in snapshot.docs) {
        logs.add(ReminderModel.fromMap(doc.data() as Map<String, dynamic>));
      }
      return logs;
    } else {
      return List.empty();
    }
  }

  //getWeekLogs
  Future<List<ReminderModel>> getByDay(String day) async {
    if (AuthServiceManager.checkIfLogged()) {
      String uid = AuthServiceManager.getCurrentUserUID();
      QuerySnapshot snapshot;
      final connectivity = await Connectivity().checkConnectivity();
      if (!connectivity.contains(ConnectivityResult.wifi) &&
          !connectivity.contains(ConnectivityResult.mobile)) {
        snapshot = await FirebaseFirestore.instance
            .collection("Reminder")
            .where("userId", isEqualTo: uid)
            .where("date", isEqualTo: day)
            .orderBy("date")
            .orderBy("time")
            .get(GetOptions(source: Source.cache));
      } else {
        snapshot = await FirebaseFirestore.instance
            .collection("Reminder")
            .where("userId", isEqualTo: uid)
            .where("date", isEqualTo: day)
            .orderBy("date")
            .orderBy("time")
            .get();
      }

      List<ReminderModel> logs = [];
      for (var doc in snapshot.docs) {
        logs.add(ReminderModel.fromMap(doc.data() as Map<String, dynamic>));
      }
      return logs;
    } else {
      return List.empty();
    }
  }

  //getById
  Future<List<ReminderModel>> getById(String id) async {
    if (AuthServiceManager.checkIfLogged()) {
      String uid = AuthServiceManager.getCurrentUserUID();
      QuerySnapshot snapshot;
      final connectivity = await Connectivity().checkConnectivity();
      if (!connectivity.contains(ConnectivityResult.wifi) &&
          !connectivity.contains(ConnectivityResult.mobile)) {
        snapshot = await FirebaseFirestore.instance
            .collection("Reminder")
            .where("userId", isEqualTo: uid)
            .where("id", isEqualTo: id)
            .orderBy("date")
            .orderBy("time")
            .get(GetOptions(source: Source.cache));
      } else {
        snapshot = await FirebaseFirestore.instance
            .collection("Reminder")
            .where("userId", isEqualTo: uid)
            .where("id", isEqualTo: id)
            .orderBy("date")
            .orderBy("time")
            .get();
      }

      List<ReminderModel> logs = [];
      for (var doc in snapshot.docs) {
        logs.add(ReminderModel.fromMap(doc.data() as Map<String, dynamic>));
      }
      return logs;
    } else {
      return List.empty();
    }
  }

  //getAllSinceToday
  Future<List<ReminderModel>> getAllSinceToday() async {
    if (AuthServiceManager.checkIfLogged()) {
      String uid = AuthServiceManager.getCurrentUserUID();
      QuerySnapshot snapshot;
      final connectivity = await Connectivity().checkConnectivity();
      if (!connectivity.contains(ConnectivityResult.wifi) &&
          !connectivity.contains(ConnectivityResult.mobile)) {
        snapshot = await FirebaseFirestore.instance
            .collection("Reminder")
            .where("userId", isEqualTo: uid)
            .where("date",
                isGreaterThanOrEqualTo:
                    DateFormat("yyyy-MM-dd").format(DateTime.now()))
            .orderBy("date")
            .orderBy("time")
            .get(GetOptions(source: Source.cache));
      } else {
        snapshot = await FirebaseFirestore.instance
            .collection("Reminder")
            .where("userId", isEqualTo: uid)
            .where("date",
                isGreaterThanOrEqualTo:
                    DateFormat("yyyy-MM-dd").format(DateTime.now()))
            .orderBy("date")
            .orderBy("time")
            .get();
      }

      List<ReminderModel> logs = [];
      for (var doc in snapshot.docs) {
        logs.add(ReminderModel.fromMap(doc.data() as Map<String, dynamic>));
      }
      return logs;
    } else {
      return List.empty();
    }
  }
}
