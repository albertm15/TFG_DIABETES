import 'package:diabetes_tfg_app/auxiliarResources/undefinedTypeLog.dart';
import 'package:diabetes_tfg_app/database/firebase/authServiceManager.dart';
import 'package:diabetes_tfg_app/database/firebase/dietLogDAO.dart';
import 'package:diabetes_tfg_app/database/firebase/exerciceLogDAO.dart';
import 'package:diabetes_tfg_app/database/firebase/glucoseLogDAO.dart';
import 'package:diabetes_tfg_app/database/firebase/insulinLogDAO.dart';
import 'package:diabetes_tfg_app/database/local/dietLogDAO.dart';
import 'package:diabetes_tfg_app/database/local/exerciceLogDAO.dart';
import 'package:diabetes_tfg_app/database/local/glucoseLogDAO.dart';
import 'package:diabetes_tfg_app/database/local/insulinLogDAO.dart';
import 'package:diabetes_tfg_app/models/InsulinLogModel.dart';
import 'package:diabetes_tfg_app/models/dietLogModel.dart';
import 'package:diabetes_tfg_app/models/exerciceLogModel.dart';
import 'package:diabetes_tfg_app/models/gluoseLogModel.dart';
import 'package:diabetes_tfg_app/pages/selectLogTypeToRegister.dart';
import 'package:diabetes_tfg_app/widgets/backgroundBase.dart';
import 'package:diabetes_tfg_app/widgets/dietListTile.dart';
import 'package:diabetes_tfg_app/widgets/drawerScaffold.dart';
import 'package:diabetes_tfg_app/widgets/exerciceListTile.dart';
import 'package:diabetes_tfg_app/widgets/glucoseListTile.dart';
import 'package:diabetes_tfg_app/widgets/insulinListTile.dart';
import 'package:diabetes_tfg_app/widgets/lowerNavBar.dart';
import 'package:diabetes_tfg_app/widgets/screenMargins.dart';
import 'package:diabetes_tfg_app/widgets/upperNavBar.dart';
import 'package:flutter/material.dart';

class AllLogsPage extends StatefulWidget {
  @override
  _AllLogsPageState createState() => _AllLogsPageState();
}

class _AllLogsPageState extends State<AllLogsPage> {
  @override
  Widget build(BuildContext context) {
    return DrawerScaffold(
        child: BackgroundBase(
            child: Scaffold(
      appBar: UpperNavBar(pageName: "Todos los registros"),
      body: BackgroundBase(child: Center(child: _AllLogsPageWidget())),
      bottomNavigationBar: LowerNavBar(),
      backgroundColor: Colors.transparent,
    )));
  }
}

class _AllLogsPageWidget extends StatefulWidget {
  @override
  _AllLogsPageWidgetState createState() => _AllLogsPageWidgetState();
}

class _AllLogsPageWidgetState extends State<_AllLogsPageWidget> {
  bool glucoseButtonChecked = true;
  bool insulinButtonChecked = true;
  bool foodButtonChecked = true;
  bool exerciceButtonChecked = true;

  List<GlucoseLogModel> glucoseLogs = [];
  List<InsulinLogModel> insulinLogs = [];
  List<DietLogModel> dietLogs = [];
  List<ExerciceLogModel> exerciceLogs = [];

  List<UndefinedTypeLog> sortAllLogs() {
    List<UndefinedTypeLog> allLogs = [];
    for (GlucoseLogModel log in this.glucoseLogs) {
      String dateTime = "${log.date} ${log.time}";
      allLogs.add(UndefinedTypeLog(
          id: log.id,
          dateTime: dateTime,
          log: log,
          type: "glucose",
          category: log.category,
          value: log.glucoseValue.toDouble()));
    }

    for (InsulinLogModel log in this.insulinLogs) {
      String dateTime = "${log.date} ${log.time}";
      allLogs.add(UndefinedTypeLog(
          id: log.id,
          dateTime: dateTime,
          log: log,
          type: "insulin",
          category: log.location,
          value: log.fastActingInsulinConsumed));
    }

    for (DietLogModel log in this.dietLogs) {
      String dateTime = "${log.date} ${log.time}";
      allLogs.add(UndefinedTypeLog(
          id: log.id,
          dateTime: dateTime,
          log: log,
          type: "diet",
          category: "",
          value: log.totalCarbs.toDouble()));
    }

    for (ExerciceLogModel log in this.exerciceLogs) {
      String dateTime = "${log.date} ${log.time}";
      allLogs.add(UndefinedTypeLog(
          id: log.id,
          dateTime: dateTime,
          log: log,
          type: "exercice",
          category: log.category,
          value: log.duration.toDouble()));
    }

    allLogs.sort((a, b) => -a.dateTime.compareTo(b.dateTime));
    return allLogs;
  }

