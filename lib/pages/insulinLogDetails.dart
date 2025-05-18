import 'package:diabetes_tfg_app/database/firebase/authServiceManager.dart';
import 'package:diabetes_tfg_app/database/firebase/insulinLogDAO.dart';
import 'package:diabetes_tfg_app/database/local/insulinLogDAO.dart';
import 'package:diabetes_tfg_app/models/InsulinLogModel.dart';
import 'package:diabetes_tfg_app/widgets/backgroundBase.dart';
import 'package:diabetes_tfg_app/widgets/drawerScaffold.dart';
import 'package:diabetes_tfg_app/widgets/lowerNavBar.dart';
import 'package:diabetes_tfg_app/widgets/screenMargins.dart';
import 'package:diabetes_tfg_app/widgets/upperNavBar.dart';
import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';

class InsulinLogDetails extends StatelessWidget {
  final String id;
  const InsulinLogDetails({required this.id});
  @override
  Widget build(BuildContext context) {
    return DrawerScaffold(
        child: BackgroundBase(
            child: Scaffold(
      appBar: UpperNavBar(pageName: "Detalles de insulina"),
      body: BackgroundBase(
          child: Center(child: _InsulinLogDetailsWidget(id: this.id))),
      bottomNavigationBar: LowerNavBar(selectedSection: "insulin"),
      backgroundColor: Colors.transparent,
    )));
  }
}

class _InsulinLogDetailsWidget extends StatefulWidget {
  final String id;
  const _InsulinLogDetailsWidget({required this.id});

  @override
  __InsulinLogDetailsWidgetState createState() =>
      __InsulinLogDetailsWidgetState();
}

class __InsulinLogDetailsWidgetState extends State<_InsulinLogDetailsWidget> {
  List<InsulinLogModel> insulinLog = [];
  String date = "";
  String time = "";
  double fastActingInsulinConsumed = 0.0;
  String location = "";
  String currentCameraOrbit = "110deg 90deg 0.02m";
  String currentCameraTarget = '0m 1.3m 0m';

  List<String> allCameraOrbits = [
    "110deg 90deg 0.02m", // Brazo izq.
    "250deg 90deg 0.02m", // Brazo der.
    "140deg 70deg 0.1m", // Glúteo izq.
    "220deg 70deg 0.1m", // Glúteo der.
    "50deg 100deg 1.3m", // Muslo izq.
    "310deg 100deg 1.3m", // Muslo der.
    "0deg 75deg 1.0m",
  ];
  List<String> allCameraTargets = [
    '0m 1.3m 0m', // Brazo izq.
    '0m 1.3m 0m', // Brazo der.
    '0m 0.9m 0m', // Glúteo izq.
    '0m 0.9m 0m', // Glúteo der.
    '0m 0.7m 0m', // Muslo izq.
    '0m 0.7m 0m', // Muslo der.
    '0m 1.0m 0m',
  ];

  void loadData() async {
    if (AuthServiceManager.checkIfLogged()) {
      InsulinLogDAOFB dao = InsulinLogDAOFB();
      insulinLog = await dao.getById(widget.id);
    } else {
      InsulinLogDAO dao = InsulinLogDAO();
      insulinLog = await dao.getById(widget.id);
    }

    setState(() {
      date = insulinLog[0].date;
      time = insulinLog[0].time;
      fastActingInsulinConsumed = insulinLog[0].fastActingInsulinConsumed;
      location = insulinLog[0].location;
      switch (location) {
        case "Brazo izq.":
          currentCameraOrbit = allCameraOrbits[0];
          currentCameraTarget = allCameraTargets[0];
        case "Brazo der.":
          currentCameraOrbit = allCameraOrbits[1];
          currentCameraTarget = allCameraTargets[1];
        case "Gluteo izq.":
          currentCameraOrbit = allCameraOrbits[2];
          currentCameraTarget = allCameraTargets[2];
        case "Gluteo der.":
          currentCameraOrbit = allCameraOrbits[3];
          currentCameraTarget = allCameraTargets[3];
        case "Muslo izq.":
          currentCameraOrbit = allCameraOrbits[4];
          currentCameraTarget = allCameraTargets[4];
        case "Muslo der.":
          currentCameraOrbit = allCameraOrbits[5];
          currentCameraTarget = allCameraTargets[5];
        case "Barriga":
          currentCameraOrbit = allCameraOrbits[6];
          currentCameraTarget = allCameraTargets[6];
        default:
      }
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
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          SizedBox(width: 4),
                          Text(
                            "$fastActingInsulinConsumed",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 4),
                          Text(
                            " unidades",
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
                  "Localización inyectada: ",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "$location",
                  style: TextStyle(fontSize: 25),
                )
              ],
            ),
            SizedBox(height: 4),
            Container(
              height: 190,
              child: ModelViewer(
                src: "assets/3dModels/maleBody.glb",
                key: ValueKey(currentCameraOrbit),
                cameraControls: true,
                cameraOrbit: currentCameraOrbit,
                fieldOfView: "15deg",
                cameraTarget: currentCameraTarget,
              ),
            ),
          ]),
    ));
  }
}
