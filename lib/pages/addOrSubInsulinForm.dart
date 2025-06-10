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
  final bool isAdd;

  const AddInsulinFormPage({required this.isAdd});

  @override
  _AddInsulinFormPageState createState() => _AddInsulinFormPageState();
}

class _AddInsulinFormPageState extends State<AddInsulinFormPage>
    with WidgetsBindingObserver {
  double actualFastActingInsulin = 0;
  double actualSlowActingInsulin = 0;
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
      if (widget.isAdd) {
        for (InsulinModel insulin in log) {
          insulin.totalFastActingInsulin = insulin.totalFastActingInsulin +
              double.parse(_fastActingInsulinController.text);
          insulin.totalSlowActingInsulin = insulin.totalSlowActingInsulin +
              double.parse(_slowActingInsulinController.text);
          dao.update(insulin);
        }
      } else {
        for (InsulinModel insulin in log) {
          insulin.totalFastActingInsulin = insulin.totalFastActingInsulin -
              double.parse(_fastActingInsulinController.text);
          insulin.totalSlowActingInsulin = insulin.totalSlowActingInsulin -
              double.parse(_slowActingInsulinController.text);
          dao.update(insulin);
        }
      }
    } else {
      InsulinDAO dao = InsulinDAO();
      log = await dao.getAll();
      if (log.isEmpty) {
        dao.insert(InsulinModel.newEntity("localUser", "12:00", "00:00", 0, 0));
      }
      if (widget.isAdd) {
        for (InsulinModel insulin in log) {
          insulin.totalFastActingInsulin = insulin.totalFastActingInsulin +
              double.parse(_fastActingInsulinController.text);
          insulin.totalSlowActingInsulin = insulin.totalSlowActingInsulin +
              double.parse(_slowActingInsulinController.text);
          dao.update(insulin);
        }
      } else {
        for (InsulinModel insulin in log) {
          insulin.totalFastActingInsulin = insulin.totalFastActingInsulin -
              double.parse(_fastActingInsulinController.text);
          insulin.totalSlowActingInsulin = insulin.totalSlowActingInsulin -
              double.parse(_slowActingInsulinController.text);
          dao.update(insulin);
        }
      }
    }
    setState(() {});
  }

  void loadData() async {
    if (AuthServiceManager.checkIfLogged()) {
      InsulinDAOFB dao = InsulinDAOFB();
      log = await dao.getAll();
      for (InsulinModel insulin in log) {
        actualFastActingInsulin = insulin.totalFastActingInsulin;
        actualSlowActingInsulin = insulin.totalSlowActingInsulin;
      }
    } else {
      InsulinDAO dao = InsulinDAO();
      log = await dao.getAll();
      for (InsulinModel insulin in log) {
        actualFastActingInsulin = insulin.totalFastActingInsulin;
        actualSlowActingInsulin = insulin.totalSlowActingInsulin;
      }
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    loadData();
    WidgetsBinding.instance.addObserver(this);
    _isKeyboardVisible = WidgetsBinding.instance.window.viewInsets.bottom > 0.0;
  }

  bool _isKeyboardVisible = false;

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    final bottomInset = WidgetsBinding.instance.window.viewInsets.bottom;
    final newValue = bottomInset > 0.0;

    if (_isKeyboardVisible != newValue) {
      setState(() {
        _isKeyboardVisible = newValue;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UpperNavBar(
          pageName: "${widget.isAdd == true ? "Añadir" : "Restar"} Insulina"),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: ScreenMargins(
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(top: 24, bottom: 24),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 400),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    "${widget.isAdd == true ? "Añadir" : "Restar"} Insulina",
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
                      labelText:
                          "Unidades de insulina lenta a ${widget.isAdd == true ? "añadir" : "restar"}",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                      "Insulina de absorción lenta actual: ${actualSlowActingInsulin.toStringAsFixed(1)}"),
                  SizedBox(height: 24),
                  TextFormField(
                    controller: _fastActingInsulinController,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
                    decoration: InputDecoration(
                      labelText:
                          "Unidades de insulina rapida a ${widget.isAdd == true ? "añadir" : "restar"}",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                      "Insulina de absorción rápida actual: ${actualFastActingInsulin.toStringAsFixed(1)}"),
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
                      } else if (double.parse(
                              _fastActingInsulinController.text) <
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
                      } else if (!widget.isAdd &&
                          (actualFastActingInsulin -
                                  double.parse(
                                      _fastActingInsulinController.text)) <
                              0) {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            backgroundColor: Color.fromARGB(255, 232, 80, 69),
                            title: Text(
                              'Valor de insulina rapida no valido',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                            content: Text(
                              "El valor de insulina rapida a restar es mayor que el total actual, introduzca un valor valido en la insulina rapida.",
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
                      } else if (!widget.isAdd &&
                          (actualSlowActingInsulin -
                                  double.parse(
                                      _slowActingInsulinController.text)) <
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
                              "El valor de insulina lenta a restar es mayor que el total actual, introduzca un valor valido en la insulina lenta.",
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
                      padding:
                          EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    ),
                    child: Text("${widget.isAdd == true ? "Añadir" : "Restar"}",
                        style: TextStyle(fontSize: 24)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar:
          _isKeyboardVisible ? null : LowerNavBar(selectedSection: "insulin"),
      backgroundColor: Colors.transparent,
    );
  }
}
