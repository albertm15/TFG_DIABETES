import 'package:diabetes_tfg_app/database/firebase/authServiceManager.dart';
import 'package:diabetes_tfg_app/pages/logIngPage.dart';
import 'package:diabetes_tfg_app/pages/signUpPage.dart';
import 'package:flutter/material.dart';

class ResetForgottenPasswordPage extends StatefulWidget {
  @override
  _ResetForgottenPasswordPageState createState() =>
      _ResetForgottenPasswordPageState();
}

class _ResetForgottenPasswordPageState
    extends State<ResetForgottenPasswordPage> {
  final TextEditingController _emailController = TextEditingController();

  String transformErrorMessage(String errorMessage) {
    switch (errorMessage) {
      case "Exception: [firebase_auth/missing-email] An email address must be provided.":
        return "No se ha introducido una direccion de correo electrónico";
      case "Exception: [firebase_auth/invalid-email] The email address is badly formatted.":
        return "La dirección de correo electrónico no es válida.";
      default:
        return errorMessage;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/logo_wo_bg.png',
                      color: Colors.white,
                      height: 100,
                      width: 100,
                    ),
                    Text(
                      "Glucare",
                      style: TextStyle(
                          fontSize: 40,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
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
                          "Restablecer Contraseña",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 85, 42, 196),
                          ),
                        ),
                        Text(
                          "Escriba la dirección de correo electrónico en la que recivirá el correo para restablecer la contraseña.",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black,
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
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () async {
                            try {
                              bool resetPasswordSuccess =
                                  await AuthServiceManager
                                      .resetForgottenPassword(
                                          _emailController.text);
                              if (resetPasswordSuccess) {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LogInPage()),
                                );
                              } else {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    backgroundColor:
                                        Color.fromARGB(255, 232, 80, 69),
                                    title: Text(
                                      'No se pudo enviar el correo',
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
                            } catch (error) {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  backgroundColor:
                                      Color.fromARGB(255, 232, 80, 69),
                                  title: Text(
                                    'No se pudo enviar el correo',
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
                            "Enviar",
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
                                  builder: (context) => LogInPage(),
                                ));
                          },
                          child: Text(
                            "¿No olvidaste tu contraseña? Iniciar Sesión",
                            style: TextStyle(
                                color: Color.fromARGB(255, 85, 42, 196),
                                decoration: TextDecoration.underline,
                                fontSize: 13),
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
                                decoration: TextDecoration.underline,
                                fontSize: 13),
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
      )),
    );
  }
}
