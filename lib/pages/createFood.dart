import 'package:diabetes_tfg_app/database/firebase/authServiceManager.dart';
import 'package:diabetes_tfg_app/database/firebase/foodDAO.dart';
import 'package:diabetes_tfg_app/database/local/foodDAO.dart';
import 'package:diabetes_tfg_app/models/foodModel.dart';
import 'package:diabetes_tfg_app/widgets/backgroundBase.dart';
import 'package:diabetes_tfg_app/widgets/drawerScaffold.dart';
import 'package:diabetes_tfg_app/widgets/lowerNavBar.dart';
import 'package:diabetes_tfg_app/widgets/upperNavBar.dart';
import 'package:flutter/material.dart';

class CreateFood extends StatefulWidget {
  @override
  _CreateFoodState createState() => _CreateFoodState();
}

class _CreateFoodState extends State<CreateFood> {
  TextEditingController nameController = TextEditingController();
  TextEditingController carbsController = TextEditingController();

  void saveData() async {
    if (AuthServiceManager.checkIfLogged()) {
      FoodDAOFB dao = FoodDAOFB();
      FoodModel foodToAdd = FoodModel.newEntity(
          AuthServiceManager.getCurrentUserUID(),
          carbsController.text == "" ? 0 : double.parse(carbsController.text),
          nameController.text);
      await dao.insert(foodToAdd);
    } else {
      FoodDAO dao = FoodDAO();
      FoodModel foodToAdd = FoodModel.newEntity(
          "localUser",
          carbsController.text == "" ? 0 : double.parse(carbsController.text),
          nameController.text);
      await dao.insert(foodToAdd);
    }
  }

  @override
  void dispose() {
    carbsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DrawerScaffold(
      child: BackgroundBase(
        child: Scaffold(
          appBar: UpperNavBar(pageName: "Crear aliemnto"),
          body: BackgroundBase(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Nombre del alimento", style: TextStyle(fontSize: 18)),
                  SizedBox(height: 8),
                  Container(
                    width: 100,
                    height: 50,
                    child: TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                        hintText: '',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        contentPadding: EdgeInsets.symmetric(horizontal: 12),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text("Carbohidratos cada 100 gramos",
                      style: TextStyle(fontSize: 18)),
                  SizedBox(height: 8),
                  Container(
                    width: 100,
                    height: 50,
                    child: TextField(
                      controller: carbsController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: 'g',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        contentPadding: EdgeInsets.symmetric(horizontal: 12),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        saveData();
                        Navigator.pop(context);
                      });
                    },
                    child: Text("Añadir"),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      padding:
                          EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                  ),
                ],
              ),
            ),
          ),
          bottomNavigationBar: LowerNavBar(),
          backgroundColor: Colors.transparent,
        ),
      ),
    );
  }
}
