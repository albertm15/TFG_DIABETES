import 'package:diabetes_tfg_app/database/firebase/authServiceManager.dart';
import 'package:diabetes_tfg_app/database/firebase/reminderDAO.dart';
import 'package:diabetes_tfg_app/database/local/reminderDAO.dart';
import 'package:diabetes_tfg_app/models/reminderModel.dart';
import 'package:diabetes_tfg_app/pages/addReminder.dart';
import 'package:diabetes_tfg_app/pages/exerciceLogForm.dart';
import 'package:diabetes_tfg_app/widgets/backgroundBase.dart';
import 'package:diabetes_tfg_app/widgets/drawerScaffold.dart';
import 'package:diabetes_tfg_app/widgets/lowerNavBar.dart';
import 'package:diabetes_tfg_app/widgets/screenMargins.dart';
import 'package:diabetes_tfg_app/widgets/upperNavBar.dart';
import 'package:flutter/material.dart';

class ReminderDetails extends StatelessWidget {
  final String id;
  const ReminderDetails({required this.id});
  @override
  Widget build(BuildContext context) {
    return DrawerScaffold(
        child: BackgroundBase(
            child: Scaffold(
      appBar: UpperNavBar(pageName: "Detalles de recordatorio"),
      body: BackgroundBase(
          child: Center(child: _ReminderDetailsWidget(id: this.id))),
      bottomNavigationBar: LowerNavBar(selectedSection: "exercice"),
      backgroundColor: Colors.transparent,
    )));
  }
}

class _ReminderDetailsWidget extends StatefulWidget {
  final String id;
  const _ReminderDetailsWidget({required this.id});

  @override
  _ReminderDetailsWidgetState createState() => _ReminderDetailsWidgetState();
}
/*
class _ReminderDetailsWidgetState extends State<_ReminderDetailsWidget> {
  String title = "";
  List<ReminderModel> log = [];
  String date = "";
  String time = "";
  bool repeat = false;
  String repeatConfig = "";

  Future<void> loadData() async {
    if (AuthServiceManager.checkIfLogged()) {
      ReminderDAOFB dao = ReminderDAOFB();
      log = await dao.getById(widget.id);
    } else {
      ReminderDAO dao = ReminderDAO();
      log = await dao.getById(widget.id);
    }
    setState(() {
      title = log.first.title;
      date = log.first.date;
      time = log.first.time;
      repeat = log.first.repeat;
      repeatConfig = log.first.repeatConfig;
    });
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenMargins(
        child: SingleChildScrollView(
      child: Center(
        child: Column(
          children: [
            GestureDetector(
              onTap: () {},
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text("Modificar"),
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => BackgroundBase(
                                      child: ExerciseLogForm(
                                    initialId: log.first.id,
                                  ))));
                    },
                  ),
                ],
              ),
            ),
            Text(
              'Titulo:',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Text("$title", style: TextStyle(fontSize: 25))],
            ),
            SizedBox(height: 12),

            // Duración
            Text(
              'Fecha:',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Text("$date", style: TextStyle(fontSize: 25))],
            ),
            SizedBox(height: 12),
            // Duración
            Text(
              'Hora:',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Text("$time", style: TextStyle(fontSize: 25))],
            ),
            SizedBox(height: 12),
            // Duración
            Text(
              'Repetir:',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(repeat ? "Si" : "No", style: TextStyle(fontSize: 25)),
                Icon(
                  repeat ? Icons.check_rounded : Icons.close_rounded,
                  color: Colors.black,
                ),
              ],
            ),
            SizedBox(height: 12),

            Text(
              'Configuración de repetición:',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("$repeatConfig", style: TextStyle(fontSize: 25)),
              ],
            ),
            SizedBox(height: 12),
          ],
        ),
      ),
    ));
  }
}
*/

class _ReminderDetailsWidgetState extends State<_ReminderDetailsWidget> {
  String title = "";
  List<ReminderModel> log = [];
  String date = "";
  String time = "";
  bool repeat = false;
  String repeatConfig = "";

  Future<void> loadData() async {
    if (AuthServiceManager.checkIfLogged()) {
      ReminderDAOFB dao = ReminderDAOFB();
      log = await dao.getById(widget.id);
    } else {
      ReminderDAO dao = ReminderDAO();
      log = await dao.getById(widget.id);
    }
    setState(() {
      title = log.first.title;
      date = log.first.date;
      time = log.first.time;
      repeat = log.first.repeat;
      repeatConfig = log.first.repeatConfig;
    });
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Widget _infoCard(String label, String value, {IconData? icon}) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        child: Row(
          children: [
            if (icon != null)
              Icon(icon, size: 28, color: Color.fromARGB(255, 85, 42, 196)),
            if (icon != null) SizedBox(width: 12),
            Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(label,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    SizedBox(height: 4),
                    Text(value, style: TextStyle(fontSize: 20)),
                  ]),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScreenMargins(
      child: SingleChildScrollView(
        child: Column(
          children: [
            // Editar botón
            Align(
              alignment: Alignment.topRight,
              child: TextButton.icon(
                onPressed: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => BackgroundBase(
                                child: AddReminder(initialId: log.first.id),
                              )));
                },
                icon: Icon(Icons.edit, color: Colors.black),
                label: Text("Modificar",
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.bold)),
              ),
            ),

            _infoCard("Título", title, icon: Icons.title),
            _infoCard("Fecha", date, icon: Icons.date_range),
            _infoCard("Hora", time, icon: Icons.access_time),
            _infoCard("Repetir", repeat ? "Sí" : "No",
                icon: repeat ? Icons.repeat : Icons.repeat_on_outlined),
            if (repeat)
              _infoCard("Configuración de repetición", repeatConfig,
                  icon: Icons.settings_backup_restore),
          ],
        ),
      ),
    );
  }
}
