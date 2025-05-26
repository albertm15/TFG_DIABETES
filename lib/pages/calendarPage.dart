import 'package:diabetes_tfg_app/database/firebase/authServiceManager.dart';
import 'package:diabetes_tfg_app/database/firebase/reminderDAO.dart';
import 'package:diabetes_tfg_app/database/local/reminderDAO.dart';
import 'package:diabetes_tfg_app/models/reminderModel.dart';
import 'package:diabetes_tfg_app/pages/addReminder.dart';
import 'package:diabetes_tfg_app/pages/dayDetailed.dart';
import 'package:diabetes_tfg_app/widgets/backgroundBase.dart';
import 'package:diabetes_tfg_app/widgets/drawerScaffold.dart';
import 'package:diabetes_tfg_app/widgets/lowerNavBar.dart';
import 'package:diabetes_tfg_app/widgets/upperNavBar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UpperNavBar(pageName: "Calendario"),
      body: BackgroundBase(child: Center(child: _CalendarPageWidget())),
      bottomNavigationBar: LowerNavBar(selectedSection: "exercice"),
    );
  }
}

class _CalendarPageWidget extends StatefulWidget {
  @override
  _CalendarPageWidgetState createState() => _CalendarPageWidgetState();
}

class _CalendarPageWidgetState extends State<_CalendarPageWidget> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.month;
  List<ReminderModel> reminderList = [];
  Map<DateTime, List<String>> events = {};
  final DateFormat formatter = DateFormat('yyyy-MM-dd');

  void loadData() async {
    if (AuthServiceManager.checkIfLogged()) {
      ReminderDAOFB dao = ReminderDAOFB();
      reminderList = await dao.getAll();
    } else {
      ReminderDAO dao = ReminderDAO();
      reminderList = await dao.getAll();
    }

    setState(() {
      for (var reminder in reminderList) {
        DateTime parsed = formatter.parse(reminder.date);
        DateTime normalizedDate =
            DateTime(parsed.year, parsed.month, parsed.day);
        if (events[normalizedDate] == null) {
          events[normalizedDate] = [];
        }
        events[normalizedDate]!.add(reminder.title);
      }
    });

    print(events);
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: TableCalendar(
            locale: 'es_ES',
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            eventLoader: (day) {
              return events[DateTime(day.year, day.month, day.day)] ?? [];
            },
            calendarBuilders: CalendarBuilders(
              markerBuilder: (context, date, eventsForDay) {
                if (eventsForDay.isNotEmpty) {
                  return Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      width: 6,
                      height: 6,
                      margin: const EdgeInsets.only(bottom: 4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isSameDay(date, DateTime.now())
                            ? Colors.white
                            : Colors.deepPurpleAccent,
                      ),
                    ),
                  );
                }
                return SizedBox.shrink();
              },
            ),
            calendarFormat: _calendarFormat,
            selectedDayPredicate: (day) {
              return _selectedDay != null && isSameDay(_selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;

                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => DrawerScaffold(
                                child: BackgroundBase(
                                    child: DayDetails(
                              initialDate: selectedDay,
                            )))));
              });
              print("Día seleccionado: $selectedDay");
            },
            headerStyle: HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
            ),
            calendarStyle: CalendarStyle(
              selectedDecoration: BoxDecoration(
                color: Colors.deepPurple,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(10),
              ),
              todayDecoration: BoxDecoration(
                color: Colors.deepPurpleAccent,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(10),
              ),
              markerDecoration: BoxDecoration(
                color: isSameDay(_focusedDay, DateTime.now())
                    ? Colors.white
                    : Colors.deepPurpleAccent,
                shape: BoxShape.circle,
              ),
              defaultDecoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(10),
              ),
              weekendDecoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(10),
              ),
              outsideDecoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(10),
              ),
              disabledDecoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
        SizedBox(height: 50),
        ElevatedButton(
          onPressed: () {
            setState(() {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DrawerScaffold(
                          child: BackgroundBase(
                              child: AddReminder(initialId: "")))));
            });
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Color.fromARGB(255, 85, 42, 196),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
          ),
          child: Text("Añadir recordatorio", style: TextStyle(fontSize: 18)),
        ),
      ],
    );
  }
}
