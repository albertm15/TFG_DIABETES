import 'package:diabetes_tfg_app/auxiliarResources/undefinedTypeLog.dart';
import 'package:diabetes_tfg_app/pages/reminderDetails.dart';
import 'package:diabetes_tfg_app/widgets/backgroundBase.dart';
import 'package:diabetes_tfg_app/widgets/drawerScaffold.dart';
import 'package:flutter/material.dart';

class ReminderListTile extends StatelessWidget {
  final UndefinedTypeLog log;
  const ReminderListTile({required this.log});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: const Color.fromARGB(255, 85, 42, 196),
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.alarm_rounded,
              color: Colors.white,
            ),
          ],
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${log.category}     ',
              style: TextStyle(color: Colors.white),
            ),
            Text(
              "${log.dateTime}",
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
        onTap: () {
          print("ver detalles de ${log.id}");
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
      ),
    );
  }
}
