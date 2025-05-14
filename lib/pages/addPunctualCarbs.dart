import 'package:diabetes_tfg_app/widgets/backgroundBase.dart';
import 'package:diabetes_tfg_app/widgets/drawerScaffold.dart';
import 'package:diabetes_tfg_app/widgets/lowerNavBar.dart';
import 'package:diabetes_tfg_app/widgets/upperNavBar.dart';
import 'package:flutter/material.dart';

class AddPunctualCarbs extends StatefulWidget {
  @override
  _AddPunctualCarbsState createState() => _AddPunctualCarbsState();
}

class _AddPunctualCarbsState extends State<AddPunctualCarbs> {
  TextEditingController carbsController = TextEditingController();
  double insulinUnits = 0;

  void updateInsulin(String value) {
    final int carbs = int.tryParse(value) ?? 0;
    setState(() {
      insulinUnits = carbs / 10;
    });
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
          appBar: UpperNavBar(pageName: "Añadir carbohidratos"),
          body: BackgroundBase(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Carbohidratos", style: TextStyle(fontSize: 18)),
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
                      onChanged: updateInsulin,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text("Unidades de insulina", style: TextStyle(fontSize: 18)),
                  SizedBox(height: 8),
                  Container(
                    width: 100,
                    height: 50,
                    decoration: BoxDecoration(
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text('${insulinUnits.toStringAsFixed(1)} u'),
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(
                          context,
                          carbsController.text != ""
                              ? int.parse(carbsController.text)
                              : 0);
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
