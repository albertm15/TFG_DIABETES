import 'package:flutter/material.dart';

class ScreenMargins extends StatelessWidget {
  final Widget child;

  const ScreenMargins({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 18, right: 18, top: 20, bottom: 20),
      child: child,
    );
  }
}
