import 'package:diabetes_tfg_app/database/firebase/authServiceManager.dart';
import 'package:diabetes_tfg_app/database/firebase/exerciceLogDAO.dart';
import 'package:diabetes_tfg_app/database/firebase/reminderDAO.dart';
import 'package:diabetes_tfg_app/database/local/exerciceLogDAO.dart';
import 'package:diabetes_tfg_app/database/local/reminderDAO.dart';
import 'package:diabetes_tfg_app/models/exerciceLogModel.dart';
import 'package:diabetes_tfg_app/models/reminderModel.dart';
import 'package:diabetes_tfg_app/widgets/MinimizedReminderListHorizontal.dart';
import 'package:diabetes_tfg_app/widgets/backgroundBase.dart';
import 'package:diabetes_tfg_app/widgets/drawerScaffold.dart';
import 'package:diabetes_tfg_app/widgets/lowerNavBar.dart';
import 'package:diabetes_tfg_app/widgets/minimizedLogsListExercice.dart';
import 'package:diabetes_tfg_app/widgets/screenMargins.dart';
import 'package:diabetes_tfg_app/widgets/upperNavBar.dart';
import 'package:diabetes_tfg_app/widgets/weeklyCalendar.dart';
import 'package:flutter/material.dart';

class ExerciceAndHealthMainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DrawerScaffold(
        child: BackgroundBase(
            child: Scaffold(
      appBar: UpperNavBar(pageName: "Ejercicio y Salud"),
      body: BackgroundBase(
          child: Center(child: _ExerciceAndHealthMainPageWidget())),
      bottomNavigationBar: LowerNavBar(selectedSection: "exercice"),
      backgroundColor: Colors.transparent,
    )));
  }
}

class _ExerciceAndHealthMainPageWidget extends StatefulWidget {
  @override
  _ExerciceAndHealthMainPageWidgetState createState() =>
      _ExerciceAndHealthMainPageWidgetState();
}

class _ExerciceAndHealthMainPageWidgetState
    extends State<_ExerciceAndHealthMainPageWidget> {
  List<ReminderModel> reminderList = [];
  List<ExerciceLogModel> exLogs = [];

  void loadData() async {
    if (AuthServiceManager.checkIfLogged()) {
      ReminderDAOFB dao = ReminderDAOFB();
      reminderList = await dao.getActiveReminders();
      ExerciceLogDAOFB dao2 = ExerciceLogDAOFB();
      exLogs = await dao2.getLast7DaysLogs();
    } else {
      ReminderDAO dao = ReminderDAO();
      reminderList = await dao.getWeekLogs();
      ExerciceLogDAO dao2 = ExerciceLogDAO();
      exLogs = await dao2.getWeekLogs();
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenMargins(
        child: SingleChildScrollView(
      child: Column(
        children: [
          WeeklyCalendar(),
          SizedBox(height: 16),
          MinimizedReminderListHorizontal(reminders: reminderList),
          SizedBox(height: 10),
          Container(height: 500, child: MinimizedLogsListExercice(logs: exLogs))
        ],
      ),
    ));
  }
}
