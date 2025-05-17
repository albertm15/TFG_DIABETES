import 'package:diabetes_tfg_app/auxiliarResources/undefinedTypeLog.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ExerciceListTile extends StatelessWidget {
  final UndefinedTypeLog log;
  const ExerciceListTile({required this.log});

  IconData getIcon(String category) {
    switch (category) {
      case "Ciclismo":
        return Icons.directions_bike;
      case "Pesas":
        return FontAwesomeIcons.dumbbell;
      case "Correr":
        return FontAwesomeIcons.personRunning;
      default:
        return Icons.directions_run_rounded;
    }
  }

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
              getIcon(log.category),
              color: Colors.white,
            ),
          ],
        ),
        title: Text(
          '${log.category}   ${log.value.toInt()} minutos',
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
        },
      ),
    );
  }
}
