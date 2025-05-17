import 'package:diabetes_tfg_app/pages/allLogsPage.dart';
import 'package:diabetes_tfg_app/pages/calendarPage.dart';
import 'package:diabetes_tfg_app/pages/dietMainPage.dart';
import 'package:diabetes_tfg_app/pages/exerciceAndHealthMainPage.dart';
import 'package:diabetes_tfg_app/pages/glucoseMainPage.dart';
import 'package:diabetes_tfg_app/pages/homePage.dart';
import 'package:diabetes_tfg_app/pages/insulinMainPage.dart';
import 'package:diabetes_tfg_app/widgets/backgroundBase.dart';
import 'package:flutter/material.dart';

class UpperNavBar extends StatelessWidget implements PreferredSizeWidget {
  final String pageName;
  const UpperNavBar({required this.pageName});

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  //actualizar cada vez que se añada una nueva pantalla, añadirla tambien aqui:)
  void goBack(BuildContext context) {
    switch (pageName) {
      case "Glucose" ||
            "Insulin" ||
            "Diet" ||
            "Exercice & Health" ||
            "Todos los registros":
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => BackgroundBase(child: Homepage())));
        break;
      case "Añadir registro de glucosa" || "Graficos":
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    BackgroundBase(child: GlucoseMainPage())));
        break;
      case "Añadir Insulina" || "Añadir Inyección" || "Horario Insulina":
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    BackgroundBase(child: InsulinMainPage())));
        break;

      case "Seleccionar tipo de registro":
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => BackgroundBase(child: AllLogsPage())));
        break;

      case "Horario dieta" || "Conversor de comida":
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => BackgroundBase(child: DietMainPage())));
        break;

      case "Calendar" ||
            "Añadir recordatorio" ||
            "Añadir registro de ejercicio":
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    BackgroundBase(child: ExerciceAndHealthMainPage())));
        break;

      case "Recordatorios del día":
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => BackgroundBase(child: CalendarPage())));
        break;

      case "Añadir carbohidratos":
      default:
        if (Navigator.canPop(context)) {
          Navigator.pop(context, 0);
        }
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
        preferredSize: preferredSize,
        child: Container(
            padding: EdgeInsets.only(bottom: 15),
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
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20)),
            ),
            child: AppBar(
              backgroundColor: Colors.transparent,
              title: Center(
                  child: Text(
                "$pageName",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 35,
                ),
              )),
              leading: Container(),
              /*
              IconButton(
                onPressed: () {
                  print("Botón 'Lateral Menu' presionado");
                },
                icon: Icon(Icons.menu_rounded, color: Colors.white),
                iconSize: 40,
                padding: EdgeInsets.only(left: 30),
              ),
              */
              actions: [
                if (pageName == "Home Page")
                  SizedBox(
                    width: 40,
                  )
                else
                  IconButton(
                    onPressed: () {
                      print("Botón 'Back' presionado");
                      goBack(context);
                    },
                    icon:
                        Icon(Icons.arrow_back_ios_rounded, color: Colors.white),
                    iconSize: 40,
                    padding: EdgeInsets.only(right: 30),
                  )
              ],
            )));
  }
}
