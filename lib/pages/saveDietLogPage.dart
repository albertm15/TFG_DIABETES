import 'package:diabetes_tfg_app/auxiliarResources/selectedFoods.dart';
import 'package:diabetes_tfg_app/database/firebase/authServiceManager.dart';
import 'package:diabetes_tfg_app/database/firebase/dietLogDAO.dart';
import 'package:diabetes_tfg_app/database/firebase/dietLogFoodRelationDAO.dart';
import 'package:diabetes_tfg_app/database/local/dietLogDAO.dart';
import 'package:diabetes_tfg_app/database/local/dietLogFoodRelationDAO.dart';
import 'package:diabetes_tfg_app/models/dietLogFoodRelationModel.dart';
import 'package:diabetes_tfg_app/models/dietLogModel.dart';
import 'package:diabetes_tfg_app/pages/punctualInjectionFormPage.dart';
import 'package:diabetes_tfg_app/widgets/backgroundBase.dart';
import 'package:diabetes_tfg_app/widgets/drawerScaffold.dart';
import 'package:diabetes_tfg_app/widgets/lowerNavBar.dart';
import 'package:diabetes_tfg_app/widgets/screenMargins.dart';
import 'package:diabetes_tfg_app/widgets/upperNavBar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SaveDietLogPage extends StatefulWidget {
  final double totalCarbs;
  final double totalUnits;
  final List<Selectedfood> selectedFoods;

  const SaveDietLogPage(
      {required this.totalCarbs,
      required this.totalUnits,
      required this.selectedFoods});

  @override
  _SaveDietLogPageState createState() => _SaveDietLogPageState();
}

class _SaveDietLogPageState extends State<SaveDietLogPage> {
  bool expanded = true;

  void saveData() async {
    if (AuthServiceManager.checkIfLogged()) {
      DietLogDAOFB dao = DietLogDAOFB();
      DietLogModel dietLog = DietLogModel.newEntity(
        AuthServiceManager.getCurrentUserUID(),
        widget.totalUnits,
        (widget.totalUnits * 10).toInt(),
        "${DateTime.now().hour.toString().padLeft(2, "0")}:${DateTime.now().minute.toString().padLeft(2, "0")}:${DateTime.now().second.toString().padLeft(2, "0")}",
        DateFormat("yyyy-MM-dd").format(DateTime.now()),
      );
      await dao.insert(dietLog);

      DietLogFoodRelationDAOFB dao2 = DietLogFoodRelationDAOFB();
      for (Selectedfood selFood in widget.selectedFoods) {
        await dao2.insert(DietLogFoodRelationModel.newEntity(
            AuthServiceManager.getCurrentUserUID(),
            dietLog.id,
            selFood.food.id,
            selFood.quantity.toDouble()));
      }
    } else {
      DietLogDAO dao = DietLogDAO();
      DietLogModel dietLog = DietLogModel.newEntity(
        "localUser",
        widget.totalUnits,
        (widget.totalUnits * 10).toInt(),
        "${DateTime.now().hour.toString().padLeft(2, "0")}:${DateTime.now().minute.toString().padLeft(2, "0")}:${DateTime.now().second.toString().padLeft(2, "0")}",
        DateFormat("yyyy-MM-dd").format(DateTime.now()),
      );
      await dao.insert(dietLog);

      DietLogFoodRelationDAO dao2 = DietLogFoodRelationDAO();
      for (Selectedfood selFood in widget.selectedFoods) {
        await dao2.insert(DietLogFoodRelationModel.newEntity(
            AuthServiceManager.getCurrentUserUID(),
            dietLog.id,
            selFood.food.id,
            selFood.quantity.toDouble()));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return DrawerScaffold(
      child: BackgroundBase(
        child: Scaffold(
          appBar: UpperNavBar(pageName: "Añadir carbohidratos"),
          body: BackgroundBase(
            child: ScreenMargins(
              child: Center(
                child: Column(
                  children: [
                    Text(
                      "Carbohidratos a ingerir:",
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      margin: EdgeInsets.symmetric(vertical: 10),
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
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        "${widget.totalCarbs.toStringAsFixed(1)} g.",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Text(
                      "Equivalente a:",
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      margin: EdgeInsets.symmetric(vertical: 10),
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
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        "${widget.totalUnits.toStringAsFixed(1)} U.",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(height: 20),
                    Container(
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
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Theme(
                        data: Theme.of(context).copyWith(
                          dividerColor: Colors.transparent,
                        ),
                        child: ExpansionTile(
                          initiallyExpanded: expanded,
                          iconColor: Colors.white,
                          collapsedIconColor: Colors.white,
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Alimentos seleccionados",
                                  style: TextStyle(
                                    color: const Color.fromARGB(
                                        255, 255, 255, 255),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  )),
                            ],
                          ),
                          children: widget.selectedFoods.map((food) {
                            return ListTile(
                                title: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  '${food.food.name}: ${food.quantity}g, ${(food.quantity * (food.food.carbsPer100 / 100)) / 10}U.',
                                  style: TextStyle(color: Colors.white),
                                )
                              ],
                            ));
                          }).toList(),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          saveData();
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => DrawerScaffold(
                                      //child: BackgroundBase(child: DietMainPage()))));
                                      child: BackgroundBase(
                                          child: PunctualInjectionFormPage
                                              .withInitialUnits(
                                                  widget.totalUnits)))));
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 85, 42, 196),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding:
                            EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                      ),
                      child: Text("Confirmar y registrar insulina",
                          style: TextStyle(fontSize: 18)),
                    ),
                  ],
                ),
              ),
            ),
          ),
          bottomNavigationBar: LowerNavBar(selectedSection: "diet"),
          backgroundColor: Colors.transparent,
        ),
      ),
    );
  }
}
