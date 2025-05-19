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
  final String initialId;
  const GlucoseFormPage({required this.initialId});
  @override
  _GlucoseFormPageState createState() => _GlucoseFormPageState();
}

class _GlucoseFormPageState extends State<GlucoseFormPage>
    with WidgetsBindingObserver {
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

  void deleteLog() async {
    if (AuthServiceManager.checkIfLogged()) {
      GlucoseLogDAOFB dao = GlucoseLogDAOFB();
      List<GlucoseLogModel> log = await dao.getById(widget.initialId);
      dao.delete(log.first);
    } else {
      GlucoseLogDAO dao = GlucoseLogDAO();
      List<GlucoseLogModel> log = await dao.getById(widget.initialId);
      dao.delete(log.first);
    }
  }

  void saveLog() async {
    int glucoseValue = int.parse(_glucoseController.text);
    String category = getCategory(glucoseValue);
    bool hyperglucemia = getHyperglucemia(glucoseValue);
    bool hypoglucemia = getHypoglucemia(glucoseValue);

    if (AuthServiceManager.checkIfLogged()) {
      if (widget.initialId != "") {
        GlucoseLogDAOFB dao = GlucoseLogDAOFB();
        List<GlucoseLogModel> log = await dao.getById(widget.initialId);
        log.first.glucoseValue = glucoseValue;
        log.first.category = category;
        log.first.hyperglucemia = hypoglucemia;
        log.first.hypoglucemia = hypoglucemia;
        log.first.sensations = _sensationsController.text;
        dao.update(log.first);
      } else {
        GlucoseLogModel glucoseLog = GlucoseLogModel.newEntity(
            AuthServiceManager.getCurrentUserUID(),
            glucoseValue,
            DateFormat("yyyy-MM-dd").format(DateTime.now()),
            "${DateTime.now().hour.toString().padLeft(2, "0")}:${DateTime.now().minute.toString().padLeft(2, "0")}:${DateTime.now().second.toString().padLeft(2, "0")}",
            category,
            hyperglucemia,
            hypoglucemia,
            _sensationsController.text);
        GlucoseLogDAOFB dao = GlucoseLogDAOFB();
        dao.insert(glucoseLog);
      }
    } else {
      if (widget.initialId != "") {
        GlucoseLogDAO dao = GlucoseLogDAO();
        List<GlucoseLogModel> log = await dao.getById(widget.initialId);
        log.first.glucoseValue = glucoseValue;
        log.first.category = category;
        log.first.hyperglucemia = hypoglucemia;
        log.first.hypoglucemia = hypoglucemia;
        log.first.sensations = _sensationsController.text;
        dao.update(log.first);
      } else {
        GlucoseLogModel glucoseLog = GlucoseLogModel.newEntity(
            "localUser",
            glucoseValue,
            DateFormat("yyyy-MM-dd").format(DateTime.now()),
            "${DateTime.now().hour.toString().padLeft(2, "0")}:${DateTime.now().minute.toString().padLeft(2, "0")}:${DateTime.now().second.toString().padLeft(2, "0")}",
            category,
            hyperglucemia,
            hypoglucemia,
            _sensationsController.text);
        GlucoseLogDAO dao = GlucoseLogDAO();
        dao.insert(glucoseLog);
      }
    }
  }

  void loadData() async {
    if (AuthServiceManager.checkIfLogged()) {
      GlucoseLogDAOFB dao = GlucoseLogDAOFB();
      List<GlucoseLogModel> log = await dao.getById(widget.initialId);
      _glucoseController.text = log.first.glucoseValue.toString();
      _sensationsController.text = log.first.sensations;
    } else {
      GlucoseLogDAO dao = GlucoseLogDAO();
      List<GlucoseLogModel> log = await dao.getById(widget.initialId);
      _glucoseController.text = log.first.glucoseValue.toString();
      _sensationsController.text = log.first.sensations;
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.initialId != "") {
      loadData();
    }
    //
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
      appBar: UpperNavBar(pageName: "Añadir registro de glucosa"),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: ScreenMargins(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(top: 24, bottom: 24),
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 400),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      "Añadir registro de glucosa",
                      style: TextStyle(
                          fontSize: 35,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 85, 42, 196)),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 24),
                    TextFormField(
                      controller: _glucoseController,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
                      decoration: InputDecoration(
                        labelText: "Nivel de glucosa (mg/dl)",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding: EdgeInsets.symmetric(vertical: 20),
                      ),
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
                                style: TextStyle(
                                    color: Colors.black, fontSize: 16),
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
                                style: TextStyle(
                                    color: Colors.black, fontSize: 16),
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
                      child: Text(
                          widget.initialId == ""
                              ? "Añadir registro"
                              : "Confirmar modificación",
                          style: TextStyle(fontSize: 18)),
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
                                              child: GlucoseMainPage()))));
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
                            child: Text("Eliminar",
                                style: TextStyle(fontSize: 18)),
                          )
                        : SizedBox()
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar:
          _isKeyboardVisible ? null : LowerNavBar(selectedSection: "glucose"),
      backgroundColor: Colors.transparent,
    );
  }
}
