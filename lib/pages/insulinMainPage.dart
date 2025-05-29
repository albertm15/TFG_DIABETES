import 'dart:io';
import 'package:diabetes_tfg_app/database/firebase/authServiceManager.dart';
import 'package:diabetes_tfg_app/database/firebase/insulinDAO.dart';
import 'package:diabetes_tfg_app/database/firebase/insulinLogDAO.dart';
import 'package:diabetes_tfg_app/database/local/insulinDAO.dart';
import 'package:diabetes_tfg_app/database/local/insulinLogDAO.dart';
import 'package:diabetes_tfg_app/models/InsulinLogModel.dart';
import 'package:diabetes_tfg_app/models/insulinModel.dart';
import 'package:diabetes_tfg_app/widgets/addPunctualInjection.dart';
import 'package:diabetes_tfg_app/widgets/backgroundBase.dart';
import 'package:diabetes_tfg_app/widgets/drawerScaffold.dart';
import 'package:diabetes_tfg_app/widgets/insulinEssentialInfo.dart';
import 'package:diabetes_tfg_app/widgets/legendItem.dart';
import 'package:diabetes_tfg_app/widgets/lowerNavBar.dart';
import 'package:diabetes_tfg_app/widgets/screenMargins.dart';
import 'package:diabetes_tfg_app/widgets/slowActingInsulinScheduleInfo.dart';
import 'package:diabetes_tfg_app/widgets/upperNavBar.dart';
import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';

class InsulinMainPage extends StatefulWidget {
  @override
  _InsulinMainPageState createState() => _InsulinMainPageState();
}

class _InsulinMainPageState extends State<InsulinMainPage> {
  @override
  Widget build(BuildContext context) {
    return DrawerScaffold(
        child: BackgroundBase(
            child: Scaffold(
      appBar: UpperNavBar(pageName: "Insulina"),
      body: BackgroundBase(child: Center(child: InsulinMainPageWidget())),
      bottomNavigationBar: LowerNavBar(selectedSection: "insulin"),
      backgroundColor: Colors.transparent,
    )));
  }
}

class InsulinMainPageWidget extends StatefulWidget {
  @override
  _InsulinMainPageWidgetState createState() => _InsulinMainPageWidgetState();
}

class _InsulinMainPageWidgetState extends State<InsulinMainPageWidget> {
  List<InsulinModel> log = [];
  List<InsulinLogModel> log2 = [];
  double fastActingInsulin = 0;
  double slowActingInsulin = 0;
  String firstInjectionSchedule = "";
  String secondInjectionSchedule = "";
  List<int> locationsCount = [0, 0, 0, 0, 0, 0, 0];

  void getData() async {
    if (AuthServiceManager.checkIfLogged()) {
      InsulinDAOFB dao = InsulinDAOFB();
      log = await dao.getAll();
      InsulinLogDAOFB dao2 = InsulinLogDAOFB();
      log2 = await dao2.getLast7DaysLogs();
    } else {
      InsulinDAO dao = InsulinDAO();
      log = await dao.getAll();
      InsulinLogDAO dao2 = InsulinLogDAO();
      log2 = await dao2.getWeekLogs();
    }

    fastActingInsulin = 0;
    slowActingInsulin = 0;
    firstInjectionSchedule = "";
    secondInjectionSchedule = "";

    if (log.isNotEmpty) {
      for (InsulinModel insulin in log) {
        fastActingInsulin +=
            double.parse(insulin.totalFastActingInsulin.toStringAsFixed(2));
        slowActingInsulin +=
            double.parse(insulin.totalSlowActingInsulin.toStringAsFixed(2));
        firstInjectionSchedule = insulin.firstInjectionSchedule;
        secondInjectionSchedule = insulin.secondInjectionSchedule;
      }
    }

    if (log2.isNotEmpty) {
      for (InsulinLogModel insulinLog in log2) {
        switch (insulinLog.location) {
          case "Brazo izq.":
            locationsCount[0] += 1;
          case "Brazo der.":
            locationsCount[1] += 1;
          case "Gluteo izq.":
            locationsCount[2] += 1;
          case "Gluteo der.":
            locationsCount[3] += 1;
          case "Muslo izq.":
            locationsCount[4] += 1;
          case "Muslo der.":
            locationsCount[5] += 1;
          case "Barriga":
            locationsCount[6] += 1;
          default:
        }
      }
    }

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getData();
    sleep(Duration(milliseconds: 50));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return ScreenMargins(
        child: Column(
      children: [
        InsulinEssentialInfo(
            fastActingInsulin: fastActingInsulin,
            slowActingInsulin: slowActingInsulin),
        SizedBox(
          height: 8,
        ),
        Row(
          children: [
            Expanded(
                child: SlowActingInsulinScheduleInfo(
                    firstInjectionSchedule: firstInjectionSchedule,
                    secondInjectionSchedule: secondInjectionSchedule)),
            SizedBox(
              width: 8,
            ),
            AddPunctualInjection(),
          ],
        ),
        Expanded(
            child: ModelViewer(
          src: 'assets/3dModels/maleBody.glb',
        )),
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Color.fromARGB(255, 255, 255, 255)),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  LegendItem(
                      color: Colors.greenAccent,
                      label: "Brazo izq.: ${locationsCount[0]}"),
                  const SizedBox(width: 8),
                  LegendItem(
                      color: Colors.amberAccent,
                      label: "Brazo der.: ${locationsCount[1]}"),
                  const SizedBox(width: 8),
                  LegendItem(
                      color: Colors.blueAccent,
                      label: "Gluteo izq.: ${locationsCount[2]}"),
                  const SizedBox(width: 8),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  LegendItem(
                      color: Colors.purple,
                      label: "Gluteo der.: ${locationsCount[3]}"),
                  const SizedBox(width: 8),
                  LegendItem(
                      color: Colors.cyanAccent,
                      label: "Muslo izq.: ${locationsCount[4]}"),
                  const SizedBox(width: 8),
                  LegendItem(
                      color: Colors.deepOrangeAccent,
                      label: "Muslo der.: ${locationsCount[5]}"),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  LegendItem(
                      color: Colors.red,
                      label: "Barriga: ${locationsCount[6]}"),
                ],
              ),
            ],
          ),
        )
      ],
    ));
  }
}
