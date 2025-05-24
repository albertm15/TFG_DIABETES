import 'package:diabetes_tfg_app/widgets/backgroundBase.dart';
import 'package:diabetes_tfg_app/widgets/drawerScaffold.dart';
import 'package:diabetes_tfg_app/widgets/lowerNavBar.dart';
import 'package:diabetes_tfg_app/widgets/screenMargins.dart';
import 'package:diabetes_tfg_app/widgets/upperNavBar.dart';
import 'package:flutter/material.dart';

class ConfigureAutomaticEmailSender extends StatefulWidget {
  @override
  _ConfigureAutomaticEmailSenderState createState() =>
      _ConfigureAutomaticEmailSenderState();
}

class _ConfigureAutomaticEmailSenderState
    extends State<ConfigureAutomaticEmailSender> {
  @override
  Widget build(BuildContext context) {
    return DrawerScaffold(
        child: BackgroundBase(
            child: Scaffold(
      appBar: UpperNavBar(pageName: "EmailConfig"),
      body: BackgroundBase(
          child: Center(child: _ConfigureAutomaticEmailSenderStateWidget())),
      bottomNavigationBar: LowerNavBar(selectedSection: "EmailConfig"),
      backgroundColor: Colors.transparent,
    )));
  }
}

class _ConfigureAutomaticEmailSenderStateWidget extends StatefulWidget {
  @override
  _ConfigureAutomaticEmailSenderStateWidgetState createState() =>
      _ConfigureAutomaticEmailSenderStateWidgetState();
}

class _ConfigureAutomaticEmailSenderStateWidgetState
    extends State<_ConfigureAutomaticEmailSenderStateWidget> {
  @override
  Widget build(BuildContext context) {
    return ScreenMargins(
        child: Column(
      children: [],
    ));
  }
}
