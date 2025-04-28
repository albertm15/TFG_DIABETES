import 'package:diabetes_tfg_app/database/firebase/authServiceManager.dart';
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
                        onPressed: () {
                          // Acción al confirmar
                          print("button pressed: COFIRMAR");
                          print(_emailController.text);
                          print(_passwordController1.text);
                          print(_passwordController2.text);
                          if (_passwordController1.text.toString().compareTo(
                                  _passwordController2.text.toString()) !=
                              0) {
                            print("contraseñas distintas");
                            AlertDialog(
                              backgroundColor:
                                  const Color.fromARGB(255, 232, 99, 89),
                              title: Title(
                                  color: Colors.black,
                                  child: Text(
                                      "Las 2 contraseñas no coincides. Deben ser iguales")),
                            );
                          } else {
                            AuthServiceManager.signUp(_emailController.text,
                                _passwordController1.text);
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Homepage(),
                                ));
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
    ));
  }
}
