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
  final String initialId;
  const ExerciseLogForm({super.key, required this.initialId});

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

  void loadData() async {
    if (AuthServiceManager.checkIfLogged()) {
      ExerciceLogDAOFB dao = ExerciceLogDAOFB();
      List<ExerciceLogModel> log = await dao.getById(widget.initialId);
      selectedActivity = log.first.category;
      duration.text = log.first.duration.toString();
      beforeController.text = log.first.beforeSensations;
      afterController.text = log.first.afterSensations;
    } else {
      ExerciceLogDAO dao = ExerciceLogDAO();
      List<ExerciceLogModel> log = await dao.getById(widget.initialId);
      selectedActivity = log.first.category;
      duration.text = log.first.duration.toString();
      beforeController.text = log.first.beforeSensations;
      afterController.text = log.first.afterSensations;
    }
    setState(() {});
  }

  void deleteLog() async {
    if (AuthServiceManager.checkIfLogged()) {
      ExerciceLogDAOFB dao = ExerciceLogDAOFB();
      List<ExerciceLogModel> log = await dao.getById(widget.initialId);
      dao.delete(log.first);
    } else {
      ExerciceLogDAO dao = ExerciceLogDAO();
      List<ExerciceLogModel> log = await dao.getById(widget.initialId);
      dao.delete(log.first);
    }
  }

  void saveData() async {
    if (AuthServiceManager.checkIfLogged()) {
      if (widget.initialId != "") {
        ExerciceLogDAOFB dao = ExerciceLogDAOFB();
        List<ExerciceLogModel> log = await dao.getById(widget.initialId);
        log.first.category = selectedActivity;
        log.first.duration = int.parse(duration.text);
        log.first.beforeSensations = beforeController.text;
        log.first.afterSensations = afterController.text;
        await dao.update(log.first);
      } else {
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
      }
    } else {
      if (widget.initialId != "") {
        ExerciceLogDAO dao = ExerciceLogDAO();
        List<ExerciceLogModel> log = await dao.getById(widget.initialId);
        log.first.category = selectedActivity;
        log.first.duration = int.parse(duration.text);
        log.first.beforeSensations = beforeController.text;
        log.first.afterSensations = afterController.text;
        await dao.update(log.first);
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
  }

  @override
  void initState() {
    super.initState();
    if (widget.initialId != "") {
      loadData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UpperNavBar(pageName: "Añadir registro de ejercicio"),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: ScreenMargins(
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
                        onTap: () => setState(
                            () => selectedActivity = activity['label']),
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
                        style: TextStyle(
                            fontSize: 36, fontWeight: FontWeight.bold),
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
                      padding:
                          EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    ),
                    child: Text(widget.initialId != "" ? "Modificar" : "Añadir",
                        style: TextStyle(fontSize: 22)),
                  ),
                  SizedBox(height: 16),
                  widget.initialId != ""
                      ? ElevatedButton(
                          onPressed: () {
                            deleteLog();
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => DrawerScaffold(
                                        child: BackgroundBase(
                                            child:
                                                ExerciceAndHealthMainPage()))));
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: EdgeInsets.symmetric(
                                horizontal: 40, vertical: 15),
                          ),
                          child:
                              Text("Eliminar", style: TextStyle(fontSize: 18)),
                        )
                      : SizedBox()
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: LowerNavBar(selectedSection: "exercice"),
      backgroundColor: Colors.transparent,
    );
  }
}
