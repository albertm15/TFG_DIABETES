import 'package:diabetes_tfg_app/pages/foodConversorPage.dart';
import 'package:diabetes_tfg_app/widgets/backgroundBase.dart';
import 'package:diabetes_tfg_app/widgets/drawerScaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

class FoodConversorButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => DrawerScaffold(
                        child: BackgroundBase(
                            child: FoodConversorPage(
                      initialId: "",
                    )))));
      },
      child: Container(
        height: 160,
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
                  MaterialCommunityIcons.food_turkey,
                  color: Colors.white,
                  size: 50,
                ),
                Icon(
                  Icons.compare_arrows_rounded,
                  color: Colors.white,
                  size: 50,
                ),
                Image.asset(
                  'assets/images/Insulin_image_white.png', //crear una nueva imagen de forma manual
                  width: 40,
                  height: 40,
                )
              ],
            ),
            SizedBox(height: 4),
            Text("Conversor de alimento a insulina",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                )),
            SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("& Registrar comida",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    )),
                SizedBox(width: 4),
                Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 50,
                ),
                Icon(
                  MaterialCommunityIcons.food_fork_drink,
                  color: Colors.white,
                  size: 50,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
