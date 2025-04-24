import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:diabetes_tfg_app/database/local/databaseManager.dart';
import 'package:diabetes_tfg_app/models/reminderModel.dart';

class ReminderDAOFB {
  final insatnceDB = DatabaseManager.instance;

  //getAll
  Future<List<ReminderModel>> getAll() async {
    QuerySnapshot snapshot;
    final connectivity = await Connectivity().checkConnectivity();

    if (!connectivity.contains(ConnectivityResult.wifi) &&
        !connectivity.contains(ConnectivityResult.mobile)) {
      snapshot = await FirebaseFirestore.instance
          .collection("Reminder")
          .get(GetOptions(source: Source.cache));
    } else {
      snapshot = await FirebaseFirestore.instance.collection("Reminder").get();
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
}
