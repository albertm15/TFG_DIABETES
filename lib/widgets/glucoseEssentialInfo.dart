import 'package:flutter/material.dart';

class GlucoseEssentialInfo extends StatelessWidget {
  final double avgGlucose;
  final int hypoglucemies;
  final int hyperglucemies;
  const GlucoseEssentialInfo(
      {required this.hypoglucemies,
      required this.avgGlucose,
      required this.hyperglucemies});

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 110,
        decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 95, 33, 153),
                Color.fromARGB(255, 85, 42, 196),
              ],
              stops: [0, 1.0],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            color: Color(0xFF5F38D3),
            borderRadius: BorderRadius.all(Radius.circular(20))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text("$hypoglucemies",
                    style: TextStyle(
                      color: const Color.fromARGB(255, 255, 255, 255),
                      fontWeight: FontWeight.bold,
                      fontSize: 35,
                    )),
                Text("|",
                    style: TextStyle(
                      color: const Color.fromARGB(255, 255, 255, 255),
                      fontWeight: FontWeight.bold,
                      fontSize: 35,
                    )),
                Text("${avgGlucose.floor()}",
                    style: TextStyle(
                      color: const Color.fromARGB(255, 255, 255, 255),
                      fontWeight: FontWeight.bold,
                      fontSize: 35,
                    )),
                Text("|",
                    style: TextStyle(
                      color: const Color.fromARGB(255, 255, 255, 255),
                      fontWeight: FontWeight.bold,
                      fontSize: 35,
                    )),
                Text("$hyperglucemies",
                    style: TextStyle(
                      color: const Color.fromARGB(255, 255, 255, 255),
                      fontWeight: FontWeight.bold,
                      fontSize: 35,
                    )),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text("Hipoglucemias",
                    style: TextStyle(
                      color: const Color.fromARGB(255, 255, 255, 255),
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    )),
                Text("Glucosa media",
                    style: TextStyle(
                      color: const Color.fromARGB(255, 255, 255, 255),
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    )),
                Text("Hiperglucemias",
                    style: TextStyle(
                      color: const Color.fromARGB(255, 255, 255, 255),
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    )),
              ],
            ),
          ],
        ));
  }
}
