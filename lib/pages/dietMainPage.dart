import 'dart:io';

import 'package:diabetes_tfg_app/database/firebase/authServiceManager.dart';
import 'package:diabetes_tfg_app/database/firebase/dietDAO.dart';
import 'package:diabetes_tfg_app/database/local/dietDAO.dart';
import 'package:diabetes_tfg_app/models/dietModel.dart';
import 'package:diabetes_tfg_app/widgets/backgroundBase.dart';
import 'package:diabetes_tfg_app/widgets/dietScheduleBox.dart';
import 'package:diabetes_tfg_app/widgets/drawerScaffold.dart';
import 'package:diabetes_tfg_app/widgets/foodConversorButton.dart';
import 'package:diabetes_tfg_app/widgets/lowerNavBar.dart';
import 'package:diabetes_tfg_app/widgets/screenMargins.dart';
import 'package:diabetes_tfg_app/widgets/upperNavBar.dart';
import 'package:flutter/material.dart';

class DietMainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DrawerScaffold(
        child: BackgroundBase(
            child: Scaffold(
      appBar: UpperNavBar(pageName: "Diet"),
      body: BackgroundBase(child: Center(child: DietMainPageWidget())),
      bottomNavigationBar: LowerNavBar(),
      backgroundColor: Colors.transparent,
    )));
  }
}

class DietMainPageWidget extends StatefulWidget {
  @override
  _DietMainPageWidgetState createState() => _DietMainPageWidgetState();
}

class _DietMainPageWidgetState extends State<DietMainPageWidget> {
  List<DietModel> log = [];
  String breakfastSchedule = "";
  String snackSchedule = "";
  String lunchSchedule = "";
  String afternoonSnackSchedule = "";
  String dinnerSchedule = "";

  void getData() async {
    if (AuthServiceManager.checkIfLogged()) {
      DietDAOFB dao = DietDAOFB();
      log = await dao.getAll();

      if (log.isEmpty) {
        await dao.insert(DietModel.newEntity(
            AuthServiceManager.getCurrentUserUID(),
            "00:00",
            "00:00",
            "00:00",
            "00:00",
            "00:00"));
        log = await dao.getAll();
      }
    } else {
      DietDAO dao = DietDAO();
      log = await dao.getAll();

      if (log.isEmpty) {
        await dao.insert(DietModel.newEntity(
            "localUser", "00:00", "00:00", "00:00", "00:00", "00:00"));
        log = await dao.getAll();
      }
    }

    if (log.isNotEmpty) {
      for (DietModel diet in log) {
        breakfastSchedule = diet.breakfastSchedule;
        snackSchedule = diet.snackSchedule;
        lunchSchedule = diet.lunchSchedule;
        afternoonSnackSchedule = diet.afternoonSnackSchedule;
        dinnerSchedule = diet.dinnerSchedule;
      }
    }

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getData();
    sleep(Duration(milliseconds: 100));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return ScreenMargins(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: 160,
          child: Row(
            children: [
              Expanded(
                  child: DietScheduleBox(
                      bigSizedBox: true,
                      meal: "Desayuno",
                      time: "$breakfastSchedule")),
              SizedBox(
                width: 8,
              ),
              Expanded(
                  child: DietScheduleBox(
                      bigSizedBox: true,
                      meal: "Tente en pié",
                      time: "$snackSchedule")),
            ],
          ),
        ),
        SizedBox(height: 8),
        Container(
          height: 120,
          child: Row(
            children: [
              Expanded(
                  child: DietScheduleBox(
                      bigSizedBox: false,
                      meal: "Comida",
                      time: "$lunchSchedule")),
              SizedBox(
                width: 8,
              ),
              Expanded(
                  child: DietScheduleBox(
                      bigSizedBox: false,
                      meal: "Merienda",
                      time: "$afternoonSnackSchedule")),
              SizedBox(
                width: 8,
              ),
              Expanded(
                  child: DietScheduleBox(
                      bigSizedBox: false,
                      meal: "Cena",
                      time: "$dinnerSchedule")),
            ],
          ),
        ),
        SizedBox(height: 20),
        Container(
            height: 160,
            child: Row(
              children: [
                Expanded(
                  child: FoodConversorButton(),
                ),
              ],
            ))
      ],
    ));
  }
}
