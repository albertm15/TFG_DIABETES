import 'package:diabetes_tfg_app/widgets/backgroundBase.dart';
import 'package:diabetes_tfg_app/widgets/drawerScaffold.dart';
import 'package:diabetes_tfg_app/widgets/lowerNavBar.dart';
import 'package:diabetes_tfg_app/widgets/upperNavBar.dart';
import 'package:flutter/material.dart';

class AddPunctualCarbs extends StatefulWidget {
  @override
  _AddPunctualCarbsState createState() => _AddPunctualCarbsState();
}

class _AddPunctualCarbsState extends State<AddPunctualCarbs>
    with WidgetsBindingObserver {
  TextEditingController carbsController = TextEditingController();
  double insulinUnits = 0;

  void updateInsulin(String value) {
    final int carbs = int.tryParse(value) ?? 0;
    setState(() {
      insulinUnits = carbs / 10;
    });
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
          appBar: UpperNavBar(pageName: "Añadir carbohidratos"),
          body: GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Text("Carbohidratos",
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold)),
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
                          suffixStyle:
                              TextStyle(fontSize: 20), // Tamaño del "g"
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 16, vertical: 18),
                        ),
                        onChanged: updateInsulin,
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.arrow_downward_rounded,
                          size: 40,
                        ),
                        Icon(
                          Icons.arrow_upward_rounded,
                          size: 40,
                        )
                      ],
                    ),
                    SizedBox(height: 20),
                    Text("Unidades de insulina",
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold)),
                    SizedBox(height: 8),
                    Container(
                      width: 160,
                      height: 70,
                      decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          '${insulinUnits.toStringAsFixed(1)} u',
                          style: TextStyle(fontSize: 22),
                        ),
                      ),
                    ),
                    SizedBox(height: 50),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(
                            context,
                            carbsController.text != ""
                                ? int.parse(carbsController.text)
                                : 0);
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
              )),
          bottomNavigationBar:
              _isKeyboardVisible ? null : LowerNavBar(selectedSection: "diet"),
          backgroundColor: Colors.transparent,
        ),
      ),
    );
  }
}
