import 'package:diabetes_tfg_app/database/firebase/authServiceManager.dart';
import 'package:diabetes_tfg_app/database/firebase/userDAO.dart';
import 'package:diabetes_tfg_app/database/local/userDAO.dart';
import 'package:diabetes_tfg_app/models/userModel.dart';
import 'package:diabetes_tfg_app/pages/welcomePage.dart';
import 'package:diabetes_tfg_app/widgets/backgroundBase.dart';
import 'package:diabetes_tfg_app/widgets/drawerScaffold.dart';
import 'package:diabetes_tfg_app/widgets/lowerNavBar.dart';
import 'package:diabetes_tfg_app/widgets/screenMargins.dart';
import 'package:diabetes_tfg_app/widgets/upperNavBar.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UpperNavBar(pageName: "Profile"),
      body: DrawerScaffold(
          child: BackgroundBase(child: Center(child: ProfilePageWidget()))),
      bottomNavigationBar: LowerNavBar(),
      backgroundColor: Colors.transparent,
    );
  }
}

class ProfilePageWidget extends StatefulWidget {
  @override
  _ProfilePageWidgetState createState() => _ProfilePageWidgetState();
}

class _ProfilePageWidgetState extends State<ProfilePageWidget> {
  bool isEditing = false;
  List<UserModel> userList = [];
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController countryController = TextEditingController();
  //final TextEditingController diabetesTypeController = TextEditingController();

  String gender = "Hombre";
  int typeOfDiabetes = 1;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() async {
    if (AuthServiceManager.checkIfLogged()) {
      UserDAOFB dao = UserDAOFB();
      userList = await dao.getById(AuthServiceManager.getCurrentUserUID());
    } else {
      UserDAO dao = UserDAO();
      userList = await dao.getAll();
    }

    setState(() {
      nameController.text = userList[0].fullName ?? '';
      emailController.text = userList[0].email;
      heightController.text = userList[0].height.toString();
      weightController.text = userList[0].weight.toString();
      countryController.text = userList[0].country ?? '';
      typeOfDiabetes = userList[0].typeOfDiabetes ?? 1;
      gender = userList[0].sex ?? "Hombre";
    });
  }

  void saveLog() async {
    UserModel userModelModified = UserModel.withId(
        userList[0].id,
        userList[0].email,
        userList[0].passwordHash,
        int.parse(heightController.text),
        double.parse(weightController.text),
        typeOfDiabetes,
        nameController.text,
        gender,
        countryController.text);

    if (AuthServiceManager.checkIfLogged()) {
      UserDAOFB dao = UserDAOFB();
      await dao.update(userModelModified);
    } else {
      UserDAO dao = UserDAO();
      await dao.update(userModelModified);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScreenMargins(
        child: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(isEditing ? "Confirmar modificación" : "Modificar"),
              IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  setState(() {
                    isEditing = !isEditing;
                    if (!isEditing) {
                      saveLog();
                    }
                  });
                },
              ),
            ],
          ),
          Stack(
            alignment: Alignment.topRight,
            children: [
              CircleAvatar(
                radius: 50,
                child: Icon(
                  Icons.person_add_alt_1,
                  size: 50,
                  color: const Color.fromARGB(255, 95, 95, 95),
                ),
                backgroundColor: Colors.grey,
              ),
            ],
          ),
          SizedBox(height: 10),
          buildProfileField("Nombre completo", nameController),
          buildProfileEmailField(),
          buildProfileSexField(),
          buildProfileNumberFields("Altura (cm)", heightController),
          buildProfileNumberFields("Peso (kg)", weightController),
          buildProfileField("País", countryController),
          buildProfileTypeOfDiabetesField(),
          SizedBox(height: 15),
          Container(
            width: 250,
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  AuthServiceManager.logOut();
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Welcomepage(),
                      ));
                });
              },
              child: Text("Cerrar Sesión", style: TextStyle(fontSize: 18)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 85, 42, 196),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              ),
            ),
          ),
          SizedBox(height: 20),
          Container(
            width: 250,
            child: ElevatedButton(
              onPressed: () {},
              child: Text("Eliminar cuenta", style: TextStyle(fontSize: 18)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              ),
            ),
          )
        ],
      ),
    ));
  }

  Widget buildProfileField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(top: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            child: Text(
              "$label: ",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: isEditing
                ? TextField(
                    controller: controller,
                    decoration: InputDecoration(isDense: true),
                  )
                : Text(controller.text),
          ),
        ],
      ),
    );
  }

  Widget buildProfileEmailField() {
    return Padding(
      padding: const EdgeInsets.only(top: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Email: ",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(
            "${emailController.text}",
          ),
        ],
      ),
    );
  }

  Widget buildProfileSexField() {
    return Padding(
      padding: const EdgeInsets.only(top: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            child: Text(
              "Sexo: ",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Checkbox(
            checkColor: Colors.white,
            activeColor: Color.fromARGB(255, 85, 42, 196),
            value: gender == "Hombre",
            onChanged: isEditing
                ? (val) {
                    setState(() {
                      gender = "Hombre";
                    });
                  }
                : null,
          ),
          Text("Hombre"),
          Checkbox(
            checkColor: Colors.white,
            activeColor: Color.fromARGB(255, 85, 42, 196),
            value: gender == "Mujer",
            onChanged: isEditing
                ? (val) {
                    setState(() {
                      gender = "Mujer";
                    });
                  }
                : null,
          ),
          Text("Mujer"),
        ],
      ),
    );
  }

  Widget buildProfileNumberFields(
      String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(top: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            child: Text(
              "$label: ",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: isEditing
                ? TextField(
                    controller: controller,
                    decoration: InputDecoration(isDense: true),
                    keyboardType: TextInputType.number,
                  )
                : Text(controller.text),
          ),
        ],
      ),
    );
  }

  Widget buildProfileTypeOfDiabetesField() {
    return Padding(
      padding: const EdgeInsets.only(top: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            child: Text(
              "Tipo de diabetes: ",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Checkbox(
            checkColor: Colors.white,
            activeColor: Color.fromARGB(255, 85, 42, 196),
            value: typeOfDiabetes == 1,
            onChanged: isEditing
                ? (val) {
                    setState(() {
                      typeOfDiabetes = 1;
                    });
                  }
                : null,
          ),
          Text("1"),
          Checkbox(
            checkColor: Colors.white,
            activeColor: Color.fromARGB(255, 85, 42, 196),
            value: typeOfDiabetes == 2,
            onChanged: isEditing
                ? (val) {
                    setState(() {
                      typeOfDiabetes = 2;
                    });
                  }
                : null,
          ),
          Text("2"),
        ],
      ),
    );
  }
}
