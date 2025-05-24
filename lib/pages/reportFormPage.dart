import 'dart:io';
import 'package:diabetes_tfg_app/database/firebase/authServiceManager.dart';
import 'package:diabetes_tfg_app/database/firebase/dietLogDAO.dart';
import 'package:diabetes_tfg_app/database/firebase/exerciceLogDAO.dart';
import 'package:diabetes_tfg_app/database/firebase/glucoseLogDAO.dart';
import 'package:diabetes_tfg_app/database/firebase/insulinLogDAO.dart';
import 'package:diabetes_tfg_app/database/local/dietLogDAO.dart';
import 'package:diabetes_tfg_app/database/local/exerciceLogDAO.dart';
import 'package:diabetes_tfg_app/database/local/glucoseLogDAO.dart';
import 'package:diabetes_tfg_app/database/local/insulinLogDAO.dart';
import 'package:diabetes_tfg_app/models/InsulinLogModel.dart';
import 'package:diabetes_tfg_app/models/dietLogModel.dart';
import 'package:diabetes_tfg_app/models/exerciceLogModel.dart';
import 'package:diabetes_tfg_app/models/gluoseLogModel.dart';
import 'package:diabetes_tfg_app/pages/reportsPage.dart';
import 'package:diabetes_tfg_app/widgets/backgroundBase.dart';
import 'package:diabetes_tfg_app/widgets/drawerScaffold.dart';
import 'package:diabetes_tfg_app/widgets/lowerNavBar.dart';
import 'package:diabetes_tfg_app/widgets/upperNavBar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:permission_handler/permission_handler.dart';
import 'package:pdf/pdf.dart';

class ReportFormPage extends StatefulWidget {
  @override
  _ReportFormPageState createState() => _ReportFormPageState();
}

class _ReportFormPageState extends State<ReportFormPage> {
  String _rangoSeleccionado = '1 semana';
  DateTime _fechaInicio = DateTime.now();
  DateTime _fechaFin = DateTime.now();
  List<GlucoseLogModel> glucoseLogs = [];
  List<InsulinLogModel> insulinLogs = [];
  List<DietLogModel> dietLogs = [];
  List<ExerciceLogModel> exerciceLogs = [];
  double avgGlucose = 0;

  final List<String> _opciones = [
    '1 semana',
    '2 semanas',
    '1 mes',
    '3 meses',
    'Periodo personalizado'
  ];

