import 'package:diabetes_tfg_app/database/firebase/authServiceManager.dart';
import 'package:diabetes_tfg_app/database/firebase/insulinDAO.dart';
import 'package:diabetes_tfg_app/database/local/insulinDAO.dart';
import 'package:diabetes_tfg_app/models/insulinModel.dart';
import 'package:diabetes_tfg_app/widgets/addPunctualInjection.dart';
import 'package:diabetes_tfg_app/widgets/backgroundBase.dart';
import 'package:diabetes_tfg_app/widgets/insulinEssentialInfo.dart';
import 'package:diabetes_tfg_app/widgets/lowerNavBar.dart';
import 'package:diabetes_tfg_app/widgets/screenMargins.dart';
import 'package:diabetes_tfg_app/widgets/slowActingInsulinScheduleInfo.dart';
import 'package:diabetes_tfg_app/widgets/upperNavBar.dart';
import 'package:flutter/material.dart';

class InsulinMainPage extends StatelessWidget {
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
    if (!log.isEmpty) {
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
        )
      ],
    ));
  }
}
