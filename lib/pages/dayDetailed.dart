import 'package:diabetes_tfg_app/database/firebase/authServiceManager.dart';
import 'package:diabetes_tfg_app/database/firebase/reminderDAO.dart';
import 'package:diabetes_tfg_app/database/local/reminderDAO.dart';
import 'package:diabetes_tfg_app/models/reminderModel.dart';
import 'package:diabetes_tfg_app/widgets/lowerNavBar.dart';
import 'package:diabetes_tfg_app/widgets/minimizedReminderList.dart';
import 'package:diabetes_tfg_app/widgets/screenMargins.dart';
import 'package:diabetes_tfg_app/widgets/upperNavBar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DayDetails extends StatefulWidget {
  final DateTime initialDate;

  DayDetails({required this.initialDate});

  @override
  _DayDetailsPageState createState() => _DayDetailsPageState();
}

class _DayDetailsPageState extends State<DayDetails> {
  late DateTime currentDate;
  List<ReminderModel> reminderList = [];

  void loadData() async {
    if (AuthServiceManager.checkIfLogged()) {
      ReminderDAOFB dao = ReminderDAOFB();
      reminderList =
          await dao.getByDay(DateFormat("yyyy-MM-dd").format(currentDate));
    } else {
      ReminderDAO dao = ReminderDAO();
      reminderList =
          await dao.getByDay(DateFormat("yyyy-MM-dd").format(currentDate));
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    currentDate = widget.initialDate;
    loadData();
  }

  void changeDay(int offset) {
    setState(() {
      currentDate = currentDate.add(Duration(days: offset));
      loadData();
    });
  }

  @override
  Widget build(BuildContext context) {
    String dayName = DateFormat.EEEE('es_ES').format(currentDate);
    String formattedDate = DateFormat('yyyy-MM-dd').format(currentDate);

    return Scaffold(
      appBar: UpperNavBar(pageName: "Recordatorios del día"),
      body: ScreenMargins(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Cabecera con fecha
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                      icon: Icon(
                        Icons.arrow_left_rounded,
                        size: 40,
                        color: Colors.black,
                      ),
                      onPressed: () => setState(() {
                            changeDay(-1);
                          })),
                  Text(
                    '$dayName, $formattedDate',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                      icon: Icon(
                        Icons.arrow_right_rounded,
                        size: 40,
                        color: Colors.black,
                      ),
                      onPressed: () => setState(() {
                            changeDay(1);
                          })),
                ],
              ),
              SizedBox(height: 16),

              //Text("Recordatorios",
              //  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
              SizedBox(height: 12),
              Container(
                  height: 500,
                  child: MinimizedReminderList(reminders: reminderList))
            ],
          ),
        ),
      ),
      bottomNavigationBar: LowerNavBar(),
      backgroundColor: Colors.transparent,
    );
  }
}
