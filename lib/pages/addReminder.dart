import 'package:diabetes_tfg_app/database/firebase/authServiceManager.dart';
import 'package:diabetes_tfg_app/database/firebase/reminderDAO.dart';
import 'package:diabetes_tfg_app/database/local/reminderDAO.dart';
import 'package:diabetes_tfg_app/models/reminderModel.dart';
import 'package:diabetes_tfg_app/pages/exerciceAndHealthMainPage.dart';
import 'package:diabetes_tfg_app/widgets/backgroundBase.dart';
import 'package:diabetes_tfg_app/widgets/drawerScaffold.dart';
import 'package:diabetes_tfg_app/widgets/lowerNavBar.dart';
import 'package:diabetes_tfg_app/widgets/screenMargins.dart';
import 'package:diabetes_tfg_app/widgets/upperNavBar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddReminder extends StatefulWidget {
  final String initialId;
  const AddReminder({required this.initialId});
  @override
  _AddReminderState createState() => _AddReminderState();
}

class _AddReminderState extends State<AddReminder> {
  DateTime selectedDate = DateTime.now();
  TextEditingController titleController = TextEditingController();
  TextEditingController customDaysController = TextEditingController();
  bool repeat = false;
  String repeatFrequency = 'Nunca';
  final TextEditingController hourController = TextEditingController();
  final TextEditingController minuteController = TextEditingController();

  final List<String> frequencies = [
    'Nunca',
    'Cada día',
    'Cada semana',
    'Cada mes',
    'Cada 3 meses',
    'Personalizado'
  ];

  String getTime() {
    return "${hourController.text}:${minuteController.text}";
  }

  void loadData() async {
    if (AuthServiceManager.checkIfLogged()) {
      ReminderDAOFB dao = ReminderDAOFB();
      List<ReminderModel> log = await dao.getById(widget.initialId);
      titleController.text = log.first.title;
      selectedDate = DateTime.parse(log.first.date);
      hourController.text = log.first.time.split(":")[0];
      minuteController.text = log.first.time.split(":")[1];
      repeat = log.first.repeat;
      titleController.text = log.first.repeatConfig;
    } else {
      ReminderDAO dao = ReminderDAO();
      List<ReminderModel> log = await dao.getById(widget.initialId);
      titleController.text = log.first.title;
      selectedDate = DateTime.parse(log.first.date);
      hourController.text = log.first.time.split(":")[0];
      minuteController.text = log.first.time.split(":")[1];
      repeat = log.first.repeat;
      repeatFrequency = log.first.repeatConfig;
    }
    setState(() {});
  }

  void saveLog() async {
    if (AuthServiceManager.checkIfLogged()) {
      if (widget.initialId != "") {
        ReminderDAOFB dao = ReminderDAOFB();
        List<ReminderModel> log = await dao.getById(widget.initialId);
        log.first.title = titleController.text;
        log.first.date = DateFormat("yyyy-MM-dd").format(selectedDate);
        log.first.time = getTime();
        log.first.repeat = repeat;
        log.first.repeatConfig = repeatFrequency;
        await dao.update(log.first);
      } else {
        ReminderModel reminder = ReminderModel.newEntity(
            AuthServiceManager.getCurrentUserUID(),
            titleController.text,
            getTime(),
            DateFormat("yyyy-MM-dd").format(selectedDate),
            repeat,
            repeatFrequency);
        ReminderDAOFB dao = ReminderDAOFB();
        dao.insert(reminder);
      }
    } else {
      if (widget.initialId != "") {
        ReminderDAO dao = ReminderDAO();
        List<ReminderModel> log = await dao.getById(widget.initialId);
        log.first.title = titleController.text;
        log.first.date = DateFormat("yyyy-MM-dd").format(selectedDate);
        log.first.time = getTime();
        log.first.repeat = repeat;
        log.first.repeatConfig = repeatFrequency;
        await dao.update(log.first);
      } else {
        ReminderModel reminder = ReminderModel.newEntity(
            "localUser",
            titleController.text,
            getTime(),
            DateFormat("yyyy-MM-dd").format(selectedDate),
            repeat,
            repeatFrequency);
        ReminderDAOFB dao = ReminderDAOFB();
        dao.insert(reminder);
      }
    }
  }

