import 'package:diabetes_tfg_app/pages/modifyDietSchedule.dart';
import 'package:diabetes_tfg_app/widgets/backgroundBase.dart';
import 'package:diabetes_tfg_app/widgets/drawerScaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

class DietScheduleBox extends StatelessWidget {
  final bool bigSizedBox;
  final String meal;
  final String time;

  const DietScheduleBox(
      {required this.bigSizedBox, required this.meal, required this.time});

  IconData getIcon() {
    switch (meal) {
      case "Desayuno":
        return Icons.free_breakfast;
      case "Tente en pié":
        return MaterialCommunityIcons.food_apple;
      case "Comida":
        return MaterialCommunityIcons.food_turkey;
      case "Merienda":
        return MaterialCommunityIcons.food_croissant;
      default:
        return MaterialCommunityIcons.food_drumstick;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => DrawerScaffold(
                    child: BackgroundBase(child: ModifyDietSchedule()))));
      },
      child: Container(
          height: bigSizedBox ? 160 : 120,
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
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    getIcon(),
                    color: Colors.white,
                    size: bigSizedBox ? 50 : 30,
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 2, right: 2),
                    child: Text("$time",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: bigSizedBox ? 28 : 20,
                        )),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ],
              ),
              Text("$meal",
                  style: TextStyle(
                    color: const Color.fromARGB(255, 255, 255, 255),
                    fontWeight: FontWeight.bold,
                    fontSize: bigSizedBox ? 25 : 20,
                  ))
            ],
          )),
    );
  }
}
