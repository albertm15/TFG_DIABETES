import 'package:diabetes_tfg_app/database/firebase/authServiceManager.dart';
import 'package:diabetes_tfg_app/database/firebase/glucoseLogDAO.dart';
import 'package:diabetes_tfg_app/database/local/glucoseLogDAO.dart';
import 'package:diabetes_tfg_app/models/gluoseLogModel.dart';
import 'package:diabetes_tfg_app/widgets/glucoseCategoryRoundChartAdaptableSize.dart';
import 'package:diabetes_tfg_app/widgets/glucoseHyperHypoBarChart.dart';
import 'package:flutter/material.dart';

class WeekChartsPage extends StatefulWidget {
  @override
  _WeekChartsPageState createState() => _WeekChartsPageState();
}

class _WeekChartsPageState extends State<WeekChartsPage> {
  List<GlucoseLogModel> weekLogs = [];
  int highLevel = 0;
  int normalLevel = 0;
  int lowLevel = 0;
  int hyperglucemies = 0;
  int hypoglucemies = 0;

  void getTodaysData() async {
    if (AuthServiceManager.checkIfLogged()) {
      GlucoseLogDAOFB dao = GlucoseLogDAOFB();
      weekLogs = await dao.getLast7DaysLogs();
    } else {
      GlucoseLogDAO dao = GlucoseLogDAO();
      weekLogs = await dao.getWeekLogs();
    }
    if (!weekLogs.isEmpty) {
      for (GlucoseLogModel log in weekLogs) {
        if (log.category == "Elevado") {
          highLevel += 1;
        } else if (log.category == "Bajo") {
          lowLevel += 1;
        } else if (log.category == "Normal") {
          normalLevel += 1;
        } else {}
      }
      for (GlucoseLogModel log in weekLogs) {
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
          "Graficos de glucosa semanal",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
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