  Future<File> createPDF(String fileName) async {
    final pdf = pw.Document();

    pw.TableRow _tableRow(String col1, String col2, String col3, String col4) {
      return pw.TableRow(
        children: [
          pw.Padding(
            padding: const pw.EdgeInsets.all(4),
            child: pw.Text(col1,
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
          ),
          pw.Padding(
            padding: const pw.EdgeInsets.all(4),
            child: pw.Text(col2),
          ),
          pw.Padding(
            padding: const pw.EdgeInsets.all(4),
            child: pw.Text(col3,
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
          ),
          pw.Padding(
            padding: const pw.EdgeInsets.all(4),
            child: pw.Text(col4),
          ),
        ],
      );
    }

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Título del Reporte
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text("Diabetes Report",
                      style: pw.TextStyle(
                          fontSize: 26, fontWeight: pw.FontWeight.bold)),
                  pw.Text("1–15 May 2025", style: pw.TextStyle(fontSize: 12)),
                ],
              ),
              pw.SizedBox(height: 8),
              // Nombre y médico
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text("John Smith\nBorn: February 5, 1870",
                      style: pw.TextStyle(fontSize: 12)),
                  pw.Text("Dr. A. Williams", style: pw.TextStyle(fontSize: 12)),
                ],
              ),
              pw.Divider(),

              // Summary
              pw.Text("Summary",
                  style: pw.TextStyle(
                      fontSize: 16, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 8),
              pw.Table(
                border: pw.TableBorder.all(),
                children: [
                  _tableRow("Average Glucose", "145 mg/dL", "Hypoglycemia",
                      "(<70 mg/dL)"),
                  _tableRow("Most frequent range", "70–180 mg/dL",
                      "Hyperglycemia", "(>180 mg/dL)"),
                  _tableRow("Total Insulin units", "35", "Physical activity",
                      "210 min"),
                  _tableRow("Hypoglycemia (< 70 mg)", "3",
                      "Average daily carbohydrates", "195 g"),
                  _tableRow(
                      "Observation", "Frequent nocturnal hypoglycemia", "", ""),
                ],
              ),
              pw.SizedBox(height: 20),

              // Placeholder para gráficos
              pw.Text("Daily Glucose Levels",
                  style: pw.TextStyle(
                      fontSize: 14, fontWeight: pw.FontWeight.bold)),
              pw.Container(
                height: 100,
                color: PdfColors.grey300,
                child: pw.Center(child: pw.Text("Graph Placeholder")),
              ),
              pw.SizedBox(height: 10),

              pw.Text("Hypoglycemia and Hyperglycemia",
                  style: pw.TextStyle(
                      fontSize: 14, fontWeight: pw.FontWeight.bold)),
              pw.Container(
                height: 100,
                color: PdfColors.grey300,
                child: pw.Center(child: pw.Text("Bar Chart Placeholder")),
              ),
              pw.SizedBox(height: 10),

              pw.Text("Injection Sites",
                  style: pw.TextStyle(
                      fontSize: 14, fontWeight: pw.FontWeight.bold)),
              pw.Container(
                height: 100,
                color: PdfColors.grey300,
                child: pw.Center(child: pw.Text("Body Diagram Placeholder")),
              ),
              pw.SizedBox(height: 10),

              pw.Text("Glucose vs. Carbohydrates",
                  style: pw.TextStyle(
                      fontSize: 14, fontWeight: pw.FontWeight.bold)),
              pw.Container(
                height: 100,
                color: PdfColors.grey300,
                child: pw.Center(child: pw.Text("Scatter Plot Placeholder")),
              ),
            ],
          );
        },
      ),
    );

    pdf.addPage(pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (pw.Context context) {
          return pw.Column(children: []);
        }));

    if (Platform.isAndroid) {
      var status = await Permission.storage.request();
      if (!status.isGranted) {
        throw Exception('Permiso de almacenamiento denegado');
      }
    }

    final output = await getApplicationDocumentsDirectory();
    final file = File("${output.path}/$fileName.pdf");

    await file.writeAsBytes(await pdf.save());
    return file;
  }

  void getDate() {
    switch (_rangoSeleccionado) {
      case '1 semana':
        _fechaInicio = DateTime.now().subtract(Duration(days: 7));
        _fechaFin = DateTime.now();
      case '2 semanas':
        _fechaInicio = DateTime.now().subtract(Duration(days: 14));
        _fechaFin = DateTime.now();
      case '1 mes':
        _fechaInicio = DateTime.now().subtract(Duration(days: 30));
        _fechaFin = DateTime.now();
      case '3 meses':
        _fechaInicio = DateTime.now().subtract(Duration(days: 90));
        _fechaFin = DateTime.now();
      default:
    }
  }

  Future<void> generatePDF() async {
    getDate();

    String formatedInitDate = DateFormat('yyyy-MM-dd').format(_fechaInicio);
    String formatedEndDate = DateFormat('yyyy-MM-dd').format(_fechaFin);

    if (AuthServiceManager.checkIfLogged()) {
      GlucoseLogDAOFB dao = GlucoseLogDAOFB();
      glucoseLogs =
          await dao.getCustomDateRangeLogs(formatedInitDate, formatedEndDate);
      InsulinLogDAOFB dao2 = InsulinLogDAOFB();
      insulinLogs =
          await dao2.getCustomDateRangeLogs(formatedInitDate, formatedEndDate);
      DietLogDAOFB dao3 = DietLogDAOFB();
      dietLogs =
          await dao3.getCustomDateRangeLogs(formatedInitDate, formatedEndDate);
      ExerciceLogDAOFB dao4 = ExerciceLogDAOFB();
      exerciceLogs =
          await dao4.getCustomDateRangeLogs(formatedInitDate, formatedEndDate);
    } else {
      GlucoseLogDAO dao = GlucoseLogDAO();
      glucoseLogs =
          await dao.getCustomDateRangeLogs(formatedInitDate, formatedEndDate);
      InsulinLogDAO dao2 = InsulinLogDAO();
      insulinLogs =
          await dao2.getCustomDateRangeLogs(formatedInitDate, formatedEndDate);
      DietLogDAO dao3 = DietLogDAO();
      dietLogs =
          await dao3.getCustomDateRangeLogs(formatedInitDate, formatedEndDate);
      ExerciceLogDAO dao4 = ExerciceLogDAO();
      exerciceLogs =
          await dao4.getCustomDateRangeLogs(formatedInitDate, formatedEndDate);
    }
    print(_rangoSeleccionado);
    _rangoSeleccionado == 'Periodo personalizado'
        ? print("$formatedInitDate, $formatedEndDate")
        : print("");

    print(glucoseLogs);
    print(insulinLogs);
    print(dietLogs);
    print(exerciceLogs);

    for (GlucoseLogModel log in glucoseLogs) {
      avgGlucose += log.glucoseValue;
    }
    avgGlucose = avgGlucose / glucoseLogs.length;

    await createPDF("nuevo_estilo2");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UpperNavBar(pageName: "Añadir registro de glucosa"),
      body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text('Generar reporte',
                    style:
                        TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                SizedBox(height: 25),
                Text('Selecciona el rango de datos:',
                    style:
                        TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                SizedBox(height: 15),
                DropdownButton<String>(
                  iconEnabledColor: Colors.black,
                  iconDisabledColor: Colors.black,
                  icon: Icon(Icons.arrow_drop_down_rounded),
                  borderRadius: BorderRadius.circular(12),
                  value: _rangoSeleccionado,
                  onChanged: (value) {
                    setState(() {
                      _rangoSeleccionado = value!;
                    });
                  },
                  items: _opciones
                      .map((f) => DropdownMenuItem<String>(
                            child: Text(f,
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold)),
                            value: f,
                          ))
                      .toList(),
                ),
                SizedBox(height: 20),
                _rangoSeleccionado == "Periodo personalizado"
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Fecha inicio:",
                              style: TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold)),
                          TextButton(
                              onPressed: () async {
                                DateTime? picked = await showDatePicker(
                                  context: context,
                                  initialDate: _fechaInicio,
                                  firstDate: DateTime(2000),
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
                                    _fechaInicio = picked;
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
                                  DateFormat('yyyy-MM-dd').format(_fechaInicio),
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              )),
                        ],
                      )
                    : SizedBox(),
                _rangoSeleccionado == "Periodo personalizado"
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Fecha fin:",
                              style: TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold)),
                          TextButton(
                              onPressed: () async {
                                DateTime? picked = await showDatePicker(
                                  context: context,
                                  initialDate: _fechaFin,
                                  firstDate: DateTime(2000),
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
                                    _fechaFin = picked;
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
                                  DateFormat('yyyy-MM-dd').format(_fechaFin),
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              )),
                        ],
                      )
                    : SizedBox(),
                Spacer(),
                ElevatedButton(
                  onPressed: () async {
                    await generatePDF();
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DrawerScaffold(
                                    child: BackgroundBase(
                                  child: ReportsPage(),
                                ))));
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.picture_as_pdf,
                        color: Colors.white,
                        size: 25,
                      ),
                      SizedBox(width: 10),
                      Text("Generar y guardar", style: TextStyle(fontSize: 22)),
                    ],
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 85, 42, 196),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 15),
                  ),
                ),
              ],
            ),
          )),
      bottomNavigationBar: LowerNavBar(selectedSection: "glucose"),
      backgroundColor: Colors.transparent,
    );
  }
}
