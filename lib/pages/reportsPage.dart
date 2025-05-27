import 'package:diabetes_tfg_app/pages/reportFormPage.dart';
import 'package:diabetes_tfg_app/widgets/backgroundBase.dart';
import 'package:diabetes_tfg_app/widgets/drawerScaffold.dart';
import 'package:diabetes_tfg_app/widgets/lowerNavBar.dart';
import 'package:diabetes_tfg_app/widgets/screenMargins.dart';
import 'package:diabetes_tfg_app/widgets/upperNavBar.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:open_filex/open_filex.dart';

class ReportsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UpperNavBar(pageName: "Reportes"),
      body: DrawerScaffold(
          child: BackgroundBase(child: Center(child: _ReportsPageWidget()))),
      bottomNavigationBar: LowerNavBar(selectedSection: ""),
      backgroundColor: Colors.transparent,
    );
  }
}

class _ReportsPageWidget extends StatefulWidget {
  @override
  _ReportsPageWidgetState createState() => _ReportsPageWidgetState();
}

class _ReportsPageWidgetState extends State<_ReportsPageWidget> {
  List<FileSystemEntity> fileList = [];

  Future<List<FileSystemEntity>> getPdfFiles() async {
    final dir = await getApplicationDocumentsDirectory();
    final files = dir.listSync().where((file) {
      return file.path.endsWith('.pdf');
    }).toList();
    setState(() {
      fileList = files;
    });
    return files;
  }

  @override
  void initState() {
    super.initState();
    getPdfFiles();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenMargins(
        child: Column(
      children: [
        Text("Listado de reportes",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        SizedBox(height: 16),
        Expanded(
          child: ListView.builder(
            itemCount: fileList.length,
            itemBuilder: (context, index) {
              final file = fileList[index];
              final fileName = file.path.split('/').last;

              return Card(
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                child: ListTile(
                  leading:
                      Icon(Icons.picture_as_pdf_rounded, color: Colors.red),
                  title: Text(fileName),
                  trailing: Container(
                    width: 110,
                    child: ElevatedButton(
                      onPressed: () async {
                        await file.delete();
                        await getPdfFiles();
                        setState(() {});
                      },
                      child: Text("Eliminar", style: TextStyle(fontSize: 15)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  onTap: () async {
                    // Lógica para abrir el PDF
                    await OpenFilex.open(file.path);
                  },
                ),
              );
            },
          ),
        ),
        SizedBox(height: 16),
        ElevatedButton(
          onPressed: () async {
            //await generatePDF("juanjooo");
            await getPdfFiles();
            setState(() {});

            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => DrawerScaffold(
                            child: BackgroundBase(
                          child: ReportFormPage(),
                        ))));
          },
          child: Text("Generar nuevo reporte", style: TextStyle(fontSize: 18)),
          style: ElevatedButton.styleFrom(
            backgroundColor: Color.fromARGB(255, 85, 42, 196),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
          ),
        ),
        SizedBox(
            height:
                8), /*
        ElevatedButton(
          onPressed: () {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => DrawerScaffold(
                            child: BackgroundBase(
                          child: ConfigureAutomaticEmailSender(),
                        ))));
          },
          child: Text("Configurar envio automatico",
              style: TextStyle(fontSize: 18)),
          style: ElevatedButton.styleFrom(
            backgroundColor: Color.fromARGB(255, 85, 42, 196),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
          ),
        ),*/
      ],
    ));
  }
}
