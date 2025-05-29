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

class _CreateFoodState extends State<CreateFood> with WidgetsBindingObserver {
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
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _isKeyboardVisible = WidgetsBinding.instance.window.viewInsets.bottom > 0.0;
  }

  bool _isKeyboardVisible = false;

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    carbsController.dispose();
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    final bottomInset = WidgetsBinding.instance.window.viewInsets.bottom;
    final newValue = bottomInset > 0.0;

    if (_isKeyboardVisible != newValue) {
      setState(() {
        _isKeyboardVisible = newValue;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return DrawerScaffold(
      child: BackgroundBase(
        child: Scaffold(
          appBar: UpperNavBar(pageName: "Crear alimento"),
          body: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Nombre del alimento",
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Container(
                    width: 160,
                    height: 70,
                    child: TextField(
                      controller: nameController,
                      style: TextStyle(fontSize: 22),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  Text("Carbohidratos cada 100 gramos",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Container(
                    width: 160,
                    height: 70,
                    child: TextField(
                      controller: carbsController,
                      keyboardType: TextInputType.number,
                      style: TextStyle(fontSize: 22),
                      decoration: InputDecoration(
                        suffixText: 'g',
                        suffixStyle: TextStyle(fontSize: 20), // Tamaño del "g"
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                      ),
                    ),
                  ),
                  SizedBox(height: 50),
                  ElevatedButton(
                    onPressed: () {
                      if (nameController.text == "") {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            backgroundColor: Color.fromARGB(255, 232, 80, 69),
                            title: Text(
                              'Nombre vacio',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                            content: Text(
                              "Introduzca un valor en el nombre del alimento a crear.",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 16),
                            ),
                            actions: [
                              TextButton(
                                child: Text(
                                  'OK',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                ),
                                onPressed: () => Navigator.of(context).pop(),
                              ),
                            ],
                          ),
                        );
                      } else if (carbsController.text == "") {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            backgroundColor: Color.fromARGB(255, 232, 80, 69),
                            title: Text(
                              'Valor de carbohidratos vacio',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                            content: Text(
                              "Introduzca un valor en el campo de cantidad de carbohidratos por cada 100 gramos del alimento.",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 16),
                            ),
                            actions: [
                              TextButton(
                                child: Text(
                                  'OK',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                ),
                                onPressed: () => Navigator.of(context).pop(),
                              ),
                            ],
                          ),
                        );
                      } else {
                        setState(() {
                          saveData();
                          Navigator.pop(context);
                        });
                      }
                    },
                    child: Text("Añadir", style: TextStyle(fontSize: 22)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 85, 42, 196),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding:
                          EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    ),
                  ),
                ],
              ),
            ),
          ),
          bottomNavigationBar:
              _isKeyboardVisible ? null : LowerNavBar(selectedSection: "diet"),
          backgroundColor: Colors.transparent,
        ),
      ),
    );
  }
}
