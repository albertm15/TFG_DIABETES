import 'package:diabetes_tfg_app/database/firebase/authServiceManager.dart';
import 'package:diabetes_tfg_app/database/firebase/glucoseLogDAO.dart';
import 'package:diabetes_tfg_app/database/local/glucoseLogDAO.dart';
import 'package:diabetes_tfg_app/models/gluoseLogModel.dart';
import 'package:diabetes_tfg_app/widgets/glucoseCategoryRoundChartAdaptableSize.dart';
import 'package:diabetes_tfg_app/widgets/glucoseHyperHypoBarChart.dart';
import 'package:flutter/material.dart';

class TrimesterChartsPage extends StatefulWidget {
  @override
  _TrimesterChartsPageState createState() => _TrimesterChartsPageState();
}

class _TrimesterChartsPageState extends State<TrimesterChartsPage> {
  List<GlucoseLogModel> trimesterLogs = [];
  int highLevel = 0;
  int normalLevel = 0;
  int lowLevel = 0;
  int hyperglucemies = 0;
  int hypoglucemies = 0;

  Future<void> getTrimesterData() async {
    if (AuthServiceManager.checkIfLogged()) {
      GlucoseLogDAOFB dao = GlucoseLogDAOFB();
      trimesterLogs = await dao.getLast90DaysLogs();
    } else {
      GlucoseLogDAO dao = GlucoseLogDAO();
      trimesterLogs = await dao.getLast90DaysLogs();
    }
  }

  Future<void> getData() async {
    await getTrimesterData();
    loadHypoHyper();
    loadGlucoseCategories();
    setState(() {});
  }

  void loadHypoHyper() {
    if (!trimesterLogs.isEmpty) {
      for (GlucoseLogModel log in trimesterLogs) {
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
    if (!trimesterLogs.isEmpty) {
      for (GlucoseLogModel log in trimesterLogs) {
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

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "Graficos de glucosa trimestral",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
