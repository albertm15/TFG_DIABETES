import 'dart:io';
import 'package:diabetes_tfg_app/auxiliarResources/insulinNotifications.dart';
import 'package:diabetes_tfg_app/database/firebase/authServiceManager.dart';
import 'package:diabetes_tfg_app/database/firebase/dietDAO.dart';
import 'package:diabetes_tfg_app/database/firebase/dietLogDAO.dart';
import 'package:diabetes_tfg_app/database/firebase/dietLogFoodRelationDAO.dart';
import 'package:diabetes_tfg_app/database/firebase/exerciceLogDAO.dart';
import 'package:diabetes_tfg_app/database/firebase/foodDAO.dart';
import 'package:diabetes_tfg_app/database/firebase/glucoseLogDAO.dart';
import 'package:diabetes_tfg_app/database/firebase/insulinDAO.dart';
import 'package:diabetes_tfg_app/database/firebase/insulinLogDAO.dart';
import 'package:diabetes_tfg_app/database/firebase/reminderDAO.dart';
import 'package:diabetes_tfg_app/database/firebase/userDAO.dart';
import 'package:diabetes_tfg_app/database/local/databaseManager.dart';
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
import 'package:diabetes_tfg_app/models/InsulinLogModel.dart';
import 'package:diabetes_tfg_app/models/dietLogFoodRelationModel.dart';
import 'package:diabetes_tfg_app/models/dietLogModel.dart';
import 'package:diabetes_tfg_app/models/dietModel.dart';
import 'package:diabetes_tfg_app/models/exerciceLogModel.dart';
import 'package:diabetes_tfg_app/models/foodModel.dart';
import 'package:diabetes_tfg_app/models/gluoseLogModel.dart';
import 'package:diabetes_tfg_app/models/insulinModel.dart';
import 'package:diabetes_tfg_app/models/reminderModel.dart';
import 'package:diabetes_tfg_app/models/userModel.dart';
import 'package:diabetes_tfg_app/pages/insulinMainPage.dart';
import 'package:diabetes_tfg_app/pages/welcomePage.dart';
import 'package:diabetes_tfg_app/widgets/backgroundBase.dart';
import 'package:diabetes_tfg_app/widgets/drawerScaffold.dart';
import 'package:diabetes_tfg_app/widgets/lowerNavBar.dart';
import 'package:diabetes_tfg_app/widgets/screenMargins.dart';
import 'package:diabetes_tfg_app/widgets/upperNavBar.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> with WidgetsBindingObserver {
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
    return Scaffold(
      appBar: UpperNavBar(pageName: "Perfil"),
      body: DrawerScaffold(
          child: BackgroundBase(child: Center(child: ProfilePageWidget()))),
      bottomNavigationBar:
          _isKeyboardVisible ? null : LowerNavBar(selectedSection: ""),
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

  XFile? pickedImage;
  String photoUrl = "";

  final ImagePicker _picker = ImagePicker();

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
      photoUrl = userList[0].imagePathUrl ?? '';
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
        countryController.text,
        photoUrl);

    if (AuthServiceManager.checkIfLogged()) {
      UserDAOFB dao = UserDAOFB();
      await dao.update(userModelModified);
    } else {
      UserDAO dao = UserDAO();
      await dao.update(userModelModified);
    }
  }

  Future<void> pickImage() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        pickedImage = pickedFile;
      });
      await uploadImageAndSaveUrl(pickedFile);
    }
  }

  String transformErrorMessage(String errorMessage) {
    switch (errorMessage) {
      case "Exception: [firebase_auth/invalid-email] The email address is badly formatted.":
        return "La dirección de correo electrónico no es válida.";
      case "Exception: [firebase_auth/invalid-credential] The supplied auth credential is malformed or has expired.":
        return "Las credenciales del usuario (contraseña) son erroneas.";
      case "Exception: [firebase_auth/wrong-password] The password is invalid or the user does not have a password.":
        return "La contraseña es invalida.";
      default:
        return errorMessage;
    }
  }

  Future<void> uploadImageAndSaveUrl(XFile image) async {
    /*if (AuthServiceManager.checkIfLogged()) {
      final ref = FirebaseStorage.instance.ref().child(
          'profile_pictures/${AuthServiceManager.getCurrentUserUID()}.jpg');

      await ref.putData(await image.readAsBytes());
      final downloadUrl = await ref.getDownloadURL();

      await AuthServiceManager.getCurrentUser().updatePhotoURL(downloadUrl);
      await AuthServiceManager.getCurrentUser().reload();

      setState(() {
        photoUrl = downloadUrl;
      });
    } else {*/
    final appDir = await getApplicationDocumentsDirectory();
    final pfpDir = Directory('${appDir.path}/pfp');

    if (!await pfpDir.exists()) {
      await pfpDir.create(recursive: true);
    }

    final fileName = basename(image.path);
    final savedPath = '${pfpDir.path}/$fileName';
    final savedImage = await File(image.path).copy(savedPath);

    setState(() {
      photoUrl = savedImage.path;
    });
    // }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: ScreenMargins(
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
            buildProfileImage(
                photoUrl, /*AuthServiceManager.checkIfLogged()*/ false),
            SizedBox(height: 8),
            buildProfileField("Nombre completo", nameController),
            buildProfileEmailField(),
            buildProfileSexField(),
            buildProfileNumberFields("Altura (cm)", heightController),
            buildProfileNumberFields("Peso (kg)", weightController),
            buildProfileField("País", countryController),
            buildProfileTypeOfDiabetesField(),
            SizedBox(height: 12),
            Container(
              width: 250,
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    AuthServiceManager.logOut();
                    InsulinNotifications.cancelAll();
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
                onPressed: () async {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        backgroundColor: Colors.white,
                        title: Text("¿Eliminar cuenta?"),
                        actionsAlignment: MainAxisAlignment.center,
                        content: Text(
                            "¿Estás seguro de que quieres eliminar tu cuenta? Esta acción no se puede deshacer."),
                        actions: <Widget>[
                          TextButton(
                            child: Text("Cancelar",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 16)),
                            onPressed: () {
                              Navigator.of(context).pop(false);
                            },
                          ),
                          TextButton(
                            child: Text("Eliminar",
                                style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold)),
                            onPressed: () {
                              Navigator.of(context).pop(true);
                            },
                          ),
                        ],
                      );
                    },
                  );
                  if (confirm == true) {
                    showDialog(
                      context: context,
                      builder: (context) {
                        final passwordController = TextEditingController();

                        return AlertDialog(
                          alignment: Alignment.center,
                          title: Text(
                            "Confirmar eliminación",
                            style: TextStyle(
                                color: Colors.red, fontWeight: FontWeight.bold),
                          ),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text("Introduce tu contraseña para confirmar:"),
                              TextField(
                                controller: passwordController,
                                obscureText: true,
                              ),
                            ],
                          ),
                          backgroundColor: Colors.white,
                          actionsAlignment: MainAxisAlignment.center,
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text("Cancelar",
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 16)),
                            ),
                            TextButton(
                              onPressed: () async {
                                try {
                                  if (AuthServiceManager.checkIfLogged()) {
                                    final email =
                                        AuthServiceManager.getCurrentUser()
                                            .email!;
                                    final password = passwordController.text;
                                    await AuthServiceManager.deleteUser(
                                        email, password);
                                    InsulinNotifications.cancelAll();
                                    DietDAOFB dao1 = DietDAOFB();
                                    DietLogDAOFB dao2 = DietLogDAOFB();
                                    DietLogFoodRelationDAOFB dao3 =
                                        DietLogFoodRelationDAOFB();
                                    ExerciceLogDAOFB dao4 = ExerciceLogDAOFB();
                                    FoodDAOFB dao5 = FoodDAOFB();
                                    GlucoseLogDAOFB dao6 = GlucoseLogDAOFB();
                                    InsulinDAOFB dao7 = InsulinDAOFB();
                                    InsulinLogDAOFB dao8 = InsulinLogDAOFB();
                                    ReminderDAOFB dao9 = ReminderDAOFB();
                                    UserDAOFB dao10 = UserDAOFB();
                                    List<DietModel> lis1 = await dao1.getAll();
                                    List<DietLogModel> lis2 =
                                        await dao2.getAll();
                                    List<DietLogFoodRelationModel> lis3 =
                                        await dao3.getAll();
                                    List<ExerciceLogModel> lis4 =
                                        await dao4.getAll();
                                    List<FoodModel> lis5 =
                                        await dao5.getAllFromUser();
                                    List<GlucoseLogModel> lis6 =
                                        await dao6.getAll();
                                    List<InsulinModel> lis7 =
                                        await dao7.getAll();
                                    List<InsulinLogModel> lis8 =
                                        await dao8.getAll();
                                    List<ReminderModel> lis9 =
                                        await dao9.getAll();
                                    List<UserModel> lis10 =
                                        await dao10.getAll();

                                    for (DietModel log in lis1) {
                                      await dao1.delete(log);
                                    }
                                    for (DietLogModel log in lis2) {
                                      await dao2.delete(log);
                                    }
                                    for (DietLogFoodRelationModel log in lis3) {
                                      await dao3.delete(log);
                                    }
                                    for (ExerciceLogModel log in lis4) {
                                      await dao4.delete(log);
                                    }
                                    for (FoodModel log in lis5) {
                                      await dao5.delete(log);
                                    }
                                    for (GlucoseLogModel log in lis6) {
                                      await dao6.delete(log);
                                    }
                                    for (InsulinModel log in lis7) {
                                      await dao7.delete(log);
                                    }
                                    for (InsulinLogModel log in lis8) {
                                      await dao8.delete(log);
                                    }
                                    for (ReminderModel log in lis9) {
                                      await dao9.delete(log);
                                    }
                                    for (UserModel log in lis10) {
                                      await dao10.delete(log);
                                    }
                                  } else {
                                    await DatabaseManager.deleteDB();
                                  }
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => Welcomepage(),
                                      ));
                                } catch (error) {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      backgroundColor:
                                          Color.fromARGB(255, 232, 80, 69),
                                      title: Text(
                                        'Algo salió mal',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      content: Text(
                                        transformErrorMessage(error.toString()),
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 16),
                                      ),
                                      actions: [
                                        TextButton(
                                          child: Text(
                                            'OK',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 20),
                                          ),
                                          onPressed: () =>
                                              Navigator.of(context).pop(),
                                        ),
                                      ],
                                    ),
                                  );
                                }
                              },
                              child: Text("Eliminar",
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16)),
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
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
      )),
    );
  }

  Widget buildProfileField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
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
      padding: const EdgeInsets.only(top: 8.0),
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
      padding: const EdgeInsets.only(top: 8.0),
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
      padding: const EdgeInsets.only(top: 8.0),
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
      padding: const EdgeInsets.only(top: 8.0),
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

  Widget buildProfileImage(String photoUrl, bool isLoggedIn) {
    return GestureDetector(
        onTap: () {
          if (isEditing) {
            pickImage();
          }
        },
        child: (photoUrl.isEmpty)
            ? CircleAvatar(
                radius: 50,
                backgroundColor: Colors.grey,
                child: Icon(
                  Icons.person_add_alt_1,
                  size: 50,
                  color: Color.fromARGB(255, 95, 95, 95),
                ),
              )
            : (isLoggedIn
                ? CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey,
                    backgroundImage: NetworkImage(photoUrl),
                  )
                : File(photoUrl).existsSync()
                    ? CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.grey,
                        backgroundImage: FileImage(File(photoUrl)),
                      )
                    : CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.grey,
                        child: Icon(
                          Icons.person_add_alt_1,
                          size: 50,
                          color: Color.fromARGB(255, 95, 95, 95),
                        ),
                      )));
  }
}
