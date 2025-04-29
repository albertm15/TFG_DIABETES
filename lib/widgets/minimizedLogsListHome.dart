import 'dart:ui';

import 'package:diabetes_tfg_app/auxiliarResources/undefinedTypeLog.dart';
import 'package:diabetes_tfg_app/models/InsulinLogModel.dart';
import 'package:diabetes_tfg_app/models/dietLogModel.dart';
import 'package:diabetes_tfg_app/models/exerciceLogModel.dart';
import 'package:diabetes_tfg_app/models/gluoseLogModel.dart';
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
      DateTime dateTime = parseDateTime(log.date, log.time);
      allLogs.add(UndefinedTypeLog(
          id: log.id,
          dateTime: dateTime,
          log: log,
          type: "glucose",
          category: log.category,
          value: log.glucoseValue.toDouble()));
    }

    for (InsulinLogModel log in this.insulinLogs) {
      DateTime dateTime = parseDateTime(log.date, log.time);
      allLogs.add(UndefinedTypeLog(
          id: log.id,
          dateTime: dateTime,
          log: log,
          type: "insulin",
          category: log.location,
          value: log.fastActingInsulinConsumed));
    }

    for (DietLogModel log in this.dietLogs) {
      DateTime dateTime = parseDateTime(log.date, log.time);
      allLogs.add(UndefinedTypeLog(
          id: log.id,
          dateTime: dateTime,
          log: log,
          type: "diet",
          category: "",
          value: log.totalCarbs.toDouble()));
    }

    for (ExerciceLogModel log in this.exerciceLogs) {
      DateTime dateTime = parseDateTime(log.date, log.time);
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
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "Registros de la semana",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
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
                return InsulinListTile(log: log);
              } else if (log.type == "exercice") {
                return InsulinListTile(log: log);
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
