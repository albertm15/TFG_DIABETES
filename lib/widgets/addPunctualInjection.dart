import 'package:diabetes_tfg_app/pages/punctualInjectionFormPage.dart';
import 'package:diabetes_tfg_app/widgets/backgroundBase.dart';
import 'package:diabetes_tfg_app/widgets/drawerScaffold.dart';
import 'package:flutter/material.dart';

class AddPunctualInjection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => DrawerScaffold(
                          child: BackgroundBase(
                        child: PunctualInjectionFormPage(),
                      ))));
        },
        child: Container(
            height: 110,
            width: 120,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(255, 95, 33, 153),
                  Color.fromARGB(255, 85, 42, 196),
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 4,
                ),
                Text(
                  "Añadir inyección",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                  textAlign: TextAlign.center,
                ),
                Expanded(
                    child:
                        Image.asset("assets/images/Insulin_image_white.png")),
                SizedBox(
                  height: 4,
                )
              ],
            )));
  }
}
