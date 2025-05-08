import 'package:diabetes_tfg_app/auxiliarResources/undefinedTypeLog.dart';
import 'package:flutter/material.dart';

class GlucoseListTile extends StatelessWidget {
  final UndefinedTypeLog log;
  const GlucoseListTile({required this.log});

  IconData getIconForCategory(String category) {
    switch (category) {
      case "Elevado":
        return Icons.arrow_upward_rounded;
      case "Bajo":
        return Icons.arrow_downward_rounded;
      default:
        return Icons.arrow_forward_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
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
              Icons.water_drop_outlined,
              color: Colors.white,
            ),
            SizedBox(width: 8), // Espaciado entre los íconos
            Icon(
              getIconForCategory(log.category),
              color: Colors.white,
            ),
          ],
        ),
        title: Text(
          '${log.value}mg/dl ${log.category}',
          style: TextStyle(color: Colors.white),
        ),
        subtitle: Text(
          //'${DateFormat('yyyy/MM/dd HH:mm').format(log.dateTime)}',
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
