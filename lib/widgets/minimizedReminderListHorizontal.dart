import 'package:diabetes_tfg_app/pages/reminderDetails.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:diabetes_tfg_app/auxiliarResources/undefinedTypeLog.dart';
import 'package:diabetes_tfg_app/models/reminderModel.dart';
import 'package:diabetes_tfg_app/pages/addReminder.dart';
import 'package:diabetes_tfg_app/widgets/backgroundBase.dart';
import 'package:diabetes_tfg_app/widgets/drawerScaffold.dart';

class MinimizedReminderListHorizontal extends StatelessWidget {
  final List<ReminderModel> reminders;

  const MinimizedReminderListHorizontal({
    required this.reminders,
  });

  List<UndefinedTypeLog> sortAllLogs() {
    List<UndefinedTypeLog> allLogs = [];
    for (ReminderModel log in reminders) {
      String dateTime = "${log.date} ${log.time}";
      allLogs.add(UndefinedTypeLog(
        id: log.id,
        dateTime: dateTime,
        log: log,
        type: "reminder",
        category: log.title,
        value: 0,
      ));
    }

    allLogs.sort((a, b) => a.dateTime.compareTo(b.dateTime));
    return allLogs;
  }

  String formatDay(String date) {
    DateTime parsed = DateFormat("dd-MM-yyyy").parse(date);
    DateTime today = DateTime.now();
    if (parsed.day == today.day &&
        parsed.month == today.month &&
        parsed.year == today.year) {
      return "Hoy";
    } else {
      return DateFormat.EEEE('es_ES').format(parsed).split(",")[0];
    }
  }

  @override
  Widget build(BuildContext context) {
    List<UndefinedTypeLog> allLogs = sortAllLogs();

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Recordatorios de la semana",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              IconButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DrawerScaffold(
                        child: BackgroundBase(
                            child: AddReminder(
                          initialId: "",
                        )),
                      ),
                    ),
                  );
                },
                icon: Icon(Icons.add_box_outlined, color: Colors.black),
              )
            ],
          ),
        ),
        SizedBox(
          height: 160,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: allLogs.length,
            itemBuilder: (context, index) {
              final log = allLogs[index];
              final reminder = log.log as ReminderModel;

              return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DrawerScaffold(
                                      child: BackgroundBase(
                                    child: ReminderDetails(
                                      id: log.id,
                                    ),
                                  ))));
                    },
                    child: Container(
                      width: 140,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        gradient: LinearGradient(
                          colors: [
                            Color.fromARGB(255, 95, 33, 153),
                            Color.fromARGB(255, 85, 42, 196),
                          ],
                          stops: [0, 1.0],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        border: Border.all(color: Colors.grey.shade300),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.white,
                              offset: Offset(1, 1),
                              blurRadius: 4)
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(Icons.notifications,
                                size: 30, color: Colors.white),
                            Text(reminder.title,
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                    color: Colors.white),
                                textAlign: TextAlign.center),
                            Text(reminder.time,
                                style: TextStyle(
                                    fontSize: 16, color: Colors.white)),
                            Text(formatDay(reminder.date),
                                style: TextStyle(
                                    fontSize: 14,
                                    color: const Color.fromARGB(
                                        255, 207, 207, 207))),
                          ],
                        ),
                      ),
                    ),
                  ));
            },
          ),
        ),
      ],
    );
  }
}
