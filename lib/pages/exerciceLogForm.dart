import 'package:diabetes_tfg_app/database/firebase/authServiceManager.dart';
import 'package:diabetes_tfg_app/database/firebase/exerciceLogDAO.dart';
import 'package:diabetes_tfg_app/database/local/exerciceLogDAO.dart';
import 'package:diabetes_tfg_app/models/exerciceLogModel.dart';
import 'package:diabetes_tfg_app/pages/exerciceAndHealthMainPage.dart';
import 'package:diabetes_tfg_app/widgets/backgroundBase.dart';
import 'package:diabetes_tfg_app/widgets/drawerScaffold.dart';
import 'package:diabetes_tfg_app/widgets/lowerNavBar.dart';
import 'package:diabetes_tfg_app/widgets/screenMargins.dart';
import 'package:diabetes_tfg_app/widgets/upperNavBar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class ExerciseLogForm extends StatefulWidget {
  const ExerciseLogForm({super.key});

  @override
  State<ExerciseLogForm> createState() => _ExerciseLogFormState();
}

class _ExerciseLogFormState extends State<ExerciseLogForm> {
  final TextEditingController beforeController = TextEditingController();
  final TextEditingController afterController = TextEditingController();
  final TextEditingController duration = TextEditingController();
  String selectedActivity = 'Caminar';

  final List<Map<String, dynamic>> activities = [
    {'label': 'Caminar', 'icon': FontAwesomeIcons.personRunning},
    {'label': 'Ciclismo', 'icon': Icons.directions_bike},
    {'label': 'Pesas', 'icon': FontAwesomeIcons.dumbbell},
    {'label': 'Otro', 'icon': Icons.more_horiz},
  ];

  void saveData() async {
    if (AuthServiceManager.checkIfLogged()) {
      ExerciceLogDAOFB dao = ExerciceLogDAOFB();
      ExerciceLogModel log = ExerciceLogModel.newEntity(
        AuthServiceManager.getCurrentUserUID(),
        selectedActivity,
        int.parse(duration.text),
        beforeController.text,
        afterController.text,
        DateFormat("yyyy-MM-dd").format(DateTime.now()),
        "${DateTime.now().hour.toString().padLeft(2, "0")}:${DateTime.now().minute.toString().padLeft(2, "0")}:${DateTime.now().second.toString().padLeft(2, "0")}",
      );
      await dao.insert(log);
    } else {
      ExerciceLogDAO dao = ExerciceLogDAO();
      ExerciceLogModel log = ExerciceLogModel.newEntity(
        "localUser",
        selectedActivity,
        int.parse(duration.text),
        beforeController.text,
        afterController.text,
        DateFormat("yyyy-MM-dd").format(DateTime.now()),
        "${DateTime.now().hour.toString().padLeft(2, "0")}:${DateTime.now().minute.toString().padLeft(2, "0")}:${DateTime.now().second.toString().padLeft(2, "0")}",
      );
      await dao.insert(log);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UpperNavBar(pageName: "Añadir registro de ejercicio"),
      body: ScreenMargins(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Selección de actividad
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: activities.map((activity) {
                    final isSelected = selectedActivity == activity['label'];
                    return GestureDetector(
                      onTap: () =>
                          setState(() => selectedActivity = activity['label']),
                      child: Container(
                        height: 80,
                        width: 80,
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Color(0xFF3C37FF)
                              : Color.fromARGB(255, 118, 118, 118),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              activity['icon'],
                              size: 32,
                              color: Colors.white,
                            ),
                            SizedBox(height: 4),
                            Text(activity['label'],
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white,
                                )),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),

                SizedBox(height: 24),

                // Duración
                Center(
                  child: Container(
                    height: 70,
                    width: 200,
                    child: TextFormField(
                      controller: duration,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                      decoration: InputDecoration(
                          labelText: "Minutos",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          counterText: ""),
                    ),
                  ),
                ),

                SizedBox(height: 24),

                // Sensaciones antes
                Text("Sensaciones antes del ejercicio",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                TextField(
                  controller: beforeController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: "Me he sentido...",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                ),

                SizedBox(height: 24),

                // Sensaciones después
                Text("Sensaciones después del ejercicio",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                TextField(
                  controller: afterController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: "Me he sentido...",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                ),

                SizedBox(height: 24),

                // Botón añadir
                ElevatedButton(
                  onPressed: () {
                    saveData();
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DrawerScaffold(
                                child: BackgroundBase(
                                    child: ExerciceAndHealthMainPage()))));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 85, 42, 196),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  ),
                  child: Text("Añadir", style: TextStyle(fontSize: 22)),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: LowerNavBar(selectedSection: "exercice"),
      backgroundColor: Colors.transparent,
    );
  }
}
