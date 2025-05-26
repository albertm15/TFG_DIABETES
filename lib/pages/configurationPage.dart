import 'package:diabetes_tfg_app/widgets/backgroundBase.dart';
import 'package:diabetes_tfg_app/widgets/drawerScaffold.dart';
import 'package:diabetes_tfg_app/widgets/lowerNavBar.dart';
import 'package:diabetes_tfg_app/widgets/screenMargins.dart';
import 'package:diabetes_tfg_app/widgets/upperNavBar.dart';
import 'package:flutter/material.dart';

class ConfigurationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UpperNavBar(pageName: "Configuración"),
      body: DrawerScaffold(
          child:
              BackgroundBase(child: Center(child: ConfigurationPageWidget()))),
      bottomNavigationBar: LowerNavBar(selectedSection: ""),
      backgroundColor: Colors.transparent,
    );
  }
}

class ConfigurationPageWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenMargins(
        child: Column(
      children: [Text("Configuration page")],
    ));
  }
}
