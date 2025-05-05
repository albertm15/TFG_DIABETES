import 'package:diabetes_tfg_app/widgets/backgroundBase.dart';
import 'package:diabetes_tfg_app/widgets/drawerScaffold.dart';
import 'package:diabetes_tfg_app/widgets/lowerNavBar.dart';
import 'package:diabetes_tfg_app/widgets/screenMargins.dart';
import 'package:diabetes_tfg_app/widgets/upperNavBar.dart';
import 'package:flutter/material.dart';

class AddInsulinFormPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UpperNavBar(pageName: "Añadir Insulina"),
      body: DrawerScaffold(
          child:
              BackgroundBase(child: Center(child: AddInsulinFormPageWidget()))),
      bottomNavigationBar: LowerNavBar(),
      backgroundColor: Colors.transparent,
    );
  }
}

class AddInsulinFormPageWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded(child: Text("ff"));
  }
}
