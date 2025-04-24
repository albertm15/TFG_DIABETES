import 'package:flutter/material.dart';

class UpperNavBar extends StatelessWidget implements PreferredSizeWidget {
  final String pageName;
  const UpperNavBar({required this.pageName});

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
        preferredSize: preferredSize,
        child: Container(
            padding: EdgeInsets.only(bottom: 15),
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
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20)),
            ),
            child: AppBar(
              backgroundColor: Colors.transparent,
              title: Text(
                "$pageName",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 35,
                ),
              ),
              leading: IconButton(
                onPressed: () {
                  print("Botón 'Lateral Menu' presionado");
                },
                icon: Icon(Icons.menu_rounded, color: Colors.white),
                iconSize: 40,
                padding: EdgeInsets.only(left: 30),
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    print("Botón 'Back' presionado");
                    if (Navigator.canPop(context)) {
                      Navigator.pop(context);
                    }
                  },
                  icon: Icon(Icons.arrow_back_ios_rounded, color: Colors.white),
                  iconSize: 40,
                  padding: EdgeInsets.only(right: 30),
                ),
              ],
            )));
  }
}
