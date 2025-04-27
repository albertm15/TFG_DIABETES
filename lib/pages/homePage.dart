import 'package:diabetes_tfg_app/database/firebase/glucoseLogDAO.dart';
import 'package:diabetes_tfg_app/models/gluoseLogModel.dart';
import 'package:diabetes_tfg_app/widgets/dailyGlucoseEvolutionChart.dart';
import 'package:diabetes_tfg_app/widgets/glucoseEssentialInfo.dart';
import 'package:diabetes_tfg_app/widgets/lowerNavBar.dart';
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
    return Scaffold(
      appBar: UpperNavBar(pageName: "Home Page"),
      //body: Container(child: Center(child: Text("Hello"))),
      body: Container(child: Center(child: HomePageWidget())),
      bottomNavigationBar: LowerNavBar(),
      backgroundColor: Colors.transparent,
    );
  }
}

class HomePageWidget extends StatefulWidget {
  @override
  _HomePageWidgetState createState() => _HomePageWidgetState();
}

class _HomePageWidgetState extends State<HomePageWidget> {
  List<GlucoseLogModel> daylogs = [];
  List<GlucoseLogModel> weeklogs = [];
  int minGlucose = 0;
  int maxGlucose = 0;
  double avgGlucose = 0;
  int hyperglucemies = 0;
  int hypoglucemies = 0;

  Future<void> getTodaysData() async {
    GlucoseLogDAOFB dao = GlucoseLogDAOFB();
    daylogs = await dao.getTodayLogs();
  }

  Future<void> getLast7DaysData() async {
    GlucoseLogDAOFB dao = GlucoseLogDAOFB();
    weeklogs = await dao.getLast7DaysLogs();
  }

  void loadHypoHyper() {
    if (!weeklogs.isEmpty) {
      for (GlucoseLogModel log in weeklogs) {
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
    if (!weeklogs.isEmpty) {
      minGlucose = weeklogs[0].glucoseValue;
      for (GlucoseLogModel log in weeklogs) {
        avgGlucose = avgGlucose + log.glucoseValue;
        if (maxGlucose < log.glucoseValue) {
          maxGlucose = log.glucoseValue;
        }
        if (minGlucose > log.glucoseValue) {
          minGlucose = log.glucoseValue;
        }
      }
      avgGlucose = avgGlucose / weeklogs.length;
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
        child: Column(
      children: [
        GlucoseEssentialInfo(
          hyperglucemies: hyperglucemies,
          avgGlucose: avgGlucose,
          hypoglucemies: hypoglucemies,
        ),
        SizedBox(height: 16),
        Container(
          height: 200,
          /*
          child: DailyGlucoseEvolutionChart(glucoseData: [
            FlSpot(0, 100),
            FlSpot(3, 90),
            FlSpot(6, 95),
            FlSpot(9, 120),
            FlSpot(12, 150),
            FlSpot(15, 380),
            FlSpot(18, 270),
            FlSpot(21, 100)
          ]), 
          */
          child: DailyGlucoseEvolutionChart(glucoseData: daylogs),
        )
      ],
    ));
  }
}
