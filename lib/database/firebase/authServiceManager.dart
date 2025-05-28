import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:diabetes_tfg_app/auxiliarResources/insulinNotifications.dart';
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
import 'package:firebase_auth/firebase_auth.dart';

class AuthServiceManager {
  static bool checkIfLogged() {
    return FirebaseAuth.instance.currentUser != null;
  }

  static String getCurrentUserUID() {
    return FirebaseAuth.instance.currentUser!.uid;
  }

  static User getCurrentUser() {
    return FirebaseAuth.instance.currentUser!;
  }

  static Future<bool> logIn(String email, String password) async {
    //mirar de aplicar el check de la conexion con try catch y la excepcion
    try {
      final connectivity = await Connectivity().checkConnectivity();
      if (!connectivity.contains(ConnectivityResult.wifi) &&
          !connectivity.contains(ConnectivityResult.mobile)) {
        return false;
      } else {
        await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password);

        return true;
      }
    } catch (e) {
      throw Exception('${e.toString()}');
    }
  }

  static Future<bool> signUp(String email, String password) async {
    //mirar de aplicar el check de la conexion con try catch y la excepcion
    try {
      final connectivity = await Connectivity().checkConnectivity();
      if (!connectivity.contains(ConnectivityResult.wifi) &&
          !connectivity.contains(ConnectivityResult.mobile)) {
        return false;
      } else {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: email.trim(), password: password);

        UserDAOFB().insert(UserModel(userCredential.user!.uid, email));

        return true;
      }
    } catch (e) {
      throw Exception('${e.toString()}');
    }
  }

  static Future<void> logOut() async {
    await FirebaseAuth.instance.signOut();
    print("user logged out");
  }

  static Future<void> deleteUser(String email, String password) async {
    try {
      AuthCredential credential =
          EmailAuthProvider.credential(email: email, password: password);
      User user = FirebaseAuth.instance.currentUser!;
      await user.reauthenticateWithCredential(credential);
      InsulinNotifications.cancelAll();
      DietDAOFB dao1 = DietDAOFB();
      DietLogDAOFB dao2 = DietLogDAOFB();
      DietLogFoodRelationDAOFB dao3 = DietLogFoodRelationDAOFB();
      ExerciceLogDAOFB dao4 = ExerciceLogDAOFB();
      FoodDAOFB dao5 = FoodDAOFB();
      GlucoseLogDAOFB dao6 = GlucoseLogDAOFB();
      InsulinDAOFB dao7 = InsulinDAOFB();
      InsulinLogDAOFB dao8 = InsulinLogDAOFB();
      ReminderDAOFB dao9 = ReminderDAOFB();
      UserDAOFB dao10 = UserDAOFB();
      List<DietModel> lis1 = await dao1.getAll();
      List<DietLogModel> lis2 = await dao2.getAll();
      List<DietLogFoodRelationModel> lis3 = await dao3.getAll();
      List<ExerciceLogModel> lis4 = await dao4.getAll();
      List<FoodModel> lis5 = await dao5.getAllFromUser();
      List<GlucoseLogModel> lis6 = await dao6.getAll();
      List<InsulinModel> lis7 = await dao7.getAll();
      List<InsulinLogModel> lis8 = await dao8.getAll();
      List<ReminderModel> lis9 = await dao9.getAll();
      List<UserModel> lis10 = await dao10.getAll();

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
      await user.delete();
    } catch (e) {
      throw Exception('${e.toString()}');
    }
  }

  static Future<void> updatePassword(String password) async {
    //pedir que se vuelva a loggear antes de actualizar la password!
    await FirebaseAuth.instance.currentUser!.updatePassword(password);
  }

  static Future<bool> resetForgottenPassword(String email) async {
    try {
      final connectivity = await Connectivity().checkConnectivity();
      if (!connectivity.contains(ConnectivityResult.wifi) &&
          !connectivity.contains(ConnectivityResult.mobile)) {
        return false;
      } else {
        await FirebaseAuth.instance.sendPasswordResetEmail(email: email);

        return true;
      }
    } catch (e) {
      throw Exception('${e.toString()}');
    }
  }
}
