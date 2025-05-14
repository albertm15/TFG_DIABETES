import 'package:diabetes_tfg_app/auxiliarResources/insulinNotifications.dart';
import 'package:diabetes_tfg_app/database/firebase/authServiceManager.dart';
import 'package:diabetes_tfg_app/database/firebase/dietDAO.dart';
import 'package:diabetes_tfg_app/database/local/dietDAO.dart';
import 'package:diabetes_tfg_app/models/dietModel.dart';
import 'package:diabetes_tfg_app/pages/dietMainPage.dart';
import 'package:diabetes_tfg_app/widgets/backgroundBase.dart';
import 'package:diabetes_tfg_app/widgets/drawerScaffold.dart';
import 'package:diabetes_tfg_app/widgets/lowerNavBar.dart';
import 'package:diabetes_tfg_app/widgets/screenMargins.dart';
import 'package:diabetes_tfg_app/widgets/upperNavBar.dart';
import 'package:flutter/material.dart';

class ModifyDietSchedule extends StatefulWidget {
  @override
  _ModifyDietScheduleState createState() => _ModifyDietScheduleState();
}

class _ModifyDietScheduleState extends State<ModifyDietSchedule> {
  List<DietModel> log = [];
  String breakfastSchedule = "";
  String snackSchedule = "";
  String lunchSchedule = "";
  String afternoonSnackSchedule = "";
  String dinnerSchedule = "";

  final TextEditingController _breakfastScheduleHourController =
      TextEditingController();
  final TextEditingController _snackScheduleHourController =
      TextEditingController();
  final TextEditingController _lunchScheduleHourController =
      TextEditingController();
  final TextEditingController _afternoonSnackScheduleHourController =
      TextEditingController();
  final TextEditingController _dinnerScheduleHourController =
      TextEditingController();
  final TextEditingController _breakfastScheduleMinuteController =
      TextEditingController();
  final TextEditingController _snackScheduleMinuteController =
      TextEditingController();
  final TextEditingController _lunchScheduleMinuteController =
      TextEditingController();
  final TextEditingController _afternoonSnackScheduleMinuteController =
      TextEditingController();
  final TextEditingController _dinnerScheduleMinuteController =
      TextEditingController();

  void loadData() async {
    if (AuthServiceManager.checkIfLogged()) {
      DietDAOFB dao = DietDAOFB();
      log = await dao.getAll();
    } else {
      DietDAO dao = DietDAO();
      log = await dao.getAll();
    }

    if (log.isNotEmpty) {
      for (DietModel diet in log) {
        breakfastSchedule = diet.breakfastSchedule;
        snackSchedule = diet.snackSchedule;
        lunchSchedule = diet.lunchSchedule;
        afternoonSnackSchedule = diet.afternoonSnackSchedule;
        dinnerSchedule = diet.dinnerSchedule;
      }
    }

    _breakfastScheduleHourController.text = breakfastSchedule.split(":")[0];

    _breakfastScheduleMinuteController.text = breakfastSchedule.split(":")[1];

    _snackScheduleHourController.text = snackSchedule.split(":")[0];

    _snackScheduleMinuteController.text = snackSchedule.split(":")[1];

    _lunchScheduleHourController.text = lunchSchedule.split(":")[0];

    _lunchScheduleMinuteController.text = lunchSchedule.split(":")[1];

    _afternoonSnackScheduleHourController.text =
        afternoonSnackSchedule.split(":")[0];

    _afternoonSnackScheduleMinuteController.text =
        afternoonSnackSchedule.split(":")[1];

    _dinnerScheduleHourController.text = dinnerSchedule.split(":")[0];

    _dinnerScheduleMinuteController.text = dinnerSchedule.split(":")[1];

    setState(() {});
  }

