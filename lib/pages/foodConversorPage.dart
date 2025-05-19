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
import 'package:diabetes_tfg_app/pages/DietMainPage.dart';
import 'package:diabetes_tfg_app/pages/addPunctualCarbs.dart';
import 'package:diabetes_tfg_app/pages/createFood.dart';
import 'package:diabetes_tfg_app/pages/saveDietLogPage.dart';
import 'package:diabetes_tfg_app/widgets/backgroundBase.dart';
import 'package:diabetes_tfg_app/widgets/drawerScaffold.dart';
import 'package:diabetes_tfg_app/widgets/lowerNavBar.dart';
import 'package:diabetes_tfg_app/widgets/screenMargins.dart';
import 'package:diabetes_tfg_app/widgets/upperNavBar.dart';
import 'package:flutter/material.dart';

class FoodConversorPage extends StatefulWidget {
  final String initialId;
  const FoodConversorPage({required this.initialId});
  @override
  _FoodConversorPageState createState() => _FoodConversorPageState();
}

class _FoodConversorPageState extends State<FoodConversorPage> {
  @override
  Widget build(BuildContext context) {
    return DrawerScaffold(
        child: BackgroundBase(
            child: Scaffold(
      appBar: UpperNavBar(pageName: "Conversor de comida"),
      body: BackgroundBase(
          child: Center(
              child:
                  _FoodConversorPageStateWidget(initialId: widget.initialId))),
      bottomNavigationBar: LowerNavBar(selectedSection: "food"),
      backgroundColor: Colors.transparent,
    )));
  }
}

class _FoodConversorPageStateWidget extends StatefulWidget {
  final String initialId;
  const _FoodConversorPageStateWidget({required this.initialId});
  @override
  _FoodConversorPageStateWidgetState createState() =>
      _FoodConversorPageStateWidgetState();
}

