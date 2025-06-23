import 'package:diabetes_tfg_app/pages/allLogsPage.dart';
import 'package:diabetes_tfg_app/pages/calendarPage.dart';
import 'package:diabetes_tfg_app/pages/dietMainPage.dart';
import 'package:diabetes_tfg_app/pages/exerciceAndHealthMainPage.dart';
import 'package:diabetes_tfg_app/pages/glucoseMainPage.dart';
import 'package:diabetes_tfg_app/pages/homePage.dart';
import 'package:diabetes_tfg_app/pages/insulinMainPage.dart';
import 'package:diabetes_tfg_app/pages/selectAddOrSubInsulin.dart';
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
      case "Glucosa" ||
            "Insulina" ||
            "Dieta" ||
            "Ejercicio y Salud" ||
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
      case "Añadir Inyección" || "Horario Insulina" || "Seleccionar operación":
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    BackgroundBase(child: InsulinMainPage())));
        break;

      case "Añadir Insulina" || "Restar Insulina":
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    BackgroundBase(child: SelectAddOrSubInsulin())));
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

      case "Calendario" ||
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

  double getSize() {
    switch (pageName) {
      case "Conversor de comida" ||
            "Recordatorios del día" ||
            "Añadir carbohidratos" ||
            "Añadir recordatorio" ||
            "Detalles de ejercicio" ||
            "Detalles de glucosa" ||
            "Detalles de insulina" ||
            "Detalles de comida":
        return 22;
      case "Seleccionar operación":
        return 21;
      case "Añadir registro de glucosa" ||
            "Añadir registro de comida" ||
            "Detalles de recordatorio":
        return 18;
      case "Seleccionar tipo de registro" || "Añadir registro de ejercicio":
        return 17;
      case "Añadir Insulina" ||
            "Restar Insulina" ||
            "Añadir Inyección" ||
            "Horario Insulina" ||
            "Ejercicio y Salud" ||
            "Generar reporte" ||
            "Configuración" ||
            "Crear alimento":
        return 26;
      case "Todos los registros":
        return 24;
      default:
        return 35;
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
                  fontSize: getSize(),
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
                if (pageName == "Home Page" || pageName == "Glucsafe")
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
