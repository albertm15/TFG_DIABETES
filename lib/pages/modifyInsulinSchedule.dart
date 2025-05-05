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
  @override
  _ModifyInsulinScheduleState createState() => _ModifyInsulinScheduleState();
}

class _ModifyInsulinScheduleState extends State<ModifyInsulinSchedule> {
  String firstInjectionSchedule = "";
  String secondInjectionSchedule = "";
  List<InsulinModel> log = [];
  final TextEditingController _firstInjectionScheduleController =
      TextEditingController();
  final TextEditingController _secondInjectionScheduleController =
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
        insulin.firstInjectionSchedule = _firstInjectionScheduleController.text;
        insulin.secondInjectionSchedule =
            _secondInjectionScheduleController.text;
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
        insulin.firstInjectionSchedule = _firstInjectionScheduleController.text;
        insulin.secondInjectionSchedule =
            _secondInjectionScheduleController.text;
        await dao.update(insulin);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UpperNavBar(pageName: "Horario Insulina"),
      body: ScreenMargins(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 400),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  "Modificar horario de insulina",
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 85, 42, 196)),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 24),
                TextFormField(
                  controller: _firstInjectionScheduleController,
                  onTap: () async {
                    final TimeOfDay? picked = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );
                    if (picked != null) {
                      final formattedTime = picked.format(context);
                      _firstInjectionScheduleController.text = formattedTime;
                    }
                  },
                  keyboardType: TextInputType.datetime,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
                  decoration: InputDecoration(
                    labelText: "Horario de la primera inyección",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _secondInjectionScheduleController,
                        keyboardType: TextInputType.datetime,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 48, fontWeight: FontWeight.bold),
                        decoration: InputDecoration(
                          labelText: "Horario de la segunda inyección",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                    Text(
                      ":",
                      style:
                          TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
                    ),
                    Expanded(
                      child: TextFormField(
                        controller: _secondInjectionScheduleController,
                        keyboardType: TextInputType.datetime,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 48, fontWeight: FontWeight.bold),
                        decoration: InputDecoration(
                          labelText: "Horario de la segunda inyección",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(height: 32),
                ElevatedButton(
                  onPressed: () {
                    saveData();
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DrawerScaffold(
                                child:
                                    BackgroundBase(child: InsulinMainPage()))));
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
