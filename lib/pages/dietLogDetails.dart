import 'package:diabetes_tfg_app/auxiliarResources/selectedFoods.dart';
import 'package:diabetes_tfg_app/database/firebase/authServiceManager.dart';
import 'package:diabetes_tfg_app/database/firebase/dietLogDAO.dart';
import 'package:diabetes_tfg_app/database/firebase/dietLogFoodRelationDAO.dart';
import 'package:diabetes_tfg_app/database/firebase/foodDAO.dart';
import 'package:diabetes_tfg_app/database/local/dietLogDAO.dart';
import 'package:diabetes_tfg_app/database/local/dietLogFoodRelationDAO.dart';
import 'package:diabetes_tfg_app/database/local/foodDAO.dart';
import 'package:diabetes_tfg_app/models/dietLogFoodRelationModel.dart';
import 'package:diabetes_tfg_app/models/dietLogModel.dart';
import 'package:diabetes_tfg_app/models/foodModel.dart';
import 'package:diabetes_tfg_app/widgets/backgroundBase.dart';
import 'package:diabetes_tfg_app/widgets/drawerScaffold.dart';
import 'package:diabetes_tfg_app/widgets/lowerNavBar.dart';
import 'package:diabetes_tfg_app/widgets/screenMargins.dart';
import 'package:diabetes_tfg_app/widgets/upperNavBar.dart';
import 'package:flutter/material.dart';

class DietLogDetails extends StatelessWidget {
  final String id;
  const DietLogDetails({required this.id});
  @override
  Widget build(BuildContext context) {
    return DrawerScaffold(
        child: BackgroundBase(
            child: Scaffold(
      appBar: UpperNavBar(pageName: "Detalles de glucosa"),
      body: BackgroundBase(
          child: Center(child: _DietLogDetailsWidget(id: this.id))),
      bottomNavigationBar: LowerNavBar(),
      backgroundColor: Colors.transparent,
    )));
  }
}

class _DietLogDetailsWidget extends StatefulWidget {
  final String id;
  const _DietLogDetailsWidget({required this.id});

  @override
  _DietLogDetailsWidgetState createState() => _DietLogDetailsWidgetState();
}

class _DietLogDetailsWidgetState extends State<_DietLogDetailsWidget> {
  List<Selectedfood> selectedFoods = [];
  bool expanded = true;
  double totalUnits = 0;
  int totalCarbs = 0;
  String date = "";
  String time = "";
  List<DietLogModel> log = [];
  List<DietLogFoodRelationModel> rel = [];

  Future<void> loadSelectedFoods() async {
    if (AuthServiceManager.checkIfLogged()) {
      DietLogDAOFB dao = DietLogDAOFB();
      log = await dao.getById(widget.id);

      DietLogFoodRelationDAOFB dao2 = DietLogFoodRelationDAOFB();
      FoodDAOFB dao3 = FoodDAOFB();
      rel = await dao2.getAll();
      rel = rel.where((relation) => relation.dietLogId == widget.id).toList();
      List<FoodModel> foodList = [];
      for (DietLogFoodRelationModel relation in rel) {
        String id = relation.foodId;
        foodList = await dao3.getById(id);
        print(id);
        if (foodList.isNotEmpty) {
          selectedFoods.add(Selectedfood(
              quantity: relation.grams.toInt(), food: foodList[0]));
          print(foodList[0]);
        }
      }
    } else {
      DietLogDAO dao = DietLogDAO();
      log = await dao.getById(widget.id);

      DietLogFoodRelationDAO dao2 = DietLogFoodRelationDAO();
      FoodDAO dao3 = FoodDAO();
      rel = await dao2.getAll();
      rel =
          rel.where((relation) => relation.dietLogId == log.first.id).toList();
      for (DietLogFoodRelationModel relation in rel) {
        List<FoodModel> foodList = await dao3.getById(relation.foodId);
        if (foodList.isNotEmpty) {
          selectedFoods.add(Selectedfood(
              quantity: relation.grams.toInt(), food: foodList[0]));
        }
      }
    }
    setState(() {});
  }

  void loadData() async {
    await loadSelectedFoods();
    setState(() {
      totalUnits = log.first.totalInsulinUnits;
      totalCarbs = log.first.totalCarbs;
      date = log.first.date;
      time = log.first.time;
    });
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenMargins(
        child: SingleChildScrollView(
      child: Center(
        child: Column(
          children: [
            Text(
              "Carbohidratos a ingerir:",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
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
                "${totalCarbs.toStringAsFixed(1)} g.",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Text(
              "Equivalente a:",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
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
                "${totalUnits.toStringAsFixed(1)} U.",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 10),
            Text(
              "Fecha: $date",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            Text(
              "Hora: $time",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
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
                            color: const Color.fromARGB(255, 255, 255, 255),
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          )),
                    ],
                  ),
                  children: selectedFoods.map((food) {
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
          ],
        ),
      ),
    ));
  }
}
