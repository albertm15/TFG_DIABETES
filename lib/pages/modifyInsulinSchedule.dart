import 'package:diabetes_tfg_app/auxiliarResources/insulinNotifications.dart';
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

class ModifyInsulinSchedule extends StatefulWidget {
  final String firstInjectionSchedule;
  final String secondInjectionSchedule;

  const ModifyInsulinSchedule(
      {required this.firstInjectionSchedule,
      required this.secondInjectionSchedule});
  @override
  _ModifyInsulinScheduleState createState() => _ModifyInsulinScheduleState();
}

class _ModifyInsulinScheduleState extends State<ModifyInsulinSchedule> {
  String firstInjectionSchedule = "";
  String secondInjectionSchedule = "";
  List<InsulinModel> log = [];
  final TextEditingController _firstInjectionScheduleHourController =
      TextEditingController();
  final TextEditingController _secondInjectionScheduleHourController =
      TextEditingController();
  final TextEditingController _firstInjectionScheduleMinuteController =
      TextEditingController();
  final TextEditingController _secondInjectionScheduleMinuteController =
      TextEditingController();

  void saveData() async {
    if (AuthServiceManager.checkIfLogged()) {
      InsulinDAOFB dao = InsulinDAOFB();
      log = await dao.getAll();
      if (log.isEmpty) {
        await dao.insert(InsulinModel.newEntity(
            AuthServiceManager.getCurrentUserUID(), "00:00", "00:00", 0, 0));
      }
      for (InsulinModel insulin in log) {
        insulin.firstInjectionSchedule =
            "${_firstInjectionScheduleHourController.text}:${_firstInjectionScheduleMinuteController.text}";
        insulin.secondInjectionSchedule =
            "${_secondInjectionScheduleHourController.text}:${_secondInjectionScheduleMinuteController.text}";
        await dao.update(insulin);
      }
    } else {
      InsulinDAO dao = InsulinDAO();
      log = await dao.getAll();
      if (log.isEmpty) {
        await dao.insert(
            InsulinModel.newEntity("localUser", "00:00", "00:00", 0, 0));
      }
      for (InsulinModel insulin in log) {
        insulin.firstInjectionSchedule =
            "${_firstInjectionScheduleHourController.text}:${_firstInjectionScheduleMinuteController.text}";
        insulin.secondInjectionSchedule =
            "${_secondInjectionScheduleHourController.text}:${_secondInjectionScheduleMinuteController.text}";
        await dao.update(insulin);
      }
    }
  }

