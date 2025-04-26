import 'package:diabetes_tfg_app/widgets/dailyGlucoseEvolutionChart.dart';
import 'package:diabetes_tfg_app/widgets/glucoseEssentialInfo.dart';
import 'package:diabetes_tfg_app/widgets/lowerNavBar.dart';
import 'package:diabetes_tfg_app/widgets/screenMargins.dart';
import 'package:diabetes_tfg_app/widgets/upperNavBar.dart';
import 'package:fl_chart/fl_chart.dart';
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

class HomePageWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenMargins(
        child: Column(
      children: [
        GlucoseEssentialInfo(),
        SizedBox(height: 16),
        Container(
          height: 200,
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
        )
      ],
    ));
  }
}
