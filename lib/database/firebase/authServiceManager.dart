import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:diabetes_tfg_app/database/firebase/userDAO.dart';
import 'package:diabetes_tfg_app/models/userModel.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthServiceManager {
  static bool checkIfLogged() {
    return FirebaseAuth.instance.currentUser != null;
  }

  static String getCurrentUserUID() {
    return FirebaseAuth.instance.currentUser!.uid;
  }

  static Future<bool> logIn(String email, String password) async {
    //mirar de aplicar el check de la conexion con try catch y la excepcion
    final connectivity = await Connectivity().checkConnectivity();
    if (!connectivity.contains(ConnectivityResult.wifi) &&
        !connectivity.contains(ConnectivityResult.mobile)) {
      //el logIn no se puede hacer ya que no hay conexion
      return false;
    } else {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      return true;
    }
  }

  static Future<bool> signUp(String email, String password) async {
    //mirar de aplicar el check de la conexion con try catch y la excepcion
    final connectivity = await Connectivity().checkConnectivity();
    if (!connectivity.contains(ConnectivityResult.wifi) &&
        !connectivity.contains(ConnectivityResult.mobile)) {
      return false;
    } else {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      UserDAOFB().insert(UserModel(userCredential.user!.uid, email));
      return true;
    }
  }

  static Future<void> logOut() async {
    await FirebaseAuth.instance.signOut();
  }

  static Future<void> deleteUser() async {
    //pedir que se vuelva a loggear antes de borrar!
    await FirebaseAuth.instance.currentUser!.delete();
    //eliminar todos los datos de ese user de firebase y todos los logs!
  }

  static Future<void> updatePassword(String password) async {
    //pedir que se vuelva a loggear antes de actualizar la password!
    await FirebaseAuth.instance.currentUser!.updatePassword(password);
  }

  static Future<void> resetForgottenPassword(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    } catch (e) {
      print("Error al enviar email de recuperación: $e");
      //crear un AlertDialog o alo asi para mostrar que no existe ese eail en el auth
    }
  }
}