class _FoodConversorPageStateWidgetState
    extends State<_FoodConversorPageStateWidget> {
  double unidadesTotales = 0;
  bool expanded = true;
  List<Selectedfood> selectedFoods = [];
  List<FoodModel> foodList = [];
  List<FoodModel> filteredSearchFood = [];
  TextEditingController searchController = TextEditingController();
  Map<String, TextEditingController> controllers = {};
  int punctualCarbs = 0;

  void getData() async {
    if (AuthServiceManager.checkIfLogged()) {
      FoodDAOFB dao = FoodDAOFB();
      foodList = await dao.getAll();

      if (widget.initialId != "") {
        DietLogDAOFB dao2 = DietLogDAOFB();
        List<DietLogModel> log = await dao2.getById(widget.initialId);
        unidadesTotales = log.first.totalInsulinUnits;
        await loadSelectedFoods();
        loadControllers();
      }
    } else {
      FoodDAO dao = FoodDAO();
      foodList = await dao.getAll();

      if (widget.initialId != "") {
        DietLogDAO dao2 = DietLogDAO();
        List<DietLogModel> log = await dao2.getById(widget.initialId);
        unidadesTotales = log.first.totalInsulinUnits;
        await loadSelectedFoods();
        loadControllers();
      }
    }
    setState(() {});
  }

  void loadControllers() {
    for (Selectedfood food in selectedFoods) {
      controllers[food.food.name]?.text = food.quantity.toString();
    }
  }

  Future<void> loadSelectedFoods() async {
    if (AuthServiceManager.checkIfLogged()) {
      List<DietLogFoodRelationModel> rel;
      DietLogFoodRelationDAOFB dao2 = DietLogFoodRelationDAOFB();
      FoodDAOFB dao3 = FoodDAOFB();
      rel = await dao2.getAll();
      rel = rel
          .where((relation) => relation.dietLogId == widget.initialId)
          .toList();
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
      List<DietLogFoodRelationModel> rel;
      DietLogFoodRelationDAO dao2 = DietLogFoodRelationDAO();
      FoodDAO dao3 = FoodDAO();
      rel = await dao2.getAll();
      rel = rel
          .where((relation) => relation.dietLogId == widget.initialId)
          .toList();
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
    }
    setState(() {});
  }

  void filterSearchedFood() {
    String searchInput = searchController.text.toLowerCase();
    setState(() {
      filteredSearchFood = foodList
          .where((food) => food.name.toLowerCase().startsWith(searchInput))
          .toList();
    });
  }

  void updateTotalUnits() {
    unidadesTotales = 0;
    for (Selectedfood selectedfood in selectedFoods) {
      unidadesTotales +=
          (selectedfood.quantity * (selectedfood.food.carbsPer100 / 100)) / 10;
    }
  }

  void deleteLog() async {
    if (AuthServiceManager.checkIfLogged()) {
      DietLogDAOFB dao = DietLogDAOFB();
      List<DietLogModel> log = await dao.getById(widget.initialId);

      List<DietLogFoodRelationModel> rel;
      DietLogFoodRelationDAOFB dao2 = DietLogFoodRelationDAOFB();
      rel = await dao2.getByDietLogId(widget.initialId);
      for (DietLogFoodRelationModel relation in rel) {
        dao2.delete(relation);
      }
      dao.delete(log.first);
    } else {
      DietLogDAO dao = DietLogDAO();
      List<DietLogModel> log = await dao.getById(widget.initialId);

      List<DietLogFoodRelationModel> rel;
      DietLogFoodRelationDAO dao2 = DietLogFoodRelationDAO();
      rel = await dao2.getByDietLogId(widget.initialId);
      for (DietLogFoodRelationModel relation in rel) {
        dao2.delete(relation);
      }
      dao.delete(log.first);
    }
  }

  @override
  void initState() {
    super.initState();
    getData();
    filteredSearchFood = foodList;

    searchController.addListener(() {
      filterSearchedFood();
    });
    searchController.text = "";
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: ScreenMargins(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
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
                              Text('Unidades totales: $unidadesTotales',
                                  style: TextStyle(
                                    color: const Color.fromARGB(
                                        255, 255, 255, 255),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  )),
                              Text("Alimentos seleccionados",
                                  style: TextStyle(
                                    color: const Color.fromARGB(
                                        255, 255, 255, 255),
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
                                IconButton(
                                    onPressed: () {
                                      setState(() {
                                        selectedFoods.removeWhere((selected) =>
                                            selected.food.name ==
                                            food.food.name);
                                        controllers[food.food.name]?.text = "";
                                        if (food.food.name == "Carbohidratos") {
                                          punctualCarbs = 0;
                                        }
                                        updateTotalUnits();
                                      });
                                    },
                                    icon: Icon(
                                      Icons.minimize_rounded,
                                      color: Colors.white,
                                      size: 25,
                                    )),
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
                    SizedBox(height: 8),
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
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: GestureDetector(
                        onTap: () async {
                          int carbsToAdd = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => DrawerScaffold(
                                      child: BackgroundBase(
                                          child: AddPunctualCarbs()))));
                          setState(() {
                            punctualCarbs = carbsToAdd;
                            Selectedfood? existing;
                            for (var f in selectedFoods) {
                              if (f.food.name == "Carbohidratos") {
                                existing = f;
                                break;
                              }
                            }
                            if (carbsToAdd <= 0) {
                              selectedFoods.remove(existing);
                            } else {
                              if (existing != null) {
                                existing.quantity = punctualCarbs;
                              } else {
                                selectedFoods.add(Selectedfood(
                                    quantity: punctualCarbs,
                                    food: foodList
                                        .where((food) =>
                                            food.name == "Carbohidratos")
                                        .first));
                              }
                            }

                            updateTotalUnits();
                          });
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add_rounded,
                              color: Colors.white,
                              size: 30,
                            ),
                            Text(
                              "carbs.",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                            ),
                            SizedBox(width: 20),
                            Text("Añadir carbohidratos",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18)),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Listado de alimentos",
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          width: 4,
                        ),
                        ElevatedButton(
                            onPressed: () {
                              setState(() {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => DrawerScaffold(
                                            child: BackgroundBase(
                                                child: CreateFood()))));
                              });
                              setState(() {});
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color.fromARGB(255, 85, 42, 196),
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 5, vertical: 5),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Column(
                              children: [
                                Text(
                                  "Crear",
                                  style: TextStyle(fontSize: 15),
                                ),
                                Text(
                                  "alimento",
                                  style: TextStyle(fontSize: 15),
                                ),
                              ],
                            )),
                      ],
                    ),
                    SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: searchController,
                        decoration: InputDecoration(
                          hintText: 'Buscar alimento...',
                          prefixIcon: Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: 300,
                      child: ListView.builder(
                        itemCount: filteredSearchFood.length,
                        itemBuilder: (context, index) {
                          final food = filteredSearchFood[index];
                          if (!controllers.containsKey(food.name)) {
                            controllers[food.name] =
                                TextEditingController(text: "");
                          }
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12.0, vertical: 4.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(food.name),
                                  ),
                                  SizedBox(
                                    width: 80,
                                    height: 30,
                                    child: TextField(
                                      keyboardType: TextInputType.number,
                                      controller: controllers[food.name],
                                      decoration: InputDecoration(
                                        hintText: 'g',
                                        contentPadding:
                                            EdgeInsets.symmetric(horizontal: 8),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                      ),
                                      onChanged: (value) {
                                        int quantity;
                                        if (value == "") {
                                          quantity = 0;
                                        } else {
                                          quantity = int.parse(value);
                                        }

                                        setState(() {
                                          Selectedfood? existing;
                                          for (var f in selectedFoods) {
                                            if (f.food.id == food.id) {
                                              existing = f;
                                              break;
                                            }
                                          }

                                          if (existing != null) {
                                            existing.quantity = quantity;
                                          } else {
                                            selectedFoods.add(Selectedfood(
                                                quantity: quantity,
                                                food: food));
                                          }
                                          if (value == "" ||
                                              int.parse(value) == 0) {
                                            selectedFoods.remove(existing);
                                          }
                                          updateTotalUnits();
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  //saveData();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DrawerScaffold(
                                  //child: BackgroundBase(child: DietMainPage()))));
                                  child: BackgroundBase(
                                      child: SaveDietLogPage(
                                totalCarbs: unidadesTotales * 10,
                                totalUnits: unidadesTotales,
                                selectedFoods: selectedFoods,
                                initialId: widget.initialId,
                              )))));
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 85, 42, 196),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              ),
              child: Text(
                  widget.initialId == ""
                      ? "Añadir registro"
                      : "Modificar registro",
                  style: TextStyle(fontSize: 18)),
            ),
            SizedBox(height: 16),
            widget.initialId != ""
                ? ElevatedButton(
                    onPressed: () {
                      deleteLog();
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DrawerScaffold(
                                  child:
                                      BackgroundBase(child: DietMainPage()))));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding:
                          EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    ),
                    child: Text("Eliminar", style: TextStyle(fontSize: 18)),
                  )
                : SizedBox()
          ],
        ),
      ),
    );
  }
}
