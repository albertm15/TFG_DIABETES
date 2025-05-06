import 'package:diabetes_tfg_app/pages/modifyInsulinSchedule.dart';
import 'package:diabetes_tfg_app/widgets/backgroundBase.dart';
import 'package:diabetes_tfg_app/widgets/drawerScaffold.dart';
import 'package:flutter/material.dart';

class SlowActingInsulinScheduleInfo extends StatelessWidget {
  final String firstInjectionSchedule;
  final String secondInjectionSchedule;
  const SlowActingInsulinScheduleInfo(
      {required this.firstInjectionSchedule,
      required this.secondInjectionSchedule});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => DrawerScaffold(
                          child: BackgroundBase(
                        child: ModifyInsulinSchedule(
                            firstInjectionSchedule: firstInjectionSchedule,
                            secondInjectionSchedule: secondInjectionSchedule),
                      ))));
        },
        child: Container(
          height: 110,
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
              Text(
                "Horario insulina lenta",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "$firstInjectionSchedule",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                          ),
                        ),
                        /*
                    Text(
                      "1a Inyección",
                      style: TextStyle(
                        color: const Color.fromARGB(255, 255, 255, 255),
                        fontSize: 14,
                      ),
                    ),
                    */
                      ],
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_rounded,
                    color: const Color.fromARGB(255, 255, 255, 255),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "$secondInjectionSchedule",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                          ),
                        ),
                        /*
                    Text(
                      "2a Inyección",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                    */
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
        ));
  }
}
