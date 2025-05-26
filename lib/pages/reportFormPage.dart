import 'dart:io';
import 'package:diabetes_tfg_app/database/firebase/authServiceManager.dart';
import 'package:diabetes_tfg_app/database/firebase/dietLogDAO.dart';
import 'package:diabetes_tfg_app/database/firebase/exerciceLogDAO.dart';
import 'package:diabetes_tfg_app/database/firebase/glucoseLogDAO.dart';
import 'package:diabetes_tfg_app/database/firebase/insulinLogDAO.dart';
import 'package:diabetes_tfg_app/database/firebase/userDAO.dart';
import 'package:diabetes_tfg_app/database/local/dietLogDAO.dart';
import 'package:diabetes_tfg_app/database/local/exerciceLogDAO.dart';
import 'package:diabetes_tfg_app/database/local/glucoseLogDAO.dart';
import 'package:diabetes_tfg_app/database/local/insulinLogDAO.dart';
import 'package:diabetes_tfg_app/database/local/userDAO.dart';
import 'package:diabetes_tfg_app/models/InsulinLogModel.dart';
import 'package:diabetes_tfg_app/models/dietLogModel.dart';
import 'package:diabetes_tfg_app/models/exerciceLogModel.dart';
import 'package:diabetes_tfg_app/models/gluoseLogModel.dart';
import 'package:diabetes_tfg_app/models/userModel.dart';
import 'package:diabetes_tfg_app/pages/reportsPage.dart';
import 'package:diabetes_tfg_app/widgets/backgroundBase.dart';
import 'package:diabetes_tfg_app/widgets/drawerScaffold.dart';
import 'package:diabetes_tfg_app/widgets/lowerNavBar.dart';
import 'package:diabetes_tfg_app/widgets/upperNavBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
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
  int minGlucose = 0;
  int maxGlucose = 0;
  int numHypoglucemias = 0;
  int numHyperglucemias = 0;
  int numInjections = 0;
  double insulinUnitsConsumed = 0;
  int physicalActivity = 0;
  double avgDailyCarbs = 0;
  double avgDailyInsulinUnits = 0;
  String userName = "";
  String height = "";
  String weight = "";
  String typoOfDiabetes = "";
  int numHigh = 0;
  int numNormal = 0;
  int numLow = 0;
  List<int> locationsCount = [0, 0, 0, 0, 0, 0, 0];

  final List<String> _opciones = [
    '1 semana',
    '2 semanas',
    '1 mes',
    '3 meses',
    'Periodo personalizado'
  ];

  String generatePdfName() {
    final now = DateTime.now();
    final formatter = DateFormat('yyyyMMdd_HHmmss');
    final formatted = formatter.format(now);
    return 'PDF_$formatted.pdf';
  }

  Future<File> createPDF(String fileName) async {
    final Uint8List imageBytes = await rootBundle
        .load('assets/images/Diet_Image.png')
        .then((data) => data.buffer.asUint8List());
    final pw.ImageProvider imageProvider = pw.MemoryImage(imageBytes);
    final Uint8List imageBytes2 = await rootBundle
        .load('assets/images/arrow_upwards.png')
        .then((data) => data.buffer.asUint8List());
    final pw.ImageProvider imageProvider2 = pw.MemoryImage(imageBytes2);
    final Uint8List imageBytes3 = await rootBundle
        .load('assets/images/arrow_right.png')
        .then((data) => data.buffer.asUint8List());
    final pw.ImageProvider imageProvider3 = pw.MemoryImage(imageBytes3);
    final Uint8List imageBytes4 = await rootBundle
        .load('assets/images/arrow_downwards.png')
        .then((data) => data.buffer.asUint8List());
    final pw.ImageProvider imageProvider4 = pw.MemoryImage(imageBytes4);
    final Uint8List imageBytes5 = await rootBundle
        .load('assets/images/human_body_coloured.png')
        .then((data) => data.buffer.asUint8List());
    final pw.ImageProvider imageProvider5 = pw.MemoryImage(imageBytes5);

    final pdf = pw.Document();

    pw.TableRow _tableRow(String col1, String col2, String col3, String col4) {
      return pw.TableRow(
        children: [
          pw.Padding(
            padding: const pw.EdgeInsets.all(4),
            child: pw.Text(col1,
                style:
                    pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 13)),
          ),

          /// col2 con línea derecha
          pw.Container(
            decoration: pw.BoxDecoration(
              border: pw.Border(
                right: pw.BorderSide(color: PdfColors.grey, width: 0.5),
              ),
            ),
            padding: const pw.EdgeInsets.all(4),
            child: pw.Text(col2, style: pw.TextStyle(fontSize: 13)),
          ),

          /// col3
          pw.Padding(
            padding: const pw.EdgeInsets.all(4),
            child: pw.Text(col3,
                style:
                    pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 13)),
          ),

          /// col4
          pw.Padding(
            padding: const pw.EdgeInsets.all(4),
            child: pw.Text(col4, style: pw.TextStyle(fontSize: 13)),
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
                  pw.Text("Reporte de diabetes",
                      style: pw.TextStyle(
                          fontSize: 26, fontWeight: pw.FontWeight.bold)),
                  pw.Image(
                    imageProvider,
                    width: 40,
                    height: 40,
                  ),
                  pw.Text(
                      "${DateFormat('yyyy/MM/dd').format(_fechaInicio)} - ${DateFormat('yyyy/MM/dd').format(_fechaFin)}",
                      style: pw.TextStyle(fontSize: 12)),
                ],
              ),
              pw.SizedBox(height: 8),
              // Nombre y médico
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text("Paciente: $userName",
                      style: pw.TextStyle(fontSize: 15)),
                  pw.Text("Tipo de diabetes: $typoOfDiabetes",
                      style: pw.TextStyle(fontSize: 15)),
                  pw.Text("Peso: $weight Kg",
                      style: pw.TextStyle(fontSize: 15)),
                  pw.Text("Altura: $height cm",
                      style: pw.TextStyle(fontSize: 15)),
                ],
              ),
              pw.Divider(),

              // Summary
              pw.Text("Resumen",
                  style: pw.TextStyle(
                      fontSize: 18, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 8),
              pw.Table(
                border: pw.TableBorder(
                  horizontalInside:
                      pw.BorderSide(color: PdfColors.grey, width: 0.5),
                  top: pw.BorderSide.none,
                  bottom: pw.BorderSide.none,
                  left: pw.BorderSide.none,
                  right: pw.BorderSide.none,
                  verticalInside: pw.BorderSide.none,
                ),
                children: [
                  _tableRow(
                      "Glucose media",
                      "${avgGlucose.toStringAsFixed(2)} mg/dL",
                      "Glucose minima",
                      "${minGlucose} mg/dL"),
                  _tableRow("Glucose maxima", "${maxGlucose} mg/dL",
                      "Actividad física", "${physicalActivity} mins."),
                  _tableRow(
                      "Insulina total consumida",
                      "${insulinUnitsConsumed.toStringAsFixed(2)} U.",
                      "Numero de inyecciones",
                      "${numInjections}"),
                  _tableRow("Hipoglucemias", "${numHypoglucemias}",
                      "Hiperglucemias", "${numHyperglucemias}"),
                  _tableRow(
                      "Carbohidratos medios diarios",
                      "${avgDailyCarbs.toStringAsFixed(2)}",
                      "Insulina media diarios",
                      "${avgDailyInsulinUnits.toStringAsFixed(2)}"),
                ],
              ),
              pw.SizedBox(height: 20),

              // Placeholder para gráficos
              pw.Text("Categoria de glucosa",
                  style: pw.TextStyle(
                      fontSize: 18, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 10),
              pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
                  children: [
                    pw.Column(children: [
                      pw.Text("Elevado",
                          style: pw.TextStyle(
                              fontSize: 30, fontWeight: pw.FontWeight.bold)),
                      pw.SizedBox(height: 5),
                      pw.Image(imageProvider2, width: 60, height: 60),
                      pw.SizedBox(height: 5),
                      pw.Text(
                          "${((numHigh / (numHigh + numNormal + numLow)) * 100).toStringAsFixed(2)}%",
                          style: pw.TextStyle(fontSize: 28)),
                      pw.SizedBox(height: 5),
                      pw.Text("${numHigh}", style: pw.TextStyle(fontSize: 24)),
                    ]),
                    pw.Column(children: [
                      pw.Text("Normal",
                          style: pw.TextStyle(
                              fontSize: 30, fontWeight: pw.FontWeight.bold)),
                      pw.SizedBox(height: 5),
                      pw.Image(imageProvider3, width: 60, height: 60),
                      pw.SizedBox(height: 5),
                      pw.Text(
                          "${((numNormal / (numHigh + numNormal + numLow)) * 100).toStringAsFixed(2)}%",
                          style: pw.TextStyle(fontSize: 28)),
                      pw.SizedBox(height: 5),
                      pw.Text("${numNormal}",
                          style: pw.TextStyle(fontSize: 24)),
                    ]),
                    pw.Column(children: [
                      pw.Text("Bajo",
                          style: pw.TextStyle(
                              fontSize: 30, fontWeight: pw.FontWeight.bold)),
                      pw.SizedBox(height: 5),
                      pw.Image(imageProvider4, width: 60, height: 60),
                      pw.SizedBox(height: 5),
                      pw.Text(
                          "${((numLow / (numHigh + numNormal + numLow)) * 100).toStringAsFixed(2)}%",
                          style: pw.TextStyle(fontSize: 28)),
                      pw.SizedBox(height: 5),
                      pw.Text("${numLow}", style: pw.TextStyle(fontSize: 24)),
                    ]),
                  ]),
              pw.SizedBox(height: 20),
              pw.Text("Zonas inyectadas",
                  style: pw.TextStyle(
                      fontSize: 18, fontWeight: pw.FontWeight.bold)),
              pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
                  children: [
                    pw.Image(imageProvider5, height: 270, width: 200),
                    pw.SizedBox(width: 10),
                    pw.Column(children: [
                      pw.Container(
                        decoration: pw.BoxDecoration(
                          border: pw.Border(
                            bottom: pw.BorderSide(
                                color: PdfColors.grey, width: 0.5),
                          ),
                        ),
                        padding: const pw.EdgeInsets.all(4),
                        child: pw.Row(
                            crossAxisAlignment: pw.CrossAxisAlignment.center,
                            children: [
                              pw.Container(
                                  height: 10,
                                  width: 10,
                                  color: PdfColors.greenAccent),
                              pw.SizedBox(width: 8),
                              pw.Text("Brazo izquierdo: ",
                                  style: pw.TextStyle(
                                      fontSize: 18,
                                      fontWeight: pw.FontWeight.bold)),
                              pw.Text("${locationsCount[0]}",
                                  style: pw.TextStyle(fontSize: 16)),
                              pw.SizedBox(width: 12),
                              pw.Text(
                                  "${((locationsCount[0] / numInjections) * 100).toStringAsFixed(2)}%",
                                  style: pw.TextStyle(
                                      fontSize: 18,
                                      fontWeight: pw.FontWeight.bold)),
                            ]),
                      ),
                      pw.Container(
                        decoration: pw.BoxDecoration(
                          border: pw.Border(
                            bottom: pw.BorderSide(
                                color: PdfColors.grey, width: 0.5),
                          ),
                        ),
                        padding: const pw.EdgeInsets.all(4),
                        child: pw.Row(
                            crossAxisAlignment: pw.CrossAxisAlignment.center,
                            children: [
                              pw.Container(
                                  height: 10,
                                  width: 10,
                                  color: PdfColors.amberAccent),
                              pw.SizedBox(width: 8),
                              pw.Text("Brazo derecho: ",
                                  style: pw.TextStyle(
                                      fontSize: 18,
                                      fontWeight: pw.FontWeight.bold)),
                              pw.Text("${locationsCount[1]}",
                                  style: pw.TextStyle(fontSize: 16)),
                              pw.SizedBox(width: 12),
                              pw.Text(
                                  "${((locationsCount[1] / numInjections) * 100).toStringAsFixed(2)}%",
                                  style: pw.TextStyle(
                                      fontSize: 18,
                                      fontWeight: pw.FontWeight.bold)),
                            ]),
                      ),
                      pw.Container(
                        decoration: pw.BoxDecoration(
                          border: pw.Border(
                            bottom: pw.BorderSide(
                                color: PdfColors.grey, width: 0.5),
                          ),
                        ),
                        padding: const pw.EdgeInsets.all(4),
                        child: pw.Row(
                            crossAxisAlignment: pw.CrossAxisAlignment.center,
                            children: [
                              pw.Container(
                                  height: 10,
                                  width: 10,
                                  color: PdfColors.blueAccent),
                              pw.SizedBox(width: 8),
                              pw.Text("Gluteo izquierdo: ",
                                  style: pw.TextStyle(
                                      fontSize: 18,
                                      fontWeight: pw.FontWeight.bold)),
                              pw.Text("${locationsCount[2]}",
                                  style: pw.TextStyle(fontSize: 16)),
                              pw.SizedBox(width: 12),
                              pw.Text(
                                  "${((locationsCount[2] / numInjections) * 100).toStringAsFixed(2)}%",
                                  style: pw.TextStyle(
                                      fontSize: 18,
                                      fontWeight: pw.FontWeight.bold)),
                            ]),
                      ),
                      pw.Container(
                        decoration: pw.BoxDecoration(
                          border: pw.Border(
                            bottom: pw.BorderSide(
                                color: PdfColors.grey, width: 0.5),
                          ),
                        ),
                        padding: const pw.EdgeInsets.all(4),
                        child: pw.Row(
                            crossAxisAlignment: pw.CrossAxisAlignment.center,
                            children: [
                              pw.Container(
                                  height: 10,
                                  width: 10,
                                  color: PdfColors.purple),
                              pw.SizedBox(width: 8),
                              pw.Text("Gluteo derecho: ",
                                  style: pw.TextStyle(
                                      fontSize: 18,
                                      fontWeight: pw.FontWeight.bold)),
                              pw.Text("${locationsCount[3]}",
                                  style: pw.TextStyle(fontSize: 16)),
                              pw.SizedBox(width: 12),
                              pw.Text(
                                  "${((locationsCount[3] / numInjections) * 100).toStringAsFixed(2)}%",
                                  style: pw.TextStyle(
                                      fontSize: 18,
                                      fontWeight: pw.FontWeight.bold)),
                            ]),
                      ),
                      pw.Container(
                        decoration: pw.BoxDecoration(
                          border: pw.Border(
                            bottom: pw.BorderSide(
                                color: PdfColors.grey, width: 0.5),
                          ),
                        ),
                        padding: const pw.EdgeInsets.all(4),
                        child: pw.Row(
                            crossAxisAlignment: pw.CrossAxisAlignment.center,
                            children: [
                              pw.Container(
                                  height: 10,
                                  width: 10,
                                  color: PdfColors.cyanAccent),
                              pw.SizedBox(width: 8),
                              pw.Text("Muslo izquierdo: ",
                                  style: pw.TextStyle(
                                      fontSize: 18,
                                      fontWeight: pw.FontWeight.bold)),
                              pw.Text("${locationsCount[4]}",
                                  style: pw.TextStyle(fontSize: 16)),
                              pw.SizedBox(width: 12),
                              pw.Text(
                                  "${((locationsCount[4] / numInjections) * 100).toStringAsFixed(2)}%",
                                  style: pw.TextStyle(
                                      fontSize: 18,
                                      fontWeight: pw.FontWeight.bold)),
                            ]),
                      ),
                      pw.Container(
                        decoration: pw.BoxDecoration(
                          border: pw.Border(
                            bottom: pw.BorderSide(
                                color: PdfColors.grey, width: 0.5),
                          ),
                        ),
                        padding: const pw.EdgeInsets.all(4),
                        child: pw.Row(
                            crossAxisAlignment: pw.CrossAxisAlignment.center,
                            children: [
                              pw.Container(
                                  height: 10,
                                  width: 10,
                                  color: PdfColors.deepOrangeAccent),
                              pw.SizedBox(width: 8),
                              pw.Text("Muslo derecho: ",
                                  style: pw.TextStyle(
                                      fontSize: 18,
                                      fontWeight: pw.FontWeight.bold)),
                              pw.Text("${locationsCount[5]}",
                                  style: pw.TextStyle(fontSize: 16)),
                              pw.SizedBox(width: 12),
                              pw.Text(
                                  "${((locationsCount[5] / numInjections) * 100).toStringAsFixed(2)}%",
                                  style: pw.TextStyle(
                                      fontSize: 18,
                                      fontWeight: pw.FontWeight.bold)),
                            ]),
                      ),
                      pw.Container(
                        padding: const pw.EdgeInsets.all(4),
                        child: pw.Row(
                            crossAxisAlignment: pw.CrossAxisAlignment.center,
                            children: [
                              pw.Container(
                                  height: 10, width: 10, color: PdfColors.red),
                              pw.SizedBox(width: 8),
                              pw.Text("Barriga: ",
                                  style: pw.TextStyle(
                                      fontSize: 18,
                                      fontWeight: pw.FontWeight.bold)),
                              pw.Text("${locationsCount[6]}",
                                  style: pw.TextStyle(fontSize: 16)),
                              pw.SizedBox(width: 12),
                              pw.Text(
                                  "${((locationsCount[6] / numInjections) * 100).toStringAsFixed(2)}%",
                                  style: pw.TextStyle(
                                      fontSize: 18,
                                      fontWeight: pw.FontWeight.bold)),
                            ]),
                      ),
                    ])
                  ]),
              pw.SizedBox(height: 10),
            ],
          );
        },
      ),
    );

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
      UserDAOFB dao5 = UserDAOFB();
      List<UserModel> users =
          await dao5.getById(AuthServiceManager.getCurrentUserUID());
      if (!users.isEmpty) {
        userName = users.first.fullName!;
        weight = users.first.weight.toString();
        height = users.first.height.toString();
        typoOfDiabetes = users.first.typeOfDiabetes.toString();
      }
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
      UserDAO dao5 = UserDAO();
      List<UserModel> users = await dao5.getAll();
      if (!users.isEmpty) {
        userName = users.first.fullName!;
        weight = users.first.weight.toString();
        height = users.first.height.toString();
        typoOfDiabetes = users.first.typeOfDiabetes.toString();
      }
    }
    print(_rangoSeleccionado);
    _rangoSeleccionado == 'Periodo personalizado'
        ? print("$formatedInitDate, $formatedEndDate")
        : print("");

    print(glucoseLogs);
    print(insulinLogs);
    print(dietLogs);
    print(exerciceLogs);

    if (glucoseLogs.isNotEmpty) {
      minGlucose = glucoseLogs.first.glucoseValue;
      for (GlucoseLogModel log in glucoseLogs) {
        avgGlucose += log.glucoseValue;
        if (log.hyperglucemia) {
          numHyperglucemias += 1;
        }
        if (log.hypoglucemia) {
          numHypoglucemias += 1;
        }
        if (log.category == "Elevado") {
          numHigh += 1;
        }
        if (log.category == "Bajo") {
          numLow += 1;
        }
        if (log.category == "Normal") {
          numNormal += 1;
        }
        if (maxGlucose < log.glucoseValue) {
          maxGlucose = log.glucoseValue;
        }
        if (minGlucose > log.glucoseValue) {
          minGlucose = log.glucoseValue;
        }
      }
      avgGlucose = avgGlucose / glucoseLogs.length;
    }
    if (insulinLogs.isNotEmpty) {
      Map<String, double> mapTotalInsulin = {};
      int numDays = 0;

      for (InsulinLogModel log in insulinLogs) {
        numInjections += 1;
        insulinUnitsConsumed += log.fastActingInsulinConsumed.toDouble();

        if (!mapTotalInsulin.containsKey(log.date)) {
          mapTotalInsulin[log.date] = log.fastActingInsulinConsumed;
          numDays += 1;
        }

        switch (log.location) {
          case "Brazo izq.":
            locationsCount[0] += 1;
          case "Brazo der.":
            locationsCount[1] += 1;
          case "Gluteo izq.":
            locationsCount[2] += 1;
          case "Gluteo der.":
            locationsCount[3] += 1;
          case "Muslo izq.":
            locationsCount[4] += 1;
          case "Muslo der.":
            locationsCount[5] += 1;
          case "Barriga":
            locationsCount[6] += 1;
          default:
        }
      }
      avgDailyInsulinUnits = insulinUnitsConsumed / numDays;
    }
    if (exerciceLogs.isNotEmpty) {
      for (ExerciceLogModel log in exerciceLogs) {
        physicalActivity += log.duration;
      }
    }

    if (dietLogs.isNotEmpty) {
      Map<String, double> mapTotalCarbs = {};
      int numDays = 0;
      double totalCarbs = 0;

      for (DietLogModel log in dietLogs) {
        totalCarbs += log.totalCarbs.toDouble();

        if (!mapTotalCarbs.containsKey(log.date)) {
          mapTotalCarbs[log.date] = log.totalCarbs.toDouble();
          numDays += 1;
        }
      }
      avgDailyCarbs = totalCarbs / numDays;
    }

    await createPDF(generatePdfName());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UpperNavBar(pageName: "Generar reporte"),
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
