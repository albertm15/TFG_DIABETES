import 'package:diabetes_tfg_app/database/local/dietDAO.dart';
import 'package:diabetes_tfg_app/database/local/dietLogDAO.dart';
import 'package:diabetes_tfg_app/database/local/dietLogFoodRelationDAO.dart';
import 'package:diabetes_tfg_app/database/local/exerciceLogDAO.dart';
import 'package:diabetes_tfg_app/database/local/foodDAO.dart';
import 'package:diabetes_tfg_app/database/local/glucoseLogDAO.dart';
import 'package:diabetes_tfg_app/database/local/insulinDAO.dart';
import 'package:diabetes_tfg_app/database/local/insulinLogDAO.dart';
import 'package:diabetes_tfg_app/database/local/reminderDAO.dart';
import 'package:diabetes_tfg_app/database/local/userDAO.dart';
import 'package:diabetes_tfg_app/models/userModel.dart';
import 'package:diabetes_tfg_app/widgets/backgroundBase.dart';
import 'package:diabetes_tfg_app/widgets/lowerNavBar.dart';
import 'package:diabetes_tfg_app/widgets/screenMargins.dart';
import 'package:diabetes_tfg_app/widgets/upperNavBar.dart';
import 'package:flutter/material.dart';

class DbTestingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UpperNavBar(pageName: "DB TEST"),
      body: BackgroundBase(child: Center(child: DbTestingWidget())),
      bottomNavigationBar: LowerNavBar(),
      backgroundColor: Colors.transparent,
    );
  }
}

class DbTestingWidget extends StatelessWidget {
  DietLogFoodRelationDAO dietLogFoodRelationDAO = DietLogFoodRelationDAO();
  DietLogDAO dietLogDAO = DietLogDAO();
  DietDAO dietDAO = DietDAO();
  ExerciceLogDAO exerciceLogDAO = ExerciceLogDAO();
  FoodDAO foodDAO = FoodDAO();
  GlucoseLogDAO glucoseLogDAO = GlucoseLogDAO();
  InsulinLogDAO insulinLogDAO = InsulinLogDAO();
  InsulinDAO insulinDAO = InsulinDAO();
  ReminderDAO reminderDAO = ReminderDAO();
  UserDAO userDAO = UserDAO();

  Future<void> getModels() async {
    print("----------GET ALL MODELS-----------");
    print(await dietLogFoodRelationDAO.getAll());
    print(await dietLogDAO.getAll());
    print(await dietDAO.getAll());
    print(await exerciceLogDAO.getAll());
    print(await foodDAO.getAll());
    print(await glucoseLogDAO.getAll());
    print(await insulinLogDAO.getAll());
    print(await insulinDAO.getAll());
    print(await reminderDAO.getAll());
    print(await userDAO.getAll());
  }

  Future<void> insertModels() async {
    UserModel e1 = UserModel.rawPassword("jorge@gmail.com", "1234", 182, 80.2,
        1, "Jorge Rodriguez", "Male", "Spain");
    print("----------INSERT ALL MODELS-----------");
    print(await userDAO.insert(e1));
  }

  Future<void> modifyModels() async {
    List<UserModel> l1 =
        await userDAO.getById("c0e68bb5-12b9-45d6-a46d-8870e4b2b025");
    UserModel e1 = l1[0];
    e1.fullName = "Patricio XDDD";
    print("----------MODIFY ALL MODELS-----------");
    print(await userDAO.update(e1));
  }

  Future<void> deleteModels() async {
    List<UserModel> l1 =
        await userDAO.getById("271e5297-7953-4564-8928-7e30c1e530bb");
    UserModel e1 = l1[0];
    print("----------DELETE ALL MODELS-----------");
    print(await userDAO.delete(e1));
  }

  @override
  Widget build(BuildContext context) {
    return ScreenMargins(
        child: Column(
      children: [
        SizedBox(
          height: 25,
        ),
        IconButton(
            onPressed: () {
              insertModels();
            },
            icon: Icon(
              Icons.add,
              color: Colors.black,
              size: 80,
            )),
        SizedBox(
          height: 50,
        ),
        IconButton(
            onPressed: () {
              modifyModels();
            },
            icon: Icon(
              Icons.edit,
              color: Colors.black,
              size: 80,
            )),
        SizedBox(
          height: 50,
        ),
        IconButton(
            onPressed: () {
              deleteModels();
            },
            icon: Icon(
              Icons.delete,
              color: Colors.black,
              size: 80,
            )),
        SizedBox(
          height: 50,
        ),
        IconButton(
            onPressed: () {
              getModels();
            },
            icon: Icon(
              Icons.search,
              color: Colors.black,
              size: 80,
            )),
      ],
    ));
  }
}
