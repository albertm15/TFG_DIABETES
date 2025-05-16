import 'dart:ui';
import 'package:diabetes_tfg_app/auxiliarResources/undefinedTypeLog.dart';
import 'package:diabetes_tfg_app/models/reminderModel.dart';
import 'package:diabetes_tfg_app/pages/addReminder.dart';
import 'package:diabetes_tfg_app/widgets/backgroundBase.dart';
import 'package:diabetes_tfg_app/widgets/drawerScaffold.dart';
import 'package:diabetes_tfg_app/widgets/reminderListTile.dart';
import 'package:flutter/material.dart';

class MinimizedReminderList extends StatelessWidget {
  final List<ReminderModel> reminders;

  const MinimizedReminderList({
    required this.reminders,
  });

  List<UndefinedTypeLog> sortAllLogs() {
    List<UndefinedTypeLog> allLogs = [];
    for (ReminderModel log in this.reminders) {
      String dateTime = "${log.date} ${log.time}";
      allLogs.add(UndefinedTypeLog(
          id: log.id,
          dateTime: dateTime,
          log: log,
          type: "reminder",
          category: log.title,
          value: 0));
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
                  "Recordatorios",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                IconButton(
                    onPressed: () {
                      print("añadir recordatorio");
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DrawerScaffold(
                                  child:
                                      BackgroundBase(child: AddReminder()))));
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
              if (log.type == "reminder") {
                return ReminderListTile(log: log);
              } else {
                return SizedBox.shrink();
              }
            },
          ),
        ),
      ],
    );
  }
}
