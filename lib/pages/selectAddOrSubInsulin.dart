import 'package:diabetes_tfg_app/pages/addOrSubInsulinForm.dart';
import 'package:diabetes_tfg_app/widgets/drawerScaffold.dart';
import 'package:diabetes_tfg_app/widgets/lowerNavBar.dart';
import 'package:diabetes_tfg_app/widgets/screenMargins.dart';
import 'package:diabetes_tfg_app/widgets/upperNavBar.dart';
import 'package:flutter/material.dart';
import '../widgets/backgroundBase.dart';

class SelectAddOrSubInsulin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DrawerScaffold(
        child: BackgroundBase(
            child: Scaffold(
      appBar: UpperNavBar(pageName: "Seleccionar operación"),
      body: BackgroundBase(child: Center(child: SelectAddOrSubInsulinWidget())),
      bottomNavigationBar: LowerNavBar(selectedSection: "home"),
      backgroundColor: Colors.transparent,
    )));
  }
}

class SelectAddOrSubInsulinWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenMargins(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 250,
              height: 160,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DrawerScaffold(
                                  child: BackgroundBase(
                                      child: AddInsulinFormPage(
                                isAdd: true,
                              )))));
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.add,
                          size: 50,
                          color: Colors.white,
                        ),
                        Text(
                          "U.",
                          style: TextStyle(fontSize: 50, color: Colors.white),
                        ),
                        Image.asset(
                          'assets/images/Insulin_image_white.png',
                          scale: 5,
                        ),
                      ],
                    ),
                    Text(
                      "Añadir insulina",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 25, color: Colors.white),
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
              height: 20,
            ),
            SizedBox(
              width: 250,
              height: 160,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DrawerScaffold(
                                  child: BackgroundBase(
                                      child: AddInsulinFormPage(
                                isAdd: false,
                              )))));
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.minimize_rounded,
                          size: 50,
                          color: Colors.white,
                        ),
                        Text(
                          "U.",
                          style: TextStyle(fontSize: 50, color: Colors.white),
                        ),
                        Image.asset(
                          'assets/images/Insulin_image_white.png',
                          scale: 5,
                        ),
                      ],
                    ),
                    Text(
                      "Restar insulina",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 25, color: Colors.white),
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
