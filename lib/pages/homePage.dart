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
import 'package:diabetes_tfg_app/widgets/backgroundBase.dart';
import 'package:diabetes_tfg_app/widgets/dailyGlucoseEvolutionChart.dart';
import 'package:diabetes_tfg_app/widgets/drawerScaffold.dart';
import 'package:diabetes_tfg_app/widgets/glucoseEssentialInfo.dart';
import 'package:diabetes_tfg_app/widgets/lowerNavBar.dart';
import 'package:diabetes_tfg_app/widgets/minimizedLogsListHome.dart';
import 'package:diabetes_tfg_app/widgets/screenMargins.dart';
import 'package:diabetes_tfg_app/widgets/upperNavBar.dart';
import 'package:flutter/material.dart';

class Homepage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    return DrawerScaffold(
        child: BackgroundBase(
            child: Scaffold(
      appBar: UpperNavBar(pageName: "Home Page"),
      //body: Container(child: Center(child: Text("Hello"))),
      body: Container(child: Center(child: HomePageWidget())),
      bottomNavigationBar: LowerNavBar(selectedSection: "home"),
      backgroundColor: Colors.transparent,
    )));
  }
}

class HomePageWidget extends StatefulWidget {
  @override
  _HomePageWidgetState createState() => _HomePageWidgetState();
}

class _HomePageWidgetState extends State<HomePageWidget> {
  List<GlucoseLogModel> daylogs = [];
  List<GlucoseLogModel> glucoseWeeklogs = [];
  List<InsulinLogModel> insulinWeeklogs = [];
  List<DietLogModel> dietWeeklogs = [];
  List<ExerciceLogModel> exerciceWeeklogs = [];
  int minGlucose = 0;
  int maxGlucose = 0;
  double avgGlucose = 0;
  int hyperglucemies = 0;
  int hypoglucemies = 0;

  Future<void> getTodaysData() async {
    if (AuthServiceManager.checkIfLogged()) {
      GlucoseLogDAOFB dao = GlucoseLogDAOFB();
      daylogs = await dao.getTodayLogs();
    } else {
      GlucoseLogDAO dao = GlucoseLogDAO();
      daylogs = await dao.getTodayLogs();
    }
  }

  Future<void> getLast7DaysData() async {
    if (AuthServiceManager.checkIfLogged()) {
      GlucoseLogDAOFB dao = GlucoseLogDAOFB();
      InsulinLogDAOFB dao2 = InsulinLogDAOFB();
      DietLogDAOFB dao3 = DietLogDAOFB();
      ExerciceLogDAOFB dao4 = ExerciceLogDAOFB();
      glucoseWeeklogs = await dao.getLast7DaysLogs();
      insulinWeeklogs = await dao2.getLast7DaysLogs();
      dietWeeklogs = await dao3.getLast7DaysLogs();
      exerciceWeeklogs = await dao4.getLast7DaysLogs();
    } else {
      GlucoseLogDAO dao = GlucoseLogDAO();
      InsulinLogDAO dao2 = InsulinLogDAO();
      DietLogDAO dao3 = DietLogDAO();
      ExerciceLogDAO dao4 = ExerciceLogDAO();
      glucoseWeeklogs = await dao.getWeekLogs();
      insulinWeeklogs = await dao2.getWeekLogs();
      dietWeeklogs = await dao3.getWeekLogs();
      exerciceWeeklogs = await dao4.getWeekLogs();
    }
  }

  void loadHypoHyper() {
    if (!glucoseWeeklogs.isEmpty) {
      for (GlucoseLogModel log in glucoseWeeklogs) {
        if (log.hyperglucemia) {
          hyperglucemies += 1;
        }
        if (log.hypoglucemia) {
          hypoglucemies += 1;
        }
      }
    }
  }

  void loadMinMaxAvgGlucose() {
    if (!glucoseWeeklogs.isEmpty) {
      minGlucose = glucoseWeeklogs[0].glucoseValue;
      for (GlucoseLogModel log in glucoseWeeklogs) {
        avgGlucose = avgGlucose + log.glucoseValue;
        if (maxGlucose < log.glucoseValue) {
          maxGlucose = log.glucoseValue;
        }
        if (minGlucose > log.glucoseValue) {
          minGlucose = log.glucoseValue;
        }
      }
      avgGlucose = avgGlucose / glucoseWeeklogs.length;
    }
  }

  Future<void> getHomeData() async {
    await Future.wait([getTodaysData(), getLast7DaysData()]);
    loadMinMaxAvgGlucose();
    loadHypoHyper();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getHomeData();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenMargins(
        child: SingleChildScrollView(
      child: Column(
        children: [
          GlucoseEssentialInfo(
            hyperglucemies: hyperglucemies,
            avgGlucose: avgGlucose,
            hypoglucemies: hypoglucemies,
          ),
          SizedBox(height: 16),
          Row(
            children: [
              SizedBox(width: 3),
              Expanded(
                child: Container(
                  height: 200,
                  child: DailyGlucoseEvolutionChart(glucoseData: daylogs),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Container(
              height: 500,
              child: MinimizedLogsListHome(
                  glucoseLogs: glucoseWeeklogs,
                  insulinLogs: insulinWeeklogs,
                  dietLogs: dietWeeklogs,
                  exerciceLogs: exerciceWeeklogs))
        ],
      ),
    ));
  }
}
