import 'package:diabetes_tfg_app/database/firebase/authServiceManager.dart';
import 'package:diabetes_tfg_app/database/firebase/insulinDAO.dart';
import 'package:diabetes_tfg_app/database/firebase/insulinLogDAO.dart';
import 'package:diabetes_tfg_app/database/local/insulinDAO.dart';
import 'package:diabetes_tfg_app/database/local/insulinLogDAO.dart';
import 'package:diabetes_tfg_app/models/InsulinLogModel.dart';
import 'package:diabetes_tfg_app/models/insulinModel.dart';
import 'package:diabetes_tfg_app/pages/insulinMainPage.dart';
import 'package:diabetes_tfg_app/widgets/backgroundBase.dart';
import 'package:diabetes_tfg_app/widgets/drawerScaffold.dart';
import 'package:diabetes_tfg_app/widgets/lowerNavBar.dart';
import 'package:diabetes_tfg_app/widgets/screenMargins.dart';
import 'package:diabetes_tfg_app/widgets/upperNavBar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'package:scroll_snap_list/scroll_snap_list.dart';

class PunctualInjectionFormPage extends StatefulWidget {
  double initialUnits = 0;
  PunctualInjectionFormPage.withInitialUnits(this.initialUnits);
  PunctualInjectionFormPage();
  @override
  _PunctualInjectionFormPageState createState() =>
      _PunctualInjectionFormPageState();
}

