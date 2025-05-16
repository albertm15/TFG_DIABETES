import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:diabetes_tfg_app/auxiliarResources/insulinNotifications.dart';
import 'package:diabetes_tfg_app/database/firebase/authServiceManager.dart';
import 'package:diabetes_tfg_app/database/firebase/foodDAO.dart';
import 'package:diabetes_tfg_app/database/firebase/glucoseLogDAO.dart';
import 'package:diabetes_tfg_app/database/firebase/insulinDAO.dart';
import 'package:diabetes_tfg_app/database/firebase/insulinLogDAO.dart';
import 'package:diabetes_tfg_app/database/firebase/userDAO.dart';
import 'package:diabetes_tfg_app/database/local/glucoseLogDAO.dart';
import 'package:diabetes_tfg_app/models/InsulinLogModel.dart';
import 'package:diabetes_tfg_app/models/foodModel.dart';
import 'package:diabetes_tfg_app/models/gluoseLogModel.dart';
import 'package:diabetes_tfg_app/models/insulinModel.dart';
import 'package:diabetes_tfg_app/models/userModel.dart';
import 'package:diabetes_tfg_app/pages/homePage.dart';
import 'package:diabetes_tfg_app/pages/welcomePage.dart';
import 'package:diabetes_tfg_app/widgets/backgroundBase.dart';
import 'package:diabetes_tfg_app/widgets/drawerScaffold.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await initializeDateFormatting('es_ES', null);
  FirebaseFirestore.instance.settings =
      const Settings(persistenceEnabled: true);

  //-----------------------------------------------------------------------------------------------------------------
  //--- testing DB
  print("insert");
  GlucoseLogModel logModel = GlucoseLogModel.newEntity(
      "9ZHHlxtd9ThGLNRD8ZRhhEu0uVm1",
      140,
      DateFormat("yyyy-MM-dd").format(DateTime.now()),
      //"${DateTime.now().hour.toString().padLeft(2, "0")}:${DateTime.now().minute.toString().padLeft(2, "0")}:${DateTime.now().second.toString().padLeft(2, "0")}",
      "06:45:00",
      "Normal",
      true,
      false,
      "este es otro insert");
  /*
  Map<String, dynamic> map = logModel.toMap();
  await FirebaseFirestore.instance.collection("glucoseLog").add(map);
  */
  UserModel userModel = UserModel.rawPassword("eamil1@gmail.com", "123", 187,
      67.7, 1, "Victoooor", "male", "Spain", "");
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

  //test de auth
  print(AuthServiceManager.checkIfLogged());
  //AuthServiceManager.signUp(
  //    "emailsenderspringproject@gmail.com", "emailSender1234");
  //AuthServiceManager.logOut();
  print(AuthServiceManager.checkIfLogged());
  //AuthServiceManager.logIn(
  //   "emailsenderspringproject@gmail.com", "emailSender1234");
  print(AuthServiceManager.checkIfLogged());
  //print(AuthServiceManager.getCurrentUserUID());
  //AuthServiceManager.updatePassword("emailSender");
  //AuthServiceManager.resetForgottenPassword(
  //    "emailsenderspringproject@gmail.com");
  //AuthServiceManager.deleteUser();
  //print(AuthServiceManager.getCurrentUserUID());

  print(DateFormat('yyyy-MM-dd').format(DateTime.now()));
  print(DateTime.now().hour);
  print(await daofb.getLast7DaysLogs());
  print(DateTime.now().subtract(Duration(days: 7)));

  GlucoseLogModel logModel2 = GlucoseLogModel.newEntity(
      "LocalUser",
      125,
      DateFormat("yyyy-MM-dd").format(DateTime.now()),
      "${DateTime.now().hour.toString().padLeft(2, "0")}:${DateTime.now().minute.toString().padLeft(2, "0")}:${DateTime.now().second.toString().padLeft(2, "0")}",
      //"17:45:00",
      "Elevado",
      true,
      false,
      "este es otro insert");
  GlucoseLogDAO glucoseLogDAO = GlucoseLogDAO();
  //await glucoseLogDAO.insert(logModel2);
  print(await glucoseLogDAO.getTodayLogs());
  print(await glucoseLogDAO.getWeekLogs());

  InsulinLogDAOFB insulinLogDAOFB = InsulinLogDAOFB();
  InsulinLogModel insulinLogModel = InsulinLogModel.newEntity(
      "9ZHHlxtd9ThGLNRD8ZRhhEu0uVm1",
      5.5,
      DateFormat("yyyy-MM-dd").format(DateTime.now()),
      "${DateTime.now().hour.toString().padLeft(2, "0")}:${DateTime.now().minute.toString().padLeft(2, "0")}:${DateTime.now().second.toString().padLeft(2, "0")}",
      "Muslo derecho");
  //insulinLogDAOFB.insert(insulinLogModel);
  print(await insulinLogDAOFB.getLast7DaysLogs());

  final connectivity = await Connectivity().checkConnectivity();
  print(connectivity);
  //print(await AuthServiceManager.getCurrentUserUID());

  InsulinDAOFB insulinDAOFB = InsulinDAOFB();
  InsulinModel insulinModel = InsulinModel.newEntity(
      "9ZHHlxtd9ThGLNRD8ZRhhEu0uVm1", "12:00", "00:00", 125, 76);
  //insulinDAOFB.insert(insulinModel);

  /*
  FoodDAOFB foodDao = FoodDAOFB();
  await foodDao.insert(FoodModel.newEntity("allDB", 100, "Carbohidratos"));
  
  await foodDao.insert(FoodModel.newEntity("allDB", 80, "Arroz"));
  await foodDao.insert(FoodModel.newEntity("allDB", 32, "Platanos"));
  await foodDao.insert(FoodModel.newEntity("allDB", 2, "Alcachofas"));
  */
  //-----------------------------------------------------------------------------------------------------------------
  await requestNotificationPermission();
  await InsulinNotifications.initNotificationConfig();

  if (AuthServiceManager.checkIfLogged()) {
    runApp(MaterialApp(
        home: DrawerScaffold(child: BackgroundBase(child: Homepage())),
        debugShowCheckedModeBanner: false));
  } else {
    runApp(MaterialApp(home: Welcomepage(), debugShowCheckedModeBanner: false));
  }
}

Future<void> requestNotificationPermission() async {
  if (await Permission.notification.isDenied) {
    await Permission.notification.request();
  }
}