  DateTime parseDateTime(String date, String time) {
    List<String> dateSplit = date.split("-");
    List<String> timeSplit = time.split(":");
    return DateTime(
        int.parse(dateSplit[2]),
        int.parse(dateSplit[1]),
        int.parse(dateSplit[0]),
        int.parse(timeSplit[0]),
        int.parse(timeSplit[1]),
        int.parse(timeSplit[2]));
  }

  void loadData() async {
    glucoseLogs = [];
    insulinLogs = [];
    dietLogs = [];
    exerciceLogs = [];
    if (AuthServiceManager.checkIfLogged()) {
      if (glucoseButtonChecked) {
        GlucoseLogDAOFB dao = GlucoseLogDAOFB();
        glucoseLogs = await dao.getAll();
      }
      if (insulinButtonChecked) {
        InsulinLogDAOFB dao2 = InsulinLogDAOFB();
        insulinLogs = await dao2.getAll();
      }
      if (foodButtonChecked) {
        DietLogDAOFB dao3 = DietLogDAOFB();
        dietLogs = await dao3.getAll();
      }
      if (exerciceButtonChecked) {
        ExerciceLogDAOFB dao4 = ExerciceLogDAOFB();
        exerciceLogs = await dao4.getAll();
      }
    } else {
      if (glucoseButtonChecked) {
        GlucoseLogDAO dao = GlucoseLogDAO();
        glucoseLogs = await dao.getAll();
      }
      if (insulinButtonChecked) {
        InsulinLogDAO dao2 = InsulinLogDAO();
        insulinLogs = await dao2.getAll();
      }
      if (foodButtonChecked) {
        DietLogDAO dao3 = DietLogDAO();
        dietLogs = await dao3.getAll();
      }
      if (exerciceButtonChecked) {
        ExerciceLogDAO dao4 = ExerciceLogDAO();
        exerciceLogs = await dao4.getAll();
      }
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
    List<UndefinedTypeLog> allLogs = sortAllLogs();
    return ScreenMargins(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 75,
                height: 75,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      glucoseButtonChecked = !glucoseButtonChecked;
                      loadData();
                    });
                  },
                  child: Center(
                    child: Icon(
                      Icons.water_drop_outlined,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.zero,
                    backgroundColor: glucoseButtonChecked
                        ? Color(0xFF3C37FF)
                        : Color.fromARGB(255, 118, 118, 118),
                    alignment: Alignment.center,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 8),
              SizedBox(
                width: 75,
                height: 75,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      insulinButtonChecked = !insulinButtonChecked;
                      loadData();
                    });
                  },
                  child: Center(
                    child: Image.asset(
                      'assets/images/Insulin_image_white.png',
                      width: 40,
                      height: 40,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.zero,
                    backgroundColor: insulinButtonChecked
                        ? Color(0xFF3C37FF)
                        : Color.fromARGB(255, 118, 118, 118),
                    alignment: Alignment.center,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 8),
              SizedBox(
                width: 75,
                height: 75,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      foodButtonChecked = !foodButtonChecked;
                      loadData();
                    });
                  },
                  child: Center(
                    child: Icon(
                      Icons.fastfood_outlined,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.zero,
                    backgroundColor: foodButtonChecked
                        ? Color(0xFF3C37FF)
                        : Color.fromARGB(255, 118, 118, 118),
                    alignment: Alignment.center,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 8),
              SizedBox(
                width: 75,
                height: 75,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      exerciceButtonChecked = !exerciceButtonChecked;
                      loadData();
                    });
                  },
                  child: Center(
                    child: Icon(
                      Icons.directions_run_rounded,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.zero,
                    backgroundColor: exerciceButtonChecked
                        ? Color(0xFF3C37FF)
                        : Color.fromARGB(255, 118, 118, 118),
                    alignment: Alignment.center,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Expanded(
            child: ListView.builder(
              itemCount: allLogs.length,
              itemBuilder: (context, index) {
                final log = allLogs[index];
                if (log.type == "glucose") {
                  return GlucoseListTile(log: log);
                } else if (log.type == "insulin") {
                  return InsulinListTile(log: log);
                } else if (log.type == "diet") {
                  return DietListTile(log: log);
                } else if (log.type == "exercice") {
                  return ExerciceListTile(log: log);
                } else {
                  return SizedBox.shrink();
                }
              },
            ),
          ),
          SizedBox(
            height: 20,
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DrawerScaffold(
                          child: BackgroundBase(
                              child: SelectLogTypeToRegister()))));
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF3C37FF),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: EdgeInsets.symmetric(horizontal: 100, vertical: 15),
            ),
            child: Text("Añadir registro", style: TextStyle(fontSize: 18)),
          ),
        ],
      ),
    );
  }
}
