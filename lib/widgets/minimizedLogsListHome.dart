import 'dart:ui';
import 'package:diabetes_tfg_app/auxiliarResources/undefinedTypeLog.dart';
import 'package:diabetes_tfg_app/models/InsulinLogModel.dart';
import 'package:diabetes_tfg_app/models/dietLogModel.dart';
import 'package:diabetes_tfg_app/models/exerciceLogModel.dart';
import 'package:diabetes_tfg_app/models/gluoseLogModel.dart';
import 'package:diabetes_tfg_app/pages/allLogsPage.dart';
import 'package:diabetes_tfg_app/widgets/backgroundBase.dart';
import 'package:diabetes_tfg_app/widgets/dietListTile.dart';
import 'package:diabetes_tfg_app/widgets/drawerScaffold.dart';
import 'package:diabetes_tfg_app/widgets/exerciceListTile.dart';
import 'package:diabetes_tfg_app/widgets/glucoseListTile.dart';
import 'package:diabetes_tfg_app/widgets/insulinListTile.dart';
import 'package:flutter/material.dart';

class MinimizedLogsListHome extends StatelessWidget {
  final List<GlucoseLogModel> glucoseLogs;
  final List<InsulinLogModel> insulinLogs;
  final List<DietLogModel> dietLogs;
  final List<ExerciceLogModel> exerciceLogs;

  const MinimizedLogsListHome(
      {required this.glucoseLogs,
      required this.insulinLogs,
      required this.dietLogs,
      required this.exerciceLogs});

  List<UndefinedTypeLog> sortAllLogs() {
    List<UndefinedTypeLog> allLogs = [];
    for (GlucoseLogModel log in this.glucoseLogs) {
      String dateTime = "${log.date} ${log.time}";
      allLogs.add(UndefinedTypeLog(
          id: log.id,
          dateTime: dateTime,
          log: log,
          type: "glucose",
          category: log.category,
          value: log.glucoseValue.toDouble()));
    }

    for (InsulinLogModel log in this.insulinLogs) {
      String dateTime = "${log.date} ${log.time}";
      allLogs.add(UndefinedTypeLog(
          id: log.id,
          dateTime: dateTime,
          log: log,
          type: "insulin",
          category: log.location,
          value: log.fastActingInsulinConsumed));
    }

    for (DietLogModel log in this.dietLogs) {
      String dateTime = "${log.date} ${log.time}";
      allLogs.add(UndefinedTypeLog(
          id: log.id,
          dateTime: dateTime,
          log: log,
          type: "diet",
          category: "",
          value: log.totalCarbs.toDouble()));
    }

    for (ExerciceLogModel log in this.exerciceLogs) {
      String dateTime = "${log.date} ${log.time}";
      allLogs.add(UndefinedTypeLog(
          id: log.id,
          dateTime: dateTime,
          log: log,
          type: "exercice",
          category: log.category,
          value: log.duration.toDouble()));
    }

    allLogs.sort((a, b) => -a.dateTime.compareTo(b.dateTime));
    return allLogs;
  }

  DateTime parseDateTime(String date, String time) {
    List<String> dateSplit = date.split("-");
    List<String> timeSplit = time.split(":");
    return DateTime(
        int.parse(dateSplit[2]),
        int.parse(dateSplit[1]),
        int.parse(dateSplit[0]),
        int.parse(timeSplit[0]),
        int.parse(timeSplit[1]),
        int.parse(timeSplit[2]));
  }

  @override
  Widget build(BuildContext context) {
    List<UndefinedTypeLog> allLogs = sortAllLogs();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
            padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Registros del día",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                IconButton(
                    onPressed: () {
                      print("Ver mas logs");
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DrawerScaffold(
                                  child:
                                      BackgroundBase(child: AllLogsPage()))));
                    },
                    icon: Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: Colors.black,
                    )),
              ],
            )),
        Expanded(
          child: ListView.builder(
            itemCount: allLogs.length,
            itemBuilder: (context, index) {
              final log = allLogs[index];
              if (log.type == "glucose") {
                return GlucoseListTile(log: log);
              } else if (log.type == "insulin") {
                return InsulinListTile(log: log);
              } else if (log.type == "diet") {
                return DietListTile(log: log);
              } else if (log.type == "exercice") {
                return ExerciceListTile(log: log);
              } else {
                return SizedBox.shrink(); // para evitar errores
              }
            },
          ),
        ),
      ],
    );
  }
}
