import 'package:diabetes_tfg_app/database/firebase/authServiceManager.dart';
import 'package:diabetes_tfg_app/database/firebase/glucoseLogDAO.dart';
import 'package:diabetes_tfg_app/database/local/glucoseLogDAO.dart';
import 'package:diabetes_tfg_app/models/gluoseLogModel.dart';
import 'package:diabetes_tfg_app/pages/allChartsPage.dart';
import 'package:diabetes_tfg_app/widgets/backgroundBase.dart';
import 'package:diabetes_tfg_app/widgets/drawerScaffold.dart';
import 'package:diabetes_tfg_app/widgets/glucoseCategoryRoundChart.dart';
import 'package:diabetes_tfg_app/widgets/glucoseEssentialInfoAmplified.dart';
import 'package:diabetes_tfg_app/widgets/lowerNavBar.dart';
import 'package:diabetes_tfg_app/widgets/minimizedLogsListGlucose.dart';
import 'package:diabetes_tfg_app/widgets/screenMargins.dart';
import 'package:diabetes_tfg_app/widgets/upperNavBar.dart';
import 'package:flutter/material.dart';

class GlucoseMainPage extends StatefulWidget {
  @override
  _GlucoseMainPageState createState() => _GlucoseMainPageState();
}

class _GlucoseMainPageState extends State<GlucoseMainPage> {
  @override
  Widget build(BuildContext context) {
    return DrawerScaffold(
        child: BackgroundBase(
            child: Scaffold(
      appBar: UpperNavBar(pageName: "Glucose"),
      body: BackgroundBase(child: Center(child: GlucoseMainPageWidget())),
      bottomNavigationBar: LowerNavBar(),
      backgroundColor: Colors.transparent,
    )));
  }
}

class GlucoseMainPageWidget extends StatefulWidget {
  @override
  _GlucoseMainPageWidgetSate createState() => _GlucoseMainPageWidgetSate();
}

class _GlucoseMainPageWidgetSate extends State<GlucoseMainPageWidget> {
  List<GlucoseLogModel> glucoseWeeklogs = [];
  int minGlucose = 0;
  int maxGlucose = 0;
  double avgGlucose = 0;
  int hyperglucemies = 0;
  int hypoglucemies = 0;
  int highLevel = 0;
  int normalLevel = 0;
  int lowLevel = 0;

  Future<void> getLast7DaysData() async {
    if (AuthServiceManager.checkIfLogged()) {
      GlucoseLogDAOFB dao = GlucoseLogDAOFB();
      glucoseWeeklogs = await dao.getLast7DaysLogs();
    } else {
      GlucoseLogDAO dao = GlucoseLogDAO();
      glucoseWeeklogs = await dao.getWeekLogs();
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

  void loadGlucoseCategories() {
    if (!glucoseWeeklogs.isEmpty) {
      for (GlucoseLogModel log in glucoseWeeklogs) {
        if (log.category == "Elevado") {
          highLevel += 1;
        } else if (log.category == "Bajo") {
          lowLevel += 1;
        } else if (log.category == "Normal") {
          normalLevel += 1;
        } else {}
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

  Future<void> getData() async {
    await Future.wait([getLast7DaysData()]);
    loadMinMaxAvgGlucose();
    loadHypoHyper();
    loadGlucoseCategories();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenMargins(
        child: SingleChildScrollView(
      child: Column(
        children: [
          GlucoseEssentialInfoAmplified(
              hypoglucemies: hypoglucemies,
              avgGlucose: avgGlucose,
              hyperglucemies: hyperglucemies,
              minGlucose: minGlucose,
              maxGlucose: maxGlucose),
          SizedBox(
            height: 12,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GlucoseCategoryRoundChart(
                  high: highLevel, normal: normalLevel, low: lowLevel),
              IconButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DrawerScaffold(
                                child:
                                    BackgroundBase(child: AllChartsPage()))));
                  },
                  icon: Icon(
                    Icons.unfold_more_rounded,
                    color: Colors.black,
                  )),
            ],
          ),
          SizedBox(height: 8),
          Container(
              height: 500,
              child: MinimizedLogsListGlucose(glucoseLogs: glucoseWeeklogs))
        ],
      ),
    ));
  }
}
