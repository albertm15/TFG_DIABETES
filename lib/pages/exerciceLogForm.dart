import 'package:diabetes_tfg_app/widgets/lowerNavBar.dart';
import 'package:diabetes_tfg_app/widgets/screenMargins.dart';
import 'package:diabetes_tfg_app/widgets/upperNavBar.dart';
import 'package:flutter/material.dart';

class ExerciseLogForm extends StatefulWidget {
  const ExerciseLogForm({super.key});

  @override
  State<ExerciseLogForm> createState() => _ExerciseLogFormState();
}

class _ExerciseLogFormState extends State<ExerciseLogForm> {
  final TextEditingController beforeController = TextEditingController();
  final TextEditingController afterController = TextEditingController();

  Duration duration = Duration(minutes: 30);
  String selectedActivity = 'Caminar';

  final List<Map<String, dynamic>> activities = [
    {'label': 'Caminar', 'icon': Icons.directions_walk},
    {'label': 'Ciclismo', 'icon': Icons.directions_bike},
    {'label': 'Pesas', 'icon': Icons.fitness_center},
    {'label': 'Otro', 'icon': Icons.more_horiz},
  ];

  void pickDuration() async {
    final picked = await showTimePicker(
      context: context,
      initialTime:
          TimeOfDay(hour: duration.inHours, minute: duration.inMinutes % 60),
    );
    if (picked != null) {
      setState(() {
        duration = Duration(hours: picked.hour, minutes: picked.minute);
      });
    }
  }

  void submitForm() {
    print("Actividad: $selectedActivity");
    print("Duración: ${duration.inHours}h ${duration.inMinutes % 60}min");
    print("Antes: ${beforeController.text}");
    print("Después: ${afterController.text}");
    // Aquí podrías guardar el log o subirlo a base de datos
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UpperNavBar(pageName: "Añadir registro de ejercicio"),
      body: ScreenMargins(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Selección de actividad
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: activities.map((activity) {
                    final isSelected = selectedActivity == activity['label'];
                    return GestureDetector(
                      onTap: () =>
                          setState(() => selectedActivity = activity['label']),
                      child: Container(
                        height: 70,
                        width: 70,
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Color(0xFF3C37FF)
                              : Color.fromARGB(255, 118, 118, 118),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            Icon(
                              activity['icon'],
                              size: 32,
                              color: Colors.white,
                            ),
                            SizedBox(height: 4),
                            Text(activity['label'],
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white,
                                )),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),

                SizedBox(height: 24),

                // Duración
                Center(
                  child: GestureDetector(
                    onTap: pickDuration,
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black54),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${duration.inHours.toString().padLeft(2, '0')}h : ${(duration.inMinutes % 60).toString().padLeft(2, '0')}min',
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 24),

                // Sensaciones antes
                Text("Sensaciones antes del ejercicio",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                TextField(
                  controller: beforeController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: "Me he sentido...",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                ),

                SizedBox(height: 24),

                // Sensaciones después
                Text("Sensaciones después del ejercicio",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                TextField(
                  controller: afterController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: "Me he sentido...",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                ),

                SizedBox(height: 24),

                // Botón añadir
                ElevatedButton(
                  onPressed: submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 85, 42, 196),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  ),
                  child: Text("Añadir", style: TextStyle(fontSize: 22)),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: LowerNavBar(),
      backgroundColor: Colors.transparent,
    );
  }
}
