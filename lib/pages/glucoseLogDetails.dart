import 'package:diabetes_tfg_app/database/firebase/authServiceManager.dart';
import 'package:diabetes_tfg_app/database/firebase/glucoseLogDAO.dart';
import 'package:diabetes_tfg_app/database/local/glucoseLogDAO.dart';
import 'package:diabetes_tfg_app/models/gluoseLogModel.dart';
import 'package:diabetes_tfg_app/widgets/backgroundBase.dart';
import 'package:diabetes_tfg_app/widgets/drawerScaffold.dart';
import 'package:diabetes_tfg_app/widgets/lowerNavBar.dart';
import 'package:diabetes_tfg_app/widgets/screenMargins.dart';
import 'package:diabetes_tfg_app/widgets/upperNavBar.dart';
import 'package:flutter/material.dart';

class GlucoseLogDetails extends StatelessWidget {
  final String id;
  const GlucoseLogDetails({required this.id});
  @override
  Widget build(BuildContext context) {
    return DrawerScaffold(
        child: BackgroundBase(
            child: Scaffold(
      appBar: UpperNavBar(pageName: "Detalles de glucosa"),
      body: BackgroundBase(
          child: Center(child: _GlucoseLogDetailsWidget(id: this.id))),
      bottomNavigationBar: LowerNavBar(),
      backgroundColor: Colors.transparent,
    )));
  }
}

class _GlucoseLogDetailsWidget extends StatefulWidget {
  final String id;
  const _GlucoseLogDetailsWidget({required this.id});

  @override
  _GlucoseLogDetailsWidgetState createState() =>
      _GlucoseLogDetailsWidgetState();
}

class _GlucoseLogDetailsWidgetState extends State<_GlucoseLogDetailsWidget> {
  List<GlucoseLogModel> glucoseLog = [];
  int glucoseValue = 0;
  String date = "";
  String time = "";
  String category = "";
  bool hyperglucemia = false;
  bool hypoglucemia = false;
  String sensations = "";
  void loadData() async {
    if (AuthServiceManager.checkIfLogged()) {
      GlucoseLogDAOFB dao = GlucoseLogDAOFB();
      glucoseLog = await dao.getById(widget.id);
    } else {
      GlucoseLogDAO dao = GlucoseLogDAO();
      glucoseLog = await dao.getById(widget.id);
    }

    setState(() {
      glucoseValue = glucoseLog[0].glucoseValue;
      date = glucoseLog[0].date;
      time = glucoseLog[0].time;
      category = glucoseLog[0].category;
      hyperglucemia = glucoseLog[0].hyperglucemia;
      hypoglucemia = glucoseLog[0].hypoglucemia;
      sensations = glucoseLog[0].sensations;
    });
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

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
    return ScreenMargins(
        child: Center(
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 8),
            Container(
                height: 100,
                width: 230,
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        getIconForCategory(category),
                        color: Colors.white,
                        size:
                            50, // puedes ajustar el tamaño para mejor alineación
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          SizedBox(width: 4),
                          Text(
                            "$glucoseValue",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 4),
                          Text(
                            "mg/dl",
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
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Nivel: ",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    Text(
                      "$category",
                      style: TextStyle(fontSize: 25),
                    ),
                    Icon(
                      getIconForCategory(category),
                      size: 30,
                    )
                  ],
                )
              ],
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Hiperglucemia: ",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    Text(
                      hyperglucemia ? "Si" : "No",
                      style: TextStyle(fontSize: 25),
                    ),
                    Icon(
                      hyperglucemia ? Icons.check_rounded : Icons.close_rounded,
                      size: 30,
                    )
                  ],
                )
              ],
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Hipoglucemia: ",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    Text(
                      hypoglucemia ? "Si" : "No",
                      style: TextStyle(fontSize: 25),
                    ),
                    Icon(
                      hypoglucemia ? Icons.check_rounded : Icons.close_rounded,
                      size: 30,
                    )
                  ],
                )
              ],
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Fecha: ",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
                Text(
                  "$date",
                  style: TextStyle(fontSize: 25),
                )
              ],
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Hora: ",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
                Text(
                  "$time",
                  style: TextStyle(fontSize: 25),
                )
              ],
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Sensaciones: ",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                )
              ],
            ),
            SizedBox(height: 4),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              height: 180,
              width: 350,
              decoration: BoxDecoration(
                color: Colors.transparent,
                border: Border.all(color: Colors.black, width: 1.5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '$sensations',
                style: TextStyle(fontSize: 16),
              ),
            )
          ]),
    ));
  }
}
