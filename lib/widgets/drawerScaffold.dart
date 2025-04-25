import 'package:diabetes_tfg_app/database/firebase/authServiceManager.dart';
import 'package:diabetes_tfg_app/pages/configurationPage.dart';
import 'package:diabetes_tfg_app/pages/profilePage.dart';
import 'package:diabetes_tfg_app/pages/reportsPage.dart';
import 'package:diabetes_tfg_app/widgets/backgroundBase.dart';
import 'package:flutter/material.dart';

class DrawerScaffold extends StatefulWidget {
  Widget child;

  DrawerScaffold({required this.child});

  @override
  _DrawerScaffoldState createState() => _DrawerScaffoldState();
}

class _DrawerScaffoldState extends State<DrawerScaffold> {
  bool isOpen = false;
  double xOffset = 0;
  double yOffset = 0;
  double scaleFactor = 1;

  void changeDrawerState() {
    setState(() {
      if (isOpen) {
        isOpen = false;
        xOffset = 0;
        yOffset = 0;
        scaleFactor = 1;
      } else {
        isOpen = true;
        xOffset = 230;
        yOffset = 150;
        scaleFactor = 0.75;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF242199),
            Color(0xFF3C37FF),
          ],
          stops: [0.2, 1.0],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: Stack(
        children: [
          // Menú lateral
          SafeArea(
            child: Container(
              padding: EdgeInsets.all(15),
              child: Column(
                children: [
                  ListTile(
                      title: Text(
                          //CAMBIAR ESTO POR EL NOMBRE
                          //"Hola, ${AuthServiceManager.getCurrentUserUID()}!",
                          "Hola, usuario desconocido!",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold))),
                  SizedBox(
                    height: 60,
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.person,
                      color: Colors.white,
                      size: 25,
                    ),
                    title: Text("Perfil",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold)),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DrawerScaffold(
                                  child: BackgroundBase(
                                      //child: ExerciceAndHealthMainPage())));
                                      child: ProfilePage()))));
                    },
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.settings,
                      color: Colors.white,
                      size: 25,
                    ),
                    title: Text("Configuración",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold)),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DrawerScaffold(
                                  child: BackgroundBase(
                                      //child: ExerciceAndHealthMainPage())));
                                      child: ConfigurationPage()))));
                    },
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.edit_document,
                      color: Colors.white,
                      size: 25,
                    ),
                    title: Text("Reportes",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold)),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DrawerScaffold(
                                  child: BackgroundBase(
                                      //child: ExerciceAndHealthMainPage())));
                                      child: ReportsPage()))));
                    },
                  ),
                  SizedBox(height: 280),
                  ListTile(
                    leading: Icon(
                      Icons.login_outlined,
                      color: Colors.white,
                      size: 25,
                    ),
                    title: Text("Cerrar sesión",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold)),
                    onTap: () {
                      //Añadir un redirect a la pantalla de bienvenida despues de que se cierre la sesion
                      setState(() {
                        AuthServiceManager.logOut();
                      });
                    },
                  ),
                ],
              ),
            ),
          ),

          // Pantalla principal animada
          AnimatedContainer(
              transform: Matrix4.translationValues(xOffset, yOffset, 0)
                ..scale(scaleFactor),
              duration: Duration(milliseconds: 200),
              decoration: BoxDecoration(
                borderRadius:
                    isOpen ? BorderRadius.circular(30) : BorderRadius.zero,
              ),
              child: ClipRRect(
                borderRadius: isOpen
                    ? BorderRadius.circular(30)
                    : BorderRadius.circular(0),
                child: GestureDetector(
                  onTap: isOpen ? changeDrawerState : null,
                  child: AbsorbPointer(
                    absorbing: isOpen,
                    child: Stack(
                      children: [
                        widget.child,
                        Positioned(
                          top: 55,
                          left: 22,
                          child: IconButton(
                            icon: Icon(Icons.menu_rounded,
                                color: Colors.white, size: 40),
                            onPressed: changeDrawerState,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )),
        ],
      ),
    ));
  }
}
