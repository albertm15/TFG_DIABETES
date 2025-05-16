import 'package:diabetes_tfg_app/pages/calendarPage.dart';
import 'package:diabetes_tfg_app/widgets/backgroundBase.dart';
import 'package:diabetes_tfg_app/widgets/drawerScaffold.dart';
import 'package:flutter/material.dart';

class WeeklyCalendar extends StatefulWidget {
  @override
  _WeeklyCalendarState createState() => _WeeklyCalendarState();
}

class _WeeklyCalendarState extends State<WeeklyCalendar> {
  DateTime selectedDate = DateTime.now();

  List<DateTime> getCurrentWeek() {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    return List.generate(7, (index) => startOfWeek.add(Duration(days: index)));
  }

  @override
  Widget build(BuildContext context) {
    final week = getCurrentWeek();
    final dayLetters = ['L', 'Ma', 'Mi', 'J', 'V', 'S', 'D'];

    return GestureDetector(
      onTap: () {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => DrawerScaffold(
                    child: BackgroundBase(child: CalendarPage()))));
      },
      child: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
            border: Border.all(),
            borderRadius: BorderRadius.circular(20),
            //color: Colors.white
            color: Colors.transparent),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(7, (index) {
            final day = week[index];
            final isSelected = day.day == selectedDate.day &&
                day.month == selectedDate.month &&
                day.year == selectedDate.year;

            return GestureDetector(
              onTap: () {
                setState(() {
                  selectedDate = day;
                });
              },
              child: Column(
                children: [
                  Text(
                    dayLetters[index],
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Container(
                    width: 30,
                    height: 30,
                    margin: EdgeInsets.only(top: 4),
                    decoration: BoxDecoration(
                      color:
                          isSelected ? Colors.deepPurple : Colors.transparent,
                      border: Border.all(
                        color:
                            isSelected ? Colors.deepPurple : Colors.transparent,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '${day.day}',
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.black,
                      ),
                    ),
                  )
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}
