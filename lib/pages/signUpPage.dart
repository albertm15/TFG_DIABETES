import 'package:diabetes_tfg_app/database/firebase/authServiceManager.dart';
import 'package:diabetes_tfg_app/database/firebase/insulinDAO.dart';
import 'package:diabetes_tfg_app/models/insulinModel.dart';
import 'package:diabetes_tfg_app/pages/homePage.dart';
import 'package:diabetes_tfg_app/pages/logIngPage.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController1 = TextEditingController();
  final TextEditingController _passwordController2 = TextEditingController();

  String transformErrorMessage(String errorMessage) {
    switch (errorMessage) {
      case "Exception: [firebase_auth/invalid-email] The email address is badly formatted.":
        return "La dirección de correo electrónico no es válida";
      case "Exception: [firebase_auth/email-already-in-use] The email address is already in use by another account.":
        return "La dirección de correo electronico ya está en uso";
      case "Exception: [firebase_auth/weak-password] Password should be at least 6 characters":
        return "La contraseña es invalida, debe tener almenos 6 caracteres.";
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
                          "Crear cuenta",
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
                          controller: _passwordController1,
                          decoration: InputDecoration(
                            labelText: "Contraseña",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          obscureText: true,
                        ),
                        SizedBox(height: 15),
                        TextField(
                          controller: _passwordController2,
                          decoration: InputDecoration(
                            labelText: "Repetir Contraseña",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          obscureText: true,
                        ),
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () async {
                            if (_passwordController1.text !=
                                _passwordController2.text) {
                              print("contraseñas distintas");
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    backgroundColor:
                                        const Color.fromARGB(255, 232, 80, 69),
                                    title: Text(
                                      "Las 2 contraseñas no coinciden",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    content: Text(
                                        "Debes escribir la misma contraseña en ambos campos.",
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 16)),
                                    actions: [
                                      TextButton(
                                        child: Text("OK",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 20)),
                                        onPressed: () {
                                          Navigator.of(context)
                                              .pop(); // Cierra el pop-up
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            } else {
                              try {
                                bool signUpSuccess =
                                    await AuthServiceManager.signUp(
                                  _emailController.text,
                                  _passwordController1.text,
                                );
                                if (signUpSuccess) {
                                  InsulinDAOFB dao1 = InsulinDAOFB();
                                  dao1.insert(InsulinModel.newEntity(
                                      AuthServiceManager.getCurrentUserUID(),
                                      "00:00",
                                      "00:00",
                                      0,
                                      0));
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
                                        'No se pudo registrar',
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
                                      'No se pudo registrar',
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
                            // Acción para ir a registro
                            print("button pressed: Iniciar sesión");
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => LogInPage(),
                                ));
                          },
                          child: Text(
                            "Ya tienes cuenta? Inicia Sesión",
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
      )),
    );
  }
}
