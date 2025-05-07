import 'package:diabetes_tfg_app/database/firebase/authServiceManager.dart';
import 'package:diabetes_tfg_app/database/firebase/glucoseLogDAO.dart';
import 'package:diabetes_tfg_app/database/local/glucoseLogDAO.dart';
import 'package:diabetes_tfg_app/models/gluoseLogModel.dart';
import 'package:diabetes_tfg_app/pages/glucoseMainPage.dart';
import 'package:diabetes_tfg_app/widgets/backgroundBase.dart';
import 'package:diabetes_tfg_app/widgets/drawerScaffold.dart';
import 'package:diabetes_tfg_app/widgets/lowerNavBar.dart';
import 'package:diabetes_tfg_app/widgets/screenMargins.dart';
import 'package:diabetes_tfg_app/widgets/upperNavBar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:scroll_snap_list/scroll_snap_list.dart';

class PunctualInjectionFormPage extends StatefulWidget {
  @override
  _PunctualInjectionFormPageState createState() =>
      _PunctualInjectionFormPageState();
}

class _PunctualInjectionFormPageState extends State<PunctualInjectionFormPage> {
  final TextEditingController _glucoseController = TextEditingController();
  final TextEditingController _sensationsController = TextEditingController();

  String getCategory(int glucoseValue) {
    if (glucoseValue <= 70) {
      return "Bajo";
    } else if (glucoseValue > 70 && glucoseValue < 140) {
      return "Normal";
    } else {
      return "Elevado";
    }
  }

  bool getHypoglucemia(int glucoseValue) {
    if (glucoseValue <= 70) {
      return true;
    } else {
      return false;
    }
  }

  bool getHyperglucemia(int glucoseValue) {
    if (glucoseValue >= 140) {
      return true;
    } else {
      return false;
    }
  }

  void saveLog() async {
    int glucoseValue = int.parse(_glucoseController.text);
    String category = getCategory(glucoseValue);
    bool hyperglucemia = getHyperglucemia(glucoseValue);
    bool hypoglucemia = getHypoglucemia(glucoseValue);
    GlucoseLogModel glucoseLog = GlucoseLogModel.newEntity(
        AuthServiceManager.getCurrentUserUID(),
        glucoseValue,
        DateFormat("yyyy-MM-dd").format(DateTime.now()),
        "${DateTime.now().hour.toString().padLeft(2, "0")}:${DateTime.now().minute.toString().padLeft(2, "0")}:${DateTime.now().second.toString().padLeft(2, "0")}",
        category,
        hyperglucemia,
        hypoglucemia,
        _sensationsController.text);
    if (AuthServiceManager.checkIfLogged()) {
      GlucoseLogDAOFB dao = GlucoseLogDAOFB();
      dao.insert(glucoseLog);
    } else {
      GlucoseLogDAO dao = GlucoseLogDAO();
      dao.insert(glucoseLog);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UpperNavBar(pageName: "Añadir Inyección"),
      body: ScreenMargins(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 400),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    "Añadir inyección de insulina",
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 85, 42, 196)),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 24),
                  TextFormField(
                    controller: _glucoseController,
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
                  SizedBox(height: 24),
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
                              height: 70,
                              width: 70,
                              decoration: BoxDecoration(
                                  color: Color.fromARGB(255, 85, 42, 196),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20))),
                              child: Text(
                                "Brazo izq.",
                                style: TextStyle(
                                    fontSize: 25, color: Colors.white),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          );
                        },
                        itemCount: 7,
                        itemSize: 80,
                        duration: 200,
                        dynamicItemSize: true,
                        scrollDirection: Axis.horizontal,
                        focusOnItemTap: true,
                        onItemFocus: (index) {},
                      ),
                    ),
                  ),
                  SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: () {
                      if (_glucoseController.text == "") {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            backgroundColor: Color.fromARGB(255, 232, 80, 69),
                            title: Text(
                              'Nivel de glucosa vacio',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                            content: Text(
                              "Introduzca un valor en el nivel de glucosa.",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 16),
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
                      } else if (int.parse(_glucoseController.text) < 0) {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            backgroundColor: Color.fromARGB(255, 232, 80, 69),
                            title: Text(
                              'Nivel de glucosa no valido',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                            content: Text(
                              "Introduzca un valor valido en el nivel de glucosa.",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 16),
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
                                        child: GlucoseMainPage()))));
                      }
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
                    child:
                        Text("Añadir registro", style: TextStyle(fontSize: 18)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: LowerNavBar(),
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
