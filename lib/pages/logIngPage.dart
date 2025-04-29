import 'package:diabetes_tfg_app/database/firebase/authServiceManager.dart';
import 'package:diabetes_tfg_app/pages/homePage.dart';
import 'package:diabetes_tfg_app/pages/resetForgottenPasswordPage.dart';
import 'package:diabetes_tfg_app/pages/signUpPage.dart';
import 'package:flutter/material.dart';

class LogInPage extends StatefulWidget {
  @override
  _LogInPageState createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String transformErrorMessage(String errorMessage) {
    switch (errorMessage) {
      case "Exception: [firebase_auth/invalid-email] The email address is badly formatted.":
        return "La dirección de correo electrónico no es válida.";
      case "Exception: [firebase_auth/invalid-credential] The supplied auth credential is malformed or has expired.":
        return "Las credenciales del usuario (correo o contraseña) son erroneas.";
      case "Exception: [firebase_auth/wrong-password] The password is invalid or the user does not have a password.":
        return "La contraseña es invalida.";
      default:
        return errorMessage;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF3C37FF),
            Color(0xFF242199),
          ],
          stops: [0.4, 1.0],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(7),
                    color: Colors.white,
                  ),
                  child: Text(
                    "Logo",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black, fontSize: 25),
                  )),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Container(
                  padding: const EdgeInsets.all(24.0),
                  decoration: BoxDecoration(
                    color: Colors.white, // Fondo del recuadro
                    borderRadius:
                        BorderRadius.circular(20), // Bordes redondeados
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Iniciar Sesión",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 85, 42, 196),
                        ),
                      ),
                      SizedBox(height: 20),
                      TextField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: "Email",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        keyboardType: TextInputType.emailAddress,
                      ),
                      SizedBox(height: 15),
                      TextField(
                        controller: _passwordController,
                        decoration: InputDecoration(
                          labelText: "Contraseña",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        obscureText: true,
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () async {
                          try {
                            bool logInSuccess = await AuthServiceManager.logIn(
                              _emailController.text,
                              _passwordController.text,
                            );
                            if (logInSuccess) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Homepage()),
                              );
                            } else {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  backgroundColor:
                                      Color.fromARGB(255, 232, 80, 69),
                                  title: Text(
                                    'No se pudo iniciar sesión',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  content: Text(
                                    'Verifica tu conexión a internet e inténtalo de nuevo.',
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 16),
                                  ),
                                  actions: [
                                    TextButton(
                                      child: Text(
                                        'OK',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 20),
                                      ),
                                      onPressed: () =>
                                          Navigator.of(context).pop(),
                                    ),
                                  ],
                                ),
                              );
                            }
                          } catch (error) {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                backgroundColor:
                                    Color.fromARGB(255, 232, 80, 69),
                                title: Text(
                                  'No se pudo iniciar sesión',
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
                                          color: Colors.white, fontSize: 20),
                                    ),
                                    onPressed: () =>
                                        Navigator.of(context).pop(),
                                  ),
                                ],
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Color.fromARGB(255, 85, 42, 196), // Botón lila
                          foregroundColor: Colors.white, // Texto blanco
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: 40, vertical: 15),
                        ),
                        child: Text(
                          "Confirmar",
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                      SizedBox(height: 15),
                      TextButton(
                        onPressed: () {
                          // Acción para recuperar contraseña
                          print("button pressed: CONTRASEÑA OLVIDADA");
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ResetForgottenPasswordPage(),
                              ));
                        },
                        child: Text(
                          "¿Olvidaste tu contraseña?",
                          style: TextStyle(
                              color: Color.fromARGB(255, 85, 42, 196),
                              decoration: TextDecoration.underline),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          // Acción para ir a registro
                          print("button pressed: REGISTRARSE");
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SignUpPage(),
                              ));
                        },
                        child: Text(
                          "¿No tienes cuenta? Regístrate",
                          style: TextStyle(
                              color: Color.fromARGB(255, 85, 42, 196),
                              decoration: TextDecoration.underline),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
