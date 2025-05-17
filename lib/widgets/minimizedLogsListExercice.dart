import 'dart:ui';
import 'package:diabetes_tfg_app/auxiliarResources/undefinedTypeLog.dart';
import 'package:diabetes_tfg_app/models/exerciceLogModel.dart';
import 'package:diabetes_tfg_app/pages/exerciceLogForm.dart';
import 'package:diabetes_tfg_app/pages/glucoseFormPage.dart';
import 'package:diabetes_tfg_app/widgets/backgroundBase.dart';
import 'package:diabetes_tfg_app/widgets/drawerScaffold.dart';
import 'package:diabetes_tfg_app/widgets/exerciceListTile.dart';
import 'package:flutter/material.dart';

class MinimizedLogsListExercice extends StatelessWidget {
  final List<ExerciceLogModel> logs;

  const MinimizedLogsListExercice({
    required this.logs,
  });

  List<UndefinedTypeLog> sortAllLogs() {
    List<UndefinedTypeLog> allLogs = [];
    for (ExerciceLogModel log in this.logs) {
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
                  "Registros de la semana",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                IconButton(
                    onPressed: () {
                      print("añadir exercice log");
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DrawerScaffold(
                                  child: BackgroundBase(
                                      child: ExerciseLogForm()))));
                    },
                    icon: Icon(
                      Icons.add_box_outlined,
                      color: Colors.black,
                    )),
              ],
            )),
        Expanded(
          child: ListView.builder(
            itemCount: allLogs.length,
            itemBuilder: (context, index) {
              final log = allLogs[index];
              if (log.type == "exercice") {
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