  void saveData() async {
    if (AuthServiceManager.checkIfLogged()) {
      DietDAOFB dao = DietDAOFB();
      log = await dao.getAll();

      for (DietModel diet in log) {
        diet.breakfastSchedule =
            "${_breakfastScheduleHourController.text}:${_breakfastScheduleMinuteController.text}";
        diet.snackSchedule =
            "${_snackScheduleHourController.text}:${_snackScheduleMinuteController.text}";
        diet.lunchSchedule =
            "${_lunchScheduleHourController.text}:${_lunchScheduleMinuteController.text}";
        diet.afternoonSnackSchedule =
            "${_afternoonSnackScheduleHourController.text}:${_afternoonSnackScheduleMinuteController.text}";
        diet.dinnerSchedule =
            "${_dinnerScheduleHourController.text}:${_dinnerScheduleMinuteController.text}";

        await dao.update(diet);
      }
    } else {
      DietDAO dao = DietDAO();
      log = await dao.getAll();

      for (DietModel diet in log) {
        diet.breakfastSchedule =
            "${_breakfastScheduleHourController.text}:${_breakfastScheduleMinuteController.text}";
        diet.snackSchedule =
            "${_snackScheduleHourController.text}:${_snackScheduleMinuteController.text}";
        diet.lunchSchedule =
            "${_lunchScheduleHourController.text}:${_lunchScheduleMinuteController.text}";
        diet.afternoonSnackSchedule =
            "${_afternoonSnackScheduleHourController.text}:${_afternoonSnackScheduleMinuteController.text}";
        diet.dinnerSchedule =
            "${_dinnerScheduleHourController.text}:${_dinnerScheduleMinuteController.text}";

        await dao.update(diet);
      }
    }
  }

