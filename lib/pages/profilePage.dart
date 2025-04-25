import 'package:diabetes_tfg_app/widgets/backgroundBase.dart';
import 'package:diabetes_tfg_app/widgets/drawerScaffold.dart';
import 'package:diabetes_tfg_app/widgets/lowerNavBar.dart';
import 'package:diabetes_tfg_app/widgets/screenMargins.dart';
import 'package:diabetes_tfg_app/widgets/upperNavBar.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UpperNavBar(pageName: "Profile"),
      body: DrawerScaffold(
          child: BackgroundBase(child: Center(child: ProfilePageWidget()))),
      bottomNavigationBar: LowerNavBar(),
      backgroundColor: Colors.transparent,
    );
  }
}

class ProfilePageWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenMargins(
        child: Column(
      children: [Text("Profile page")],
    ));
  }
}
