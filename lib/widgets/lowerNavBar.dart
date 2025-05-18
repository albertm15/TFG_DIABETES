import 'package:diabetes_tfg_app/pages/DietMainPage.dart';
import 'package:diabetes_tfg_app/pages/ExerciceAndHealthMainPage.dart';
import 'package:diabetes_tfg_app/pages/glucoseMainPage.dart';
import 'package:diabetes_tfg_app/pages/homePage.dart';
import 'package:diabetes_tfg_app/pages/insulinMainPage.dart';
import 'package:diabetes_tfg_app/widgets/backgroundBase.dart';
import 'package:diabetes_tfg_app/widgets/drawerScaffold.dart';
import 'package:flutter/material.dart';

class LowerNavBar extends StatefulWidget {
  final selectedSection;
  const LowerNavBar({required this.selectedSection});
  @override
  _LowerNavBarState createState() => _LowerNavBarState();
}

class _LowerNavBarState extends State<LowerNavBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
        height: 110,
        decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF3C37FF),
                Color(0xFF242199),
              ],
              stops: [0.4, 1.0],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              onPressed: () {
                print("Botón 'Glucose' presionado");
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => DrawerScaffold(
                            child: BackgroundBase(child: GlucoseMainPage()))));
              },
              icon: Icon(Icons.water_drop_outlined,
                  color: widget.selectedSection == "glucose"
                      ? Colors.white
                      : const Color.fromARGB(255, 148, 147, 147)),
              iconSize: 40,
            ),
            IconButton(
                onPressed: () {
                  print("Botón 'Insulin' presionado");
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DrawerScaffold(
                                  child: BackgroundBase(
                                child: InsulinMainPage(),
                              ))));
                },
                icon: Image.asset(
                  'assets/images/Insulin_image_white.png',
                  width: 40,
                  height: 40,
                  color: widget.selectedSection == "insulin"
                      ? Colors.white
                      : const Color.fromARGB(255, 148, 147, 147),
                )),
            IconButton(
              onPressed: () {
                print("Botón 'Home' presionado");
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => DrawerScaffold(
                            child: BackgroundBase(child: Homepage()))));
              },
              icon: Icon(Icons.home_outlined,
                  color: widget.selectedSection == "home"
                      ? Colors.white
                      : const Color.fromARGB(255, 148, 147, 147)),
              iconSize: 40,
            ),
            IconButton(
              onPressed: () {
                print("Botón 'Diet' presionado");
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => DrawerScaffold(
                            child: BackgroundBase(child: DietMainPage()))));
              },
              icon: Icon(Icons.fastfood_outlined,
                  color: widget.selectedSection == "diet"
                      ? Colors.white
                      : const Color.fromARGB(255, 148, 147, 147)),
              iconSize: 40,
            ),
            IconButton(
              onPressed: () {
                print("Botón 'Exercice & Health' presionado");
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => DrawerScaffold(
                            child: BackgroundBase(
                                child: ExerciceAndHealthMainPage()))));
                //child: DbTestingPage()))));
              },
              //icon: Icon(Icons.directions_run_rounded, color: Colors.white),
              icon: Icon(Icons.favorite_border_rounded,
                  color: widget.selectedSection == "exercice"
                      ? Colors.white
                      : const Color.fromARGB(255, 148, 147, 147)),
              iconSize: 40,
            ),
          ],
        ));
  }
}