  void checkAndReformat() {
    if (int.parse(_breakfastScheduleHourController.text) <= 9 &&
        int.parse(_breakfastScheduleHourController.text) >= 0) {
      if (_breakfastScheduleHourController.text != "00") {
        _breakfastScheduleHourController.text =
            "0${int.parse(_breakfastScheduleHourController.text)}";
      }
    }
    if (int.parse(_breakfastScheduleMinuteController.text) <= 9 &&
        int.parse(_breakfastScheduleMinuteController.text) >= 0) {
      if (_breakfastScheduleMinuteController.text != "00") {
        _breakfastScheduleMinuteController.text =
            "0${int.parse(_breakfastScheduleMinuteController.text)}";
      }
    }
    if (int.parse(_snackScheduleHourController.text) <= 9 &&
        int.parse(_snackScheduleHourController.text) >= 0) {
      if (_snackScheduleHourController.text != "00") {
        _snackScheduleHourController.text =
            "0${int.parse(_snackScheduleHourController.text)}";
      }
    }
    if (int.parse(_snackScheduleMinuteController.text) <= 9 &&
        int.parse(_snackScheduleMinuteController.text) >= 0) {
      if (_snackScheduleMinuteController.text != "00") {
        _snackScheduleMinuteController.text =
            "0${int.parse(_snackScheduleMinuteController.text)}";
      }
    }
    if (int.parse(_lunchScheduleHourController.text) <= 9 &&
        int.parse(_lunchScheduleHourController.text) >= 0) {
      if (_lunchScheduleHourController.text != "00") {
        _lunchScheduleHourController.text =
            "0${int.parse(_lunchScheduleHourController.text)}";
      }
    }
    if (int.parse(_lunchScheduleMinuteController.text) <= 9 &&
        int.parse(_lunchScheduleMinuteController.text) >= 0) {
      if (_lunchScheduleMinuteController.text != "00") {
        _lunchScheduleMinuteController.text =
            "0${int.parse(_lunchScheduleMinuteController.text)}";
      }
    }
    if (int.parse(_afternoonSnackScheduleHourController.text) <= 9 &&
        int.parse(_afternoonSnackScheduleHourController.text) >= 0) {
      if (_afternoonSnackScheduleHourController.text != "00") {
        _afternoonSnackScheduleHourController.text =
            "0${int.parse(_afternoonSnackScheduleHourController.text)}";
      }
    }
    if (int.parse(_afternoonSnackScheduleMinuteController.text) <= 9 &&
        int.parse(_afternoonSnackScheduleMinuteController.text) >= 0) {
      if (_afternoonSnackScheduleMinuteController.text != "00") {
        _afternoonSnackScheduleMinuteController.text =
            "0${int.parse(_afternoonSnackScheduleMinuteController.text)}";
      }
    }
    if (int.parse(_dinnerScheduleHourController.text) <= 9 &&
        int.parse(_dinnerScheduleHourController.text) >= 0) {
      if (_dinnerScheduleHourController.text != "00") {
        _dinnerScheduleHourController.text =
            "0${int.parse(_dinnerScheduleHourController.text)}";
      }
    }
    if (int.parse(_dinnerScheduleMinuteController.text) <= 9 &&
        int.parse(_dinnerScheduleMinuteController.text) >= 0) {
      if (_dinnerScheduleMinuteController.text != "00") {
        _dinnerScheduleMinuteController.text =
            "0${int.parse(_dinnerScheduleMinuteController.text)}";
      }
    }
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void setNewNotifications() async {
    await InsulinNotifications.cancelDietNotifications();
    await InsulinNotifications.scheduleInsulinNotification(
        int.parse(_breakfastScheduleHourController.text),
        int.parse(_breakfastScheduleMinuteController.text),
        "del desayuno");
    await InsulinNotifications.scheduleInsulinNotification(
        int.parse(_snackScheduleHourController.text),
        int.parse(_snackScheduleMinuteController.text),
        "del tente en pié");
    await InsulinNotifications.scheduleInsulinNotification(
        int.parse(_lunchScheduleHourController.text),
        int.parse(_lunchScheduleMinuteController.text),
        "de la comida");
    await InsulinNotifications.scheduleInsulinNotification(
        int.parse(_afternoonSnackScheduleHourController.text),
        int.parse(_afternoonSnackScheduleMinuteController.text),
        "de la merienda");
    await InsulinNotifications.scheduleInsulinNotification(
        int.parse(_dinnerScheduleHourController.text),
        int.parse(_dinnerScheduleMinuteController.text),
        "de la cena");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UpperNavBar(pageName: "Horario dieta"),
      body: ScreenMargins(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(top: 24, bottom: 24),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 400),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Modificar horario",
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 85, 42, 196)),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 24),
                // DESAYUNO
                Row(
                  children: [
                    Text(
                      "Desayuno",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(width: 12),
                    Container(
                      height: 70,
                      width: 80,
                      child: TextFormField(
                        controller: _breakfastScheduleHourController,
                        maxLength: 2,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        textAlignVertical: TextAlignVertical.center,
                        style: TextStyle(
                            fontSize: 35, fontWeight: FontWeight.bold),
                        decoration: InputDecoration(
                          labelText: "Hora",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          counterText: "",
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(":",
                        style: TextStyle(
                            fontSize: 48, fontWeight: FontWeight.bold)),
                    SizedBox(width: 8),
                    Container(
                      height: 70,
                      width: 80,
                      child: TextFormField(
                        controller: _breakfastScheduleMinuteController,
                        maxLength: 2,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        textAlignVertical: TextAlignVertical.center,
                        style: TextStyle(
                            fontSize: 35, fontWeight: FontWeight.bold),
                        decoration: InputDecoration(
                          labelText: "Minuto",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          counterText: "",
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 8),

// TENTE EN PIÉ
                Row(
                  children: [
                    Text(
                      "Tente en pié",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(width: 12),
                    Container(
                      height: 70,
                      width: 80,
                      child: TextFormField(
                        controller: _snackScheduleHourController,
                        maxLength: 2,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        textAlignVertical: TextAlignVertical.center,
                        style: TextStyle(
                            fontSize: 35, fontWeight: FontWeight.bold),
                        decoration: InputDecoration(
                          labelText: "Hora",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          counterText: "",
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(":",
                        style: TextStyle(
                            fontSize: 48, fontWeight: FontWeight.bold)),
                    SizedBox(width: 8),
                    Container(
                      height: 70,
                      width: 80,
                      child: TextFormField(
                        controller: _snackScheduleMinuteController,
                        maxLength: 2,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        textAlignVertical: TextAlignVertical.center,
                        style: TextStyle(
                            fontSize: 35, fontWeight: FontWeight.bold),
                        decoration: InputDecoration(
                          labelText: "Minuto",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          counterText: "",
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 8),

// COMIDA
                Row(
                  children: [
                    Text(
                      "Comida",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(width: 12),
                    Container(
                      height: 70,
                      width: 80,
                      child: TextFormField(
                        controller: _lunchScheduleHourController,
                        maxLength: 2,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        textAlignVertical: TextAlignVertical.center,
                        style: TextStyle(
                            fontSize: 35, fontWeight: FontWeight.bold),
                        decoration: InputDecoration(
                          labelText: "Hora",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          counterText: "",
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(":",
                        style: TextStyle(
                            fontSize: 48, fontWeight: FontWeight.bold)),
                    SizedBox(width: 8),
                    Container(
                      height: 70,
                      width: 80,
                      child: TextFormField(
                        controller: _lunchScheduleMinuteController,
                        maxLength: 2,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        textAlignVertical: TextAlignVertical.center,
                        style: TextStyle(
                            fontSize: 35, fontWeight: FontWeight.bold),
                        decoration: InputDecoration(
                          labelText: "Minuto",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          counterText: "",
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 8),

// MERIENDA
                Row(
                  children: [
                    Text(
                      "Merienda",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(width: 12),
                    Container(
                      height: 70,
                      width: 80,
                      child: TextFormField(
                        controller: _afternoonSnackScheduleHourController,
                        maxLength: 2,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        textAlignVertical: TextAlignVertical.center,
                        style: TextStyle(
                            fontSize: 35, fontWeight: FontWeight.bold),
                        decoration: InputDecoration(
                          labelText: "Hora",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          counterText: "",
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(":",
                        style: TextStyle(
                            fontSize: 48, fontWeight: FontWeight.bold)),
                    SizedBox(width: 8),
                    Container(
                      height: 70,
                      width: 80,
                      child: TextFormField(
                        controller: _afternoonSnackScheduleMinuteController,
                        maxLength: 2,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        textAlignVertical: TextAlignVertical.center,
                        style: TextStyle(
                            fontSize: 35, fontWeight: FontWeight.bold),
                        decoration: InputDecoration(
                          labelText: "Minuto",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          counterText: "",
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 8),

// CENA
                Row(
                  children: [
                    Text(
                      "Cena",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(width: 12),
                    Container(
                      height: 70,
                      width: 80,
                      child: TextFormField(
                        controller: _dinnerScheduleHourController,
                        maxLength: 2,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        textAlignVertical: TextAlignVertical.center,
                        style: TextStyle(
                            fontSize: 35, fontWeight: FontWeight.bold),
                        decoration: InputDecoration(
                          labelText: "Hora",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          counterText: "",
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(":",
                        style: TextStyle(
                            fontSize: 48, fontWeight: FontWeight.bold)),
                    SizedBox(width: 8),
                    Container(
                      height: 70,
                      width: 80,
                      child: TextFormField(
                        controller: _dinnerScheduleMinuteController,
                        maxLength: 2,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        textAlignVertical: TextAlignVertical.center,
                        style: TextStyle(
                            fontSize: 35, fontWeight: FontWeight.bold),
                        decoration: InputDecoration(
                          labelText: "Minuto",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          counterText: "",
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    if (_breakfastScheduleHourController.text == "") {
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
                    } else if (double.parse(_breakfastScheduleHourController.text) < 0 ||
                        double.parse(_breakfastScheduleHourController.text) >
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
                    } else if (_breakfastScheduleMinuteController.text == "") {
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
                    } else if (double.parse(_breakfastScheduleMinuteController.text) < 0 ||
                        double.parse(_breakfastScheduleMinuteController.text) >
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
                    } else if (_snackScheduleHourController.text == "") {
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
                    } else if (double.parse(_snackScheduleHourController.text) < 0 ||
                        double.parse(_snackScheduleHourController.text) > 23) {
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
                    } else if (_snackScheduleMinuteController.text == "") {
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
                    } else if (double.parse(_snackScheduleMinuteController.text) < 0 ||
                        double.parse(_snackScheduleMinuteController.text) >
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
                    } else if (_lunchScheduleHourController.text == "") {
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
                    } else if (double.parse(_lunchScheduleHourController.text) < 0 ||
                        double.parse(_lunchScheduleHourController.text) > 59) {
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
                    } else if (_lunchScheduleMinuteController.text == "") {
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
                    } else if (double.parse(_lunchScheduleMinuteController.text) < 0 ||
                        double.parse(_lunchScheduleMinuteController.text) >
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
                    } else if (_afternoonSnackScheduleHourController.text ==
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
                    } else if (double.parse(_afternoonSnackScheduleHourController.text) < 0 ||
                        double.parse(_afternoonSnackScheduleHourController.text) >
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
                    } else if (_afternoonSnackScheduleMinuteController.text ==
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
                    } else if (double.parse(_afternoonSnackScheduleMinuteController.text) < 0 ||
                        double.parse(_afternoonSnackScheduleMinuteController.text) >
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
                    } else if (_dinnerScheduleHourController.text == "") {
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
                    } else if (double.parse(_dinnerScheduleHourController.text) <
                            0 ||
                        double.parse(_dinnerScheduleHourController.text) > 59) {
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
                    } else if (_dinnerScheduleMinuteController.text == "") {
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
                    } else if (double.parse(_dinnerScheduleMinuteController.text) <
                            0 ||
                        double.parse(_dinnerScheduleMinuteController.text) > 59) {
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
                                  child:
                                      BackgroundBase(child: DietMainPage()))));
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
