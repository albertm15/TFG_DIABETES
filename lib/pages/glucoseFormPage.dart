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

class GlucoseFormPage extends StatefulWidget {
  @override
  _GlucoseFormPageState createState() => _GlucoseFormPageState();
}

class _GlucoseFormPageState extends State<GlucoseFormPage> {
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
      appBar: UpperNavBar(pageName: "Añadir registro de glucosa"),
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
                    "Añadir registro de glucosa",
                    style: TextStyle(
                        fontSize: 40,
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
                      labelText: "Nivel de glucosa (mg/dl)",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding: EdgeInsets.symmetric(vertical: 20),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Introduce un valor";
                      }
                      final intVal = int.tryParse(value);
                      if (intVal == null) return "Debe ser un número";
                      return null;
                    },
                  ),
                  SizedBox(height: 24),
                  TextFormField(
                    controller: _sensationsController,
                    maxLines: 4,
                    decoration: InputDecoration(
                      labelText: "Sensaciones (opcional)",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: () {
                      saveLog();
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DrawerScaffold(
                                  child: BackgroundBase(
                                      child: GlucoseMainPage()))));
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