class _PunctualInjectionFormPageState extends State<PunctualInjectionFormPage> {
  final TextEditingController _insulinUnitsController = TextEditingController();
  int selectedIndex = 0;
  double fastInsulin = 0;
  List<String> injectableLocations = [
    "Brazo izq.",
    "Brazo der.",
    "Gluteo izq.",
    "Gluteo der.",
    "Muslo izq.",
    "Muslo der.",
    "Barriga",
  ];
  String currentCameraOrbit = "110deg 90deg 0.02m";
  List<String> allCameraOrbits = [
    "110deg 90deg 0.02m", // Brazo izq.
    "250deg 90deg 0.02m", // Brazo der.
    "140deg 70deg 0.1m", // Glúteo izq.
    "220deg 70deg 0.1m", // Glúteo der.
    "50deg 100deg 1.3m", // Muslo izq.
    "310deg 100deg 1.3m", // Muslo der.
    "0deg 75deg 1.0m",
  ];
  String currentCameraTarget = '0m 1.3m 0m';
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
      InsulinDAOFB dao = InsulinDAOFB();
      List<InsulinModel> l = await dao.getAll();
      fastInsulin = l.first.totalFastActingInsulin;
    } else {
      InsulinDAO dao = InsulinDAO();
      List<InsulinModel> l = await dao.getAll();
      fastInsulin = l.first.totalFastActingInsulin;
    }
  }

  void saveLog() async {
    double insulinValue = double.parse(_insulinUnitsController.text);
    String location = injectableLocations[selectedIndex];

    if (AuthServiceManager.checkIfLogged()) {
      InsulinLogModel glucoseLog = InsulinLogModel.newEntity(
          AuthServiceManager.getCurrentUserUID(),
          insulinValue,
          DateFormat("yyyy-MM-dd").format(DateTime.now()),
          "${DateTime.now().hour.toString().padLeft(2, "0")}:${DateTime.now().minute.toString().padLeft(2, "0")}:${DateTime.now().second.toString().padLeft(2, "0")}",
          location);
      InsulinLogDAOFB dao = InsulinLogDAOFB();
      dao.insert(glucoseLog);

      InsulinDAOFB dao2 = InsulinDAOFB();
      List<InsulinModel> l = await dao2.getAll();
      InsulinModel insulinModel = l.first;
      insulinModel.totalFastActingInsulin =
          insulinModel.totalFastActingInsulin -
              double.parse(_insulinUnitsController.text);
      await dao2.update(insulinModel);
    } else {
      InsulinLogModel glucoseLog = InsulinLogModel.newEntity(
          "localUser",
          insulinValue,
          DateFormat("yyyy-MM-dd").format(DateTime.now()),
          "${DateTime.now().hour.toString().padLeft(2, "0")}:${DateTime.now().minute.toString().padLeft(2, "0")}:${DateTime.now().second.toString().padLeft(2, "0")}",
          location);
      InsulinLogDAO dao = InsulinLogDAO();
      dao.insert(glucoseLog);

      InsulinDAO dao2 = InsulinDAO();
      List<InsulinModel> l = await dao2.getAll();
      InsulinModel insulinModel = l.first;
      insulinModel.totalFastActingInsulin =
          insulinModel.totalFastActingInsulin -
              double.parse(_insulinUnitsController.text);
      await dao2.update(insulinModel);
    }
  }

  @override
  void initState() {
    super.initState();
    _insulinUnitsController.text = widget.initialUnits.toString();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UpperNavBar(pageName: "Añadir Inyección"),
      body: ScreenMargins(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 400),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  //"Añadir inyección de insulina",
                  "Añadir inyección",
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 85, 42, 196)),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8),
                TextFormField(
                  controller: _insulinUnitsController,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
                  decoration: InputDecoration(
                    labelText: "Unidades de insulina a inyectar",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                /*
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
                */
                Icon(
                  Icons.arrow_drop_down_rounded,
                  color: Color(0xFF3C37FF),
                  size: 40,
                ),
                SizedBox(
                  height: 80,
                  child: ScrollConfiguration(
                    behavior: LessSensitiveScrollBehavior(),
                    child: ScrollSnapList(
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.symmetric(horizontal: 2),
                          child: Container(
                            alignment: Alignment.center,
                            height: 40,
                            width: 85,
                            decoration: BoxDecoration(
                                color: Color(0xFF3C37FF),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20))),
                            child: Text(
                              "${injectableLocations[index]}",
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        );
                      },
                      itemCount: injectableLocations.length,
                      itemSize: 89,
                      duration: 200,
                      dynamicItemSize: true,
                      scrollDirection: Axis.horizontal,
                      focusOnItemTap: true,
                      onItemFocus: (index) {
                        setState(() {
                          selectedIndex = index;
                          currentCameraOrbit = allCameraOrbits[selectedIndex];
                          currentCameraTarget = allCameraTargets[selectedIndex];
                        });
                      },
                    ),
                  ),
                ),
                SizedBox(height: 25),
                ElevatedButton(
                  onPressed: () {
                    if (_insulinUnitsController.text == "") {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          backgroundColor: Color.fromARGB(255, 232, 80, 69),
                          title: Text(
                            'Univades de insulina vacio',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                          content: Text(
                            "Introduzca un valor en las unidades de insulina.",
                            style: TextStyle(color: Colors.black, fontSize: 16),
                          ),
                          actions: [
                            TextButton(
                              child: Text(
                                'OK',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                              ),
                              onPressed: () => Navigator.of(context).pop(),
                            ),
                          ],
                        ),
                      );
                    } else if (double.parse(_insulinUnitsController.text) < 0) {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          backgroundColor: Color.fromARGB(255, 232, 80, 69),
                          title: Text(
                            'Unidades de insulina no validas',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                          content: Text(
                            "Introduzca un valor valido de unidades de insulina.",
                            style: TextStyle(color: Colors.black, fontSize: 16),
                          ),
                          actions: [
                            TextButton(
                              child: Text(
                                'OK',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                              ),
                              onPressed: () => Navigator.of(context).pop(),
                            ),
                          ],
                        ),
                      );
                    } else if (fastInsulin -
                            double.parse(_insulinUnitsController.text) <
                        0) {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          backgroundColor: Color.fromARGB(255, 232, 80, 69),
                          title: Text(
                            'Cantidad de unidades de insulina no valida',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                          content: Text(
                            "El numero de unidades ha inyectar supera las que tienes disponibles: $fastInsulin.",
                            style: TextStyle(color: Colors.black, fontSize: 16),
                          ),
                          actions: [
                            TextButton(
                              child: Text(
                                'OK',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                              ),
                              onPressed: () => Navigator.of(context).pop(),
                            ),
                          ],
                        ),
                      );
                    } else {
                      saveLog();
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DrawerScaffold(
                                  child: BackgroundBase(
                                      child: InsulinMainPage()))));
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 85, 42, 196),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  ),
                  child:
                      Text("Añadir registro", style: TextStyle(fontSize: 18)),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: LowerNavBar(selectedSection: "insulin"),
      backgroundColor: Colors.transparent,
    );
  }
}

class LessSensitiveScrollBehavior extends ScrollBehavior {
  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    return const ClampingScrollPhysics();
  }
}
