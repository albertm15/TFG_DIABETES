import 'package:flutter/material.dart';

class BackgroundBase extends StatelessWidget {
  final Widget child;

  const BackgroundBase({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFFFFFFF),
              Color.fromARGB(255, 155, 198, 247),
            ],
            stops: [0, 1.0],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: child);
  }
}
