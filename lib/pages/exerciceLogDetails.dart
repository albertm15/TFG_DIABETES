import 'package:diabetes_tfg_app/database/firebase/authServiceManager.dart';
import 'package:diabetes_tfg_app/database/firebase/exerciceLogDAO.dart';
import 'package:diabetes_tfg_app/database/local/exerciceLogDAO.dart';
import 'package:diabetes_tfg_app/models/exerciceLogModel.dart';
import 'package:diabetes_tfg_app/pages/exerciceLogForm.dart';
import 'package:diabetes_tfg_app/widgets/backgroundBase.dart';
import 'package:diabetes_tfg_app/widgets/drawerScaffold.dart';
import 'package:diabetes_tfg_app/widgets/lowerNavBar.dart';
import 'package:diabetes_tfg_app/widgets/screenMargins.dart';
import 'package:diabetes_tfg_app/widgets/upperNavBar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ExerciceLogDetails extends StatelessWidget {
  final String id;
  const ExerciceLogDetails({required this.id});
  @override
  Widget build(BuildContext context) {
    return DrawerScaffold(
        child: BackgroundBase(
            child: Scaffold(
      appBar: UpperNavBar(pageName: "Detalles de ejercicio"),
      body: BackgroundBase(
          child: Center(child: _ExerciceLogDetailsWidget(id: this.id))),
      bottomNavigationBar: LowerNavBar(selectedSection: "exercice"),
      backgroundColor: Colors.transparent,
    )));
  }
}

class _ExerciceLogDetailsWidget extends StatefulWidget {
  final String id;
  const _ExerciceLogDetailsWidget({required this.id});

  @override
  _ExerciceLogDetailsWidgetState createState() =>
      _ExerciceLogDetailsWidgetState();
}

class _ExerciceLogDetailsWidgetState extends State<_ExerciceLogDetailsWidget> {
  String category = "";
  int duration = 0;
  List<ExerciceLogModel> log = [];
  String before = "";
  String after = "";

  IconData getIcon() {
    switch (category) {
      case "Caminar" || "Correr":
        return FontAwesomeIcons.personRunning;
      case "Ciclismo":
        return Icons.directions_bike;
      case "Pesas":
        return FontAwesomeIcons.dumbbell;
      case "Otro":
        return Icons.more_horiz;
      default:
        return Icons.more_horiz;
    }
  }

  Future<void> loadData() async {
    if (AuthServiceManager.checkIfLogged()) {
      ExerciceLogDAOFB dao = ExerciceLogDAOFB();
      log = await dao.getById(widget.id);
    } else {
      ExerciceLogDAO dao = ExerciceLogDAO();
      log = await dao.getById(widget.id);
    }
    setState(() {
      category = log.first.category;
      duration = log.first.duration;
      before = log.first.beforeSensations;
      after = log.first.afterSensations;
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
              'Ejercicio realizado:',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(getIcon(), size: 40, color: Colors.black),
                SizedBox(width: 25),
                Text("$category", style: TextStyle(fontSize: 25))
              ],
            ),
            SizedBox(height: 25),

            // Duración
            Text(
              'Duración:',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Container(
                height: 70,
                width: 170,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color.fromARGB(255, 95, 33, 153),
                      Color.fromARGB(255, 85, 42, 196),
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          SizedBox(width: 4),
                          Text(
                            "$duration",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 4),
                          Text(
                            "minutos",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                )),
            SizedBox(height: 30),

            // Sensaciones antes
            Text('Sensaciones antes del ejercicio:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            SizedBox(height: 8),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              height: 120,
              width: 350,
              decoration: BoxDecoration(
                color: Colors.transparent,
                border: Border.all(color: Colors.black, width: 1.5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '$before',
                style: TextStyle(fontSize: 16),
              ),
            ),

            SizedBox(height: 20),

            // Sensaciones después
            Text('Sensaciones después del ejercicio:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            SizedBox(height: 8),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              height: 120,
              width: 350,
              decoration: BoxDecoration(
                color: Colors.transparent,
                border: Border.all(color: Colors.black, width: 1.5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '$after',
                style: TextStyle(fontSize: 16),
              ),
            )
          ],
        ),
      ),
    ));
  }
}
