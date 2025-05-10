import 'package:diabetes_tfg_app/pages/glucoseFormPage.dart';
import 'package:diabetes_tfg_app/pages/punctualInjectionFormPage.dart';
import 'package:diabetes_tfg_app/widgets/drawerScaffold.dart';
import 'package:diabetes_tfg_app/widgets/lowerNavBar.dart';
import 'package:diabetes_tfg_app/widgets/screenMargins.dart';
import 'package:diabetes_tfg_app/widgets/upperNavBar.dart';
import 'package:flutter/material.dart';
import '../widgets/backgroundBase.dart';

class SelectLogTypeToRegister extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DrawerScaffold(
        child: BackgroundBase(
            child: Scaffold(
      appBar: UpperNavBar(pageName: "Seleccionar tipo de registro"),
      body:
          BackgroundBase(child: Center(child: SelectLogTypeToRegisterWidget())),
      bottomNavigationBar: LowerNavBar(),
      backgroundColor: Colors.transparent,
    )));
  }
}

class SelectLogTypeToRegisterWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenMargins(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 160,
              height: 160,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              BackgroundBase(child: GlucoseFormPage())));
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.water_drop_outlined,
                      color: Colors.white,
                      size: 70,
                    ),
                    Text(
                      "Añadir registro de glucosa",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 15, color: Colors.white),
                    )
                  ],
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 85, 42, 196),
                  alignment: Alignment.center,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 8,
            ),
            SizedBox(
              width: 160,
              height: 160,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => BackgroundBase(
                              child: PunctualInjectionFormPage())));
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/Insulin_image_white.png',
                      scale: 5,
                    ),
                    Text(
                      "Añadir registro de insulina",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 15, color: Colors.white),
                    )
                  ],
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 85, 42, 196),
                  alignment: Alignment.center,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 8,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 160,
              height: 160,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              BackgroundBase(child: GlucoseFormPage())));
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.fastfood_outlined,
                      color: Colors.white,
                      size: 70,
                    ),
                    Text(
                      "Añadir registro comida",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 15, color: Colors.white),
                    )
                  ],
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 85, 42, 196),
                  alignment: Alignment.center,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 8,
            ),
            SizedBox(
              width: 160,
              height: 160,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              BackgroundBase(child: GlucoseFormPage())));
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.directions_run_rounded,
                      color: Colors.white,
                      size: 70,
                    ),
                    Text(
                      "Añadir registro de ejercicio",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 15, color: Colors.white),
                    )
                  ],
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 85, 42, 196),
                  alignment: Alignment.center,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    ));
  }
}
