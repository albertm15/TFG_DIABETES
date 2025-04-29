import 'package:flutter/material.dart';

class GlucoseEssentialInfoAmplified extends StatelessWidget {
  final double avgGlucose;
  final int minGlucose;
  final int maxGlucose;
  final int hypoglucemies;
  final int hyperglucemies;
  const GlucoseEssentialInfoAmplified(
      {required this.hypoglucemies,
      required this.avgGlucose,
      required this.hyperglucemies,
      required this.minGlucose,
      required this.maxGlucose});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 160,
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
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Resumen glucémico semanal',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Row(
                children: [
                  // LADO IZQUIERDO
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("Mínima: $minGlucose mg/dL",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            )),
                        Text("Media: ${avgGlucose.floor()} mg/dL",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            )),
                        Text("Máxima: $maxGlucose mg/dL",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            )),
                      ],
                    ),
                  ),
                  Container(
                    width: 1,
                    height: double.infinity,
                    color: Colors.white24,
                  ),
                  // LADO DERECHO
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("Hipoglucemias: $hypoglucemies",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            )),
                        const SizedBox(height: 16),
                        Text("Hiperglucemias: $hyperglucemies",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            )),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
