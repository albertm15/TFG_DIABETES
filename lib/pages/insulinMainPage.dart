import 'dart:io';
import 'package:diabetes_tfg_app/database/firebase/authServiceManager.dart';
import 'package:diabetes_tfg_app/database/firebase/insulinDAO.dart';
import 'package:diabetes_tfg_app/database/local/insulinDAO.dart';
import 'package:diabetes_tfg_app/models/insulinModel.dart';
import 'package:diabetes_tfg_app/widgets/addPunctualInjection.dart';
import 'package:diabetes_tfg_app/widgets/backgroundBase.dart';
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
    return Scaffold(
      appBar: UpperNavBar(pageName: "Insulin"),
      body: BackgroundBase(child: Center(child: InsulinMainPageWidget())),
      bottomNavigationBar: LowerNavBar(),
      backgroundColor: Colors.transparent,
    );
  }
}

class InsulinMainPageWidget extends StatefulWidget {
  @override
  _InsulinMainPageWidgetState createState() => _InsulinMainPageWidgetState();
}

class _InsulinMainPageWidgetState extends State<InsulinMainPageWidget> {
  List<InsulinModel> log = [];
  double fastActingInsulin = 0;
  double slowActingInsulin = 0;
  String firstInjectionSchedule = "";
  String secondInjectionSchedule = "";

  void getData() async {
    if (AuthServiceManager.checkIfLogged()) {
      InsulinDAOFB dao = InsulinDAOFB();
      log = await dao.getAll();
    } else {
      InsulinDAO dao = InsulinDAO();
      log = await dao.getAll();
    }

    fastActingInsulin = 0;
    slowActingInsulin = 0;
    firstInjectionSchedule = "";
    secondInjectionSchedule = "";

    if (log.isNotEmpty) {
      for (InsulinModel insulin in log) {
        fastActingInsulin += insulin.totalFastActingInsulin;
        slowActingInsulin += insulin.totalSlowActingInsulin;
        firstInjectionSchedule = insulin.firstInjectionSchedule;
        secondInjectionSchedule = insulin.secondInjectionSchedule;
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
        /*Expanded(
            child: ModelViewer(
          src: 'assets/3dModels/maleBody.glb',
        ))
        */
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                LegendItem(color: Colors.black, label: "Brazo izq.: "),
                const SizedBox(width: 8),
                LegendItem(
                    color: Color.fromARGB(255, 85, 42, 196),
                    label: "Brazo der.: "),
                const SizedBox(width: 8),
                LegendItem(color: Color(0xFF3C37FF), label: "Gluteo izq.: "),
                const SizedBox(width: 8),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                LegendItem(color: Colors.black, label: "Gluteo der.: "),
                const SizedBox(width: 8),
                LegendItem(
                    color: Color.fromARGB(255, 85, 42, 196),
                    label: "Muslo izq.: "),
                const SizedBox(width: 8),
                LegendItem(color: Color(0xFF3C37FF), label: "Muslo der.: "),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                LegendItem(color: Colors.black, label: "Barriga: "),
              ],
            ),
          ],
        )
      ],
    ));
  }
}
