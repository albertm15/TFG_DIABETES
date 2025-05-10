import 'package:diabetes_tfg_app/auxiliarResources/undefinedTypeLog.dart';
import 'package:diabetes_tfg_app/pages/insulinLogDetails.dart';
import 'package:diabetes_tfg_app/widgets/backgroundBase.dart';
import 'package:diabetes_tfg_app/widgets/drawerScaffold.dart';
import 'package:flutter/material.dart';

class InsulinListTile extends StatelessWidget {
  final UndefinedTypeLog log;
  const InsulinListTile({required this.log});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      color: const Color.fromARGB(255, 85, 42, 196),
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/images/Insulin_image_white.png',
              width: 40,
              height: 40,
            ),
          ],
        ),
        title: Text(
          '${log.value} unidades ${log.category}',
          style: TextStyle(color: Colors.white),
        ),
        subtitle: Text(
          //'${DateFormat('dd/MM/yyyy HH:mm').format(log.dateTime)}',
          "${log.dateTime}",
          style: TextStyle(color: Colors.white),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.arrow_forward_ios_rounded, color: Colors.white),
            Text(
              "Detalles",
              style: TextStyle(color: Colors.white),
            )
          ],
        ),
        onTap: () {
          print("ver detalles de ${log.id}");
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => DrawerScaffold(
                          child: BackgroundBase(
                        child: InsulinLogDetails(
                          id: log.id,
                        ),
                      ))));
        },
      ),
    );
  }
}
