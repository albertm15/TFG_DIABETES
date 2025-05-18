import 'package:diabetes_tfg_app/database/firebase/authServiceManager.dart';
import 'package:diabetes_tfg_app/database/firebase/insulinDAO.dart';
import 'package:diabetes_tfg_app/database/local/insulinDAO.dart';
import 'package:diabetes_tfg_app/models/insulinModel.dart';
import 'package:diabetes_tfg_app/pages/insulinMainPage.dart';
import 'package:diabetes_tfg_app/widgets/backgroundBase.dart';
import 'package:diabetes_tfg_app/widgets/drawerScaffold.dart';
import 'package:diabetes_tfg_app/widgets/lowerNavBar.dart';
import 'package:diabetes_tfg_app/widgets/screenMargins.dart';
import 'package:diabetes_tfg_app/widgets/upperNavBar.dart';
import 'package:flutter/material.dart';

class AddInsulinFormPage extends StatefulWidget {
  @override
  _AddInsulinFormPageState createState() => _AddInsulinFormPageState();
}

class _AddInsulinFormPageState extends State<AddInsulinFormPage> {
  double fastActingInsulin = 0;
  double slowActingInsulin = 0;
  List<InsulinModel> log = [];
  final TextEditingController _slowActingInsulinController =
      TextEditingController();
  final TextEditingController _fastActingInsulinController =
      TextEditingController();

  void saveData() async {
    if (AuthServiceManager.checkIfLogged()) {
      InsulinDAOFB dao = InsulinDAOFB();
      log = await dao.getAll();
      if (log.isEmpty) {
        dao.insert(InsulinModel.newEntity(
            AuthServiceManager.getCurrentUserUID(), "12:00", "00:00", 0, 0));
      }
      for (InsulinModel insulin in log) {
        insulin.totalFastActingInsulin = insulin.totalFastActingInsulin +
            double.parse(_fastActingInsulinController.text);
        insulin.totalSlowActingInsulin = insulin.totalSlowActingInsulin +
            double.parse(_slowActingInsulinController.text);
        dao.update(insulin);
      }
    } else {
      InsulinDAO dao = InsulinDAO();
      log = await dao.getAll();
      if (log.isEmpty) {
        dao.insert(InsulinModel.newEntity("localUser", "12:00", "00:00", 0, 0));
      }
      for (InsulinModel insulin in log) {
        insulin.totalFastActingInsulin = insulin.totalFastActingInsulin +
            double.parse(_fastActingInsulinController.text);
        insulin.totalSlowActingInsulin = insulin.totalSlowActingInsulin +
            double.parse(_slowActingInsulinController.text);
        dao.update(insulin);
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UpperNavBar(pageName: "Añadir Insulina"),
      body: ScreenMargins(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(top: 24, bottom: 24),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 400),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  "Añadir Insulina",
                  style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 85, 42, 196)),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 24),
                TextFormField(
                  controller: _slowActingInsulinController,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
                  decoration: InputDecoration(
                    labelText: "Unidades de insulina lenta",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                SizedBox(height: 24),
                TextFormField(
                  controller: _fastActingInsulinController,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
                  decoration: InputDecoration(
                    labelText: "Unidades de insulina rapida",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                SizedBox(height: 32),
                ElevatedButton(
                  onPressed: () {
                    if (_slowActingInsulinController.text == "" ||
                        _fastActingInsulinController.text == "") {
                      if (_slowActingInsulinController.text == "" &&
                          _fastActingInsulinController.text == "") {
                        _slowActingInsulinController.text = "0";
                        _fastActingInsulinController.text = "0";
                      } else {
                        if (_slowActingInsulinController.text == "") {
                          _slowActingInsulinController.text = "0";
                        } else {
                          _fastActingInsulinController.text = "0";
                        }
                      }
                    }
                    if (double.parse(_slowActingInsulinController.text) < 0) {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          backgroundColor: Color.fromARGB(255, 232, 80, 69),
                          title: Text(
                            'Valor de insulina lenta no valido',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                          content: Text(
                            "Introduzca un valor valido en la insulina lenta.",
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
                    } else if (double.parse(_fastActingInsulinController.text) <
                        0) {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          backgroundColor: Color.fromARGB(255, 232, 80, 69),
                          title: Text(
                            'Valor de insulina lenta no valido',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                          content: Text(
                            "Introduzca un valor valido en la insulina lenta.",
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
                      saveData();
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
                  child: Text("Añadir", style: TextStyle(fontSize: 24)),
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
