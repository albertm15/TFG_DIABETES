import 'package:diabetes_tfg_app/database/firebase/authServiceManager.dart';
import 'package:diabetes_tfg_app/database/firebase/glucoseLogDAO.dart';
import 'package:diabetes_tfg_app/database/local/glucoseLogDAO.dart';
import 'package:diabetes_tfg_app/models/gluoseLogModel.dart';
import 'package:diabetes_tfg_app/widgets/dailyGlucoseEvolutionChart.dart';
import 'package:diabetes_tfg_app/widgets/glucoseCategoryRoundChartAdaptableSize.dart';
import 'package:diabetes_tfg_app/widgets/glucoseHyperHypoBarChart.dart';
import 'package:flutter/material.dart';

class DayChartsPage extends StatefulWidget {
  @override
  _DayChartsPageState createState() => _DayChartsPageState();
}

class _DayChartsPageState extends State<DayChartsPage> {
  List<GlucoseLogModel> daylogs = [];
  int highLevel = 0;
  int normalLevel = 0;
  int lowLevel = 0;
  int hyperglucemies = 0;
  int hypoglucemies = 0;

  void getTodaysData() async {
    if (AuthServiceManager.checkIfLogged()) {
      GlucoseLogDAOFB dao = GlucoseLogDAOFB();
      daylogs = await dao.getTodayLogs();
    } else {
      GlucoseLogDAO dao = GlucoseLogDAO();
      daylogs = await dao.getTodayLogs();
    }
    if (!daylogs.isEmpty) {
      for (GlucoseLogModel log in daylogs) {
        if (log.category == "Elevado") {
          highLevel += 1;
        } else if (log.category == "Bajo") {
          lowLevel += 1;
        } else if (log.category == "Normal") {
          normalLevel += 1;
        } else {}
      }
      for (GlucoseLogModel log in daylogs) {
        if (log.hyperglucemia) {
          hyperglucemies += 1;
        }
        if (log.hypoglucemia) {
          hypoglucemies += 1;
        }
      }
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getTodaysData();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "Graficos de glucosa diaria",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        Expanded(
          child: DailyGlucoseEvolutionChart(glucoseData: daylogs),
        ),
        SizedBox(height: 18),
        Expanded(
          child: GlucoseCategoryRoundChartAdaptableSize(
            high: highLevel,
            low: lowLevel,
            normal: normalLevel,
          ),
        ),
        SizedBox(height: 18),
        Expanded(
          child: GlucoseHyperHypoBarChart(
            hyperCount: hyperglucemies,
            hypoCount: hypoglucemies,
          ),
        ),
      ],
    );
  }
}