  void checkAndReformat() {
    if (int.parse(_firstInjectionScheduleHourController.text) <= 9 &&
        int.parse(_firstInjectionScheduleHourController.text) >= 0) {
      if (_firstInjectionScheduleHourController.text != "00") {
        _firstInjectionScheduleHourController.text =
            "0${int.parse(_firstInjectionScheduleHourController.text)}";
      }
    }
    if (int.parse(_firstInjectionScheduleMinuteController.text) <= 9 &&
        int.parse(_firstInjectionScheduleMinuteController.text) >= 0) {
      if (_firstInjectionScheduleMinuteController.text != "00") {
        _firstInjectionScheduleMinuteController.text =
            "0${int.parse(_firstInjectionScheduleMinuteController.text)}";
      }
    }
    if (int.parse(_secondInjectionScheduleHourController.text) <= 9 &&
        int.parse(_secondInjectionScheduleHourController.text) >= 0) {
      if (_secondInjectionScheduleHourController.text != "00") {
        _secondInjectionScheduleHourController.text =
            "0${int.parse(_secondInjectionScheduleHourController.text)}";
      }
    }
    if (int.parse(_secondInjectionScheduleMinuteController.text) <= 9 &&
        int.parse(_secondInjectionScheduleMinuteController.text) >= 0) {
      if (_secondInjectionScheduleMinuteController.text != "00") {
        _secondInjectionScheduleMinuteController.text =
            "0${int.parse(_secondInjectionScheduleMinuteController.text)}";
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _firstInjectionScheduleHourController.text =
        widget.firstInjectionSchedule.split(":")[0];

    _firstInjectionScheduleMinuteController.text =
        widget.firstInjectionSchedule.split(":")[1];

    _secondInjectionScheduleHourController.text =
        widget.secondInjectionSchedule.split(":")[0];

    _secondInjectionScheduleMinuteController.text =
        widget.secondInjectionSchedule.split(":")[1];
  }

  void setNewNotifications() async {
    await InsulinNotifications.cancelInsulinNotifications();
    await InsulinNotifications.scheduleInsulinNotification(
        int.parse(_firstInjectionScheduleHourController.text),
        int.parse(_firstInjectionScheduleMinuteController.text),
        "primera");
    await InsulinNotifications.scheduleInsulinNotification(
        int.parse(_secondInjectionScheduleHourController.text),
        int.parse(_secondInjectionScheduleMinuteController.text),
        "segunda");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UpperNavBar(pageName: "Horario Insulina"),
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
                  "Modificar horario de insulina lenta",
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 85, 42, 196)),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 24),
                Text(
                  "Primera inyección",
                  style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 0, 0, 0)),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _firstInjectionScheduleHourController,
                        maxLength: 2,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 48, fontWeight: FontWeight.bold),
                        decoration: InputDecoration(
                            labelText: "Hora",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            counterText: ""),
                      ),
                    ),
                    Text(
                      ":",
                      style:
                          TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
                    ),
                    Expanded(
                      child: TextFormField(
                        controller: _firstInjectionScheduleMinuteController,
                        maxLength: 2,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 48, fontWeight: FontWeight.bold),
                        decoration: InputDecoration(
                            labelText: "Minuto",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            counterText: ""),
                      ),
                    )
                  ],
                ),
                SizedBox(height: 24),
                Text(
                  "Segunda inyección",
                  style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 0, 0, 0)),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _secondInjectionScheduleHourController,
                        maxLength: 2,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 48, fontWeight: FontWeight.bold),
                        decoration: InputDecoration(
                            labelText: "Hora",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            counterText: ""),
                      ),
                    ),
                    Text(
                      ":",
                      style:
                          TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
                    ),
                    Expanded(
                      child: TextFormField(
                        controller: _secondInjectionScheduleMinuteController,
                        maxLength: 2,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 48, fontWeight: FontWeight.bold),
                        decoration: InputDecoration(
                            labelText: "Minuto",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            counterText: ""),
                      ),
                    )
                  ],
                ),
                SizedBox(height: 32),
                ElevatedButton(
                  onPressed: () {
                    if (_firstInjectionScheduleHourController.text == "") {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          backgroundColor: Color.fromARGB(255, 232, 80, 69),
                          title: Text(
                            'Valor de horario vacio',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                          content: Text(
                            "Introduzca un valor valido en la hora de la primera inyección.",
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
                    } else if (double.parse(_firstInjectionScheduleHourController.text) < 0 ||
                        double.parse(_firstInjectionScheduleHourController.text) >
                            23) {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          backgroundColor: Color.fromARGB(255, 232, 80, 69),
                          title: Text(
                            'Valor de horario no valido',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                          content: Text(
                            "Introduzca un valor valido en la hora de la primera inyección.",
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
                    } else if (_firstInjectionScheduleMinuteController.text ==
                        "") {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          backgroundColor: Color.fromARGB(255, 232, 80, 69),
                          title: Text(
                            'Valor de horario vacio',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                          content: Text(
                            "Introduzca un valor valido en los minutos de la primera inyección.",
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
                    } else if (double.parse(
                                _firstInjectionScheduleMinuteController.text) <
                            0 ||
                        double.parse(_firstInjectionScheduleMinuteController.text) >
                            59) {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          backgroundColor: Color.fromARGB(255, 232, 80, 69),
                          title: Text(
                            'Valor de horario no valido',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                          content: Text(
                            "Introduzca un valor valido en los minutos de la primera inyección.",
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
                    } else if (_secondInjectionScheduleHourController.text ==
                        "") {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          backgroundColor: Color.fromARGB(255, 232, 80, 69),
                          title: Text(
                            'Valor de horario vacio',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                          content: Text(
                            "Introduzca un valor valido en la hora de la segunda inyección.",
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
                    } else if (double.parse(
                                _secondInjectionScheduleHourController.text) <
                            0 ||
                        double.parse(_secondInjectionScheduleHourController.text) >
                            23) {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          backgroundColor: Color.fromARGB(255, 232, 80, 69),
                          title: Text(
                            'Valor de horario no valido',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                          content: Text(
                            "Introduzca un valor valido en la hora de la segunda inyección.",
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
                    } else if (_secondInjectionScheduleMinuteController.text ==
                        "") {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          backgroundColor: Color.fromARGB(255, 232, 80, 69),
                          title: Text(
                            'Valor de horario vacio',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                          content: Text(
                            "Introduzca un valor valido en los minutos de la segunda inyección.",
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
                    } else if (double.parse(
                                _secondInjectionScheduleMinuteController.text) <
                            0 ||
                        double.parse(_secondInjectionScheduleMinuteController.text) >
                            59) {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          backgroundColor: Color.fromARGB(255, 232, 80, 69),
                          title: Text(
                            'Valor de horario no valido',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                          content: Text(
                            "Introduzca un valor valido en los minutos de la segunda inyección.",
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
                      setState(() {
                        checkAndReformat();
                        saveData();
                        setNewNotifications();
                      });
                      Navigator.push(
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
                  child: Text("Confirmar", style: TextStyle(fontSize: 24)),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: LowerNavBar(),
      backgroundColor: Colors.transparent,
    );
  }
}