  void deleteLog() async {
    if (AuthServiceManager.checkIfLogged()) {
      ReminderDAOFB dao = ReminderDAOFB();
      List<ReminderModel> log = await dao.getById(widget.initialId);
      dao.delete(log.first);
    } else {
      ReminderDAO dao = ReminderDAO();
      List<ReminderModel> log = await dao.getById(widget.initialId);
      dao.delete(log.first);
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.initialId != "") {
      loadData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UpperNavBar(pageName: "Añadir recordatorio"),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: ScreenMargins(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Título
                  Row(
                    children: [
                      Text("Título:",
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold)),
                      SizedBox(width: 16),
                      Expanded(
                        child: TextField(
                          controller: titleController,
                          decoration: InputDecoration(
                            labelText: 'Título',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  // Fecha
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Fecha:",
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold)),
                      TextButton(
                          onPressed: () async {
                            DateTime? picked = await showDatePicker(
                              context: context,
                              initialDate: selectedDate,
                              firstDate:
                                  DateTime.now().subtract(Duration(days: 1)),
                              lastDate: DateTime(2100),
                              builder: (context, child) {
                                return Theme(
                                  data: Theme.of(context).copyWith(
                                    colorScheme: ColorScheme.light(
                                      primary: Color.fromARGB(255, 85, 42,
                                          196), // Color de encabezado y botones
                                      onPrimary:
                                          Colors.white, // Texto en botones
                                      onSurface:
                                          Colors.black, // Texto principal
                                    ),
                                    dialogBackgroundColor:
                                        Colors.white, // Fondo del diálogo
                                  ),
                                  child: child!,
                                );
                              },
                            );

                            if (picked != null) {
                              setState(() {
                                selectedDate = picked;
                              });
                            }
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              DateFormat('yyyy-MM-dd').format(selectedDate),
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          )),
                    ],
                  ),
                  SizedBox(height: 20),

                  Row(
                    children: [
                      Text(
                        "Hora",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(width: 12),
                      Container(
                        height: 70,
                        width: 80,
                        child: TextFormField(
                          controller: hourController,
                          maxLength: 2,
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          textAlignVertical: TextAlignVertical.center,
                          style: TextStyle(
                              fontSize: 35, fontWeight: FontWeight.bold),
                          decoration: InputDecoration(
                            labelText: "Hora",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            counterText: "",
                          ),
                        ),
                      ),
                      SizedBox(width: 8),
                      Text(":",
                          style: TextStyle(
                              fontSize: 48, fontWeight: FontWeight.bold)),
                      SizedBox(width: 8),
                      Container(
                        height: 70,
                        width: 80,
                        child: TextFormField(
                          controller: minuteController,
                          maxLength: 2,
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          textAlignVertical: TextAlignVertical.center,
                          style: TextStyle(
                              fontSize: 35, fontWeight: FontWeight.bold),
                          decoration: InputDecoration(
                            labelText: "Minuto",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            counterText: "",
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),

                  // Repetir periódicamente
                  Row(
                    children: [
                      Checkbox(
                        checkColor: Colors.white,
                        activeColor: Color.fromARGB(255, 85, 42, 196),
                        value: repeat,
                        onChanged: (value) {
                          setState(() {
                            repeat = value!;
                            if (!repeat) {
                              repeatFrequency = "Nunca";
                            }
                          });
                        },
                      ),
                      Text('Repetir periódicamente',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                    ],
                  ),

                  // Frecuencia (si repetir está activado)
                  if (repeat) ...[
                    Row(
                      children: [
                        Text('Repetir:',
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold)),
                        SizedBox(width: 16),
                        DropdownButton<String>(
                          iconEnabledColor: Colors.black,
                          iconDisabledColor: Colors.black,
                          icon: Icon(Icons.arrow_drop_down_rounded),
                          borderRadius: BorderRadius.circular(12),
                          value: repeatFrequency,
                          onChanged: (value) {
                            setState(() {
                              repeatFrequency = value!;
                            });
                          },
                          items: frequencies
                              .map((f) => DropdownMenuItem<String>(
                                    child: Text(f,
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold)),
                                    value: f,
                                  ))
                              .toList(),
                        ),
                      ],
                    ),

                    // Campo extra si es personalizado
                    if (repeatFrequency == 'Personalizado')
                      Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: TextField(
                          controller: customDaysController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'Cada cuántos días se repite',
                            border: OutlineInputBorder(),
                            hintText: 'Ej: 10',
                          ),
                        ),
                      ),
                  ],

                  SizedBox(height: 24),

                  // Botón Confirmar
                  ElevatedButton(
                    onPressed: () {
                      String titulo = titleController.text;
                      int? customDays = repeatFrequency == 'Personalizado'
                          ? int.tryParse(customDaysController.text)
                          : null;

                      // Validación personalizada
                      if (repeatFrequency == 'Personalizado' &&
                          (customDays == null || customDays <= 0)) {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            backgroundColor: Color.fromARGB(255, 232, 80, 69),
                            title: Text(
                              'Numero de dias vacio',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                            content: Text(
                              "Introduzca un valor valido en el numero de dias a repetir el recordatorio.",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 16),
                            ),
                            actions: [
                              TextButton(
                                child: Text(
                                  'OK',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                ),
                                onPressed: () => Navigator.of(context).pop(),
                              ),
                            ],
                          ),
                        );
                      } else {
                        print("Título: $titulo");
                        print("Fecha: ${selectedDate.toString()}");
                        print("Hora: ${getTime()}");
                        print("Repetir: $repeat -> $repeatFrequency");
                        if (repeatFrequency == 'Personalizado') {
                          print("Días personalizados: $customDays");
                        }
                        setState(() {
                          saveLog();
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => DrawerScaffold(
                                      child: BackgroundBase(
                                          child:
                                              ExerciceAndHealthMainPage()))));
                        });
                      }
                    },
                    child: Text("Confirmar", style: TextStyle(fontSize: 18)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 85, 42, 196),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding:
                          EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    ),
                  ),
                  SizedBox(height: 16),
                  widget.initialId != ""
                      ? ElevatedButton(
                          onPressed: () {
                            deleteLog();
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => DrawerScaffold(
                                        child: BackgroundBase(
                                            child:
                                                ExerciceAndHealthMainPage()))));
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: EdgeInsets.symmetric(
                                horizontal: 40, vertical: 15),
                          ),
                          child:
                              Text("Eliminar", style: TextStyle(fontSize: 18)),
                        )
                      : SizedBox()
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: LowerNavBar(selectedSection: "exercice"),
      backgroundColor: Colors.transparent,
    );
  }
}
