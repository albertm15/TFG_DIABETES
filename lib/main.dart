import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diabetes_tfg_app/database/firebase/glucoseLogDAO.dart';
import 'package:diabetes_tfg_app/database/firebase/userDAO.dart';
import 'package:diabetes_tfg_app/models/gluoseLogModel.dart';
import 'package:diabetes_tfg_app/models/userModel.dart';
import 'package:diabetes_tfg_app/pages/homePage.dart';
import 'package:diabetes_tfg_app/widgets/backgroundBase.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseFirestore.instance.settings =
      const Settings(persistenceEnabled: true);

  //--- testing DB
  print("insert");
  GlucoseLogModel logModel = GlucoseLogModel.newEntity("userId", 122,
      "22-02-2024", "22:04:34", "Elevado", false, true, "este es otro insert");
  /*
  Map<String, dynamic> map = logModel.toMap();
  await FirebaseFirestore.instance.collection("glucoseLog").add(map);
  */
  UserModel userModel = UserModel.rawPassword(
      "eamil1@gmail.com", "123", 187, 67.7, 1, "Victoooor", "male", "Spain");
  GlucoseLogDAOFB daofb = GlucoseLogDAOFB();
  UserDAOFB userDAO = UserDAOFB();
  //daofb.insert(logModel);
  //userDAO.insert(userModel);

  print("fin insert");

  print("GET ALL");
  List<GlucoseLogModel> logs = await daofb.getAll();
  for (GlucoseLogModel log in logs) {
    print(log);
    print("\n");
  }
  //print(await daofb.getAll());
  print("fin GET ALL");

  print("UDATE");
  print(logs[0]);
  GlucoseLogModel updatedLog = logs[0];
  updatedLog.userId = "muy buebas  tardes jejej (modificado)";
  //daofb.update(updatedLog);
  //logs = await daofb.getAll();
  print(logs[0]);
  print("fin UPDATE");

  print("DELETE");
  //daofb.delete(updatedLog);
  print("DELETE");

  print("get by id");
  print(await userDAO.getById("1e2940c2-d57f-4595-99c4-62aaeb0cb35a"));
  print("fin get by id");

  //---
  runApp(MaterialApp(
      home: BackgroundBase(child: Homepage()),
      debugShowCheckedModeBanner: false));
}
