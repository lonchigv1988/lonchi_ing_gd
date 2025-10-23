import 'dart:io';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
// import 'package:downloads_path_provider/downloads_path_provider.dart';
import 'package:external_path/external_path.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lonchi_ing_gd/DB/MyDB.dart';
import 'package:lonchi_ing_gd/MyClasses/MyItems.dart';
import 'package:lonchi_ing_gd/MyWidgets/MyAppBar.dart';
// import 'package:open_file/open_file.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:image/image.dart' as img;
// import 'package:pdf/widgets.dart';
import 'package:printing/printing.dart';
import 'package:permission_handler/permission_handler.dart';
import '../Google/screens/sign_in_screen_only.dart';
import '../Google/utils/authentication.dart';
import '../Google/widgets/GoogleDrive.dart';
import 'package:open_filex/open_filex.dart';
import 'package:wakelock_plus/wakelock_plus.dart';


class PDFcreate extends StatefulWidget {
  String titulo;
  String fecha;
  List<Items> listapdf;
  List fotospdf;
  String logo;
  String proyecto;

  PDFcreate(
      {
        required this.titulo,
        required this.fecha,
        required this.listapdf,
        required this.fotospdf,
        required this.logo,
        required this.proyecto
      }
      );

  @override
  _PDFcreateState createState() => _PDFcreateState();
}

class _PDFcreateState extends State<PDFcreate> {
  User? user = null;
  var _SyncColor = Colors.grey[400];
  String SyncSet = "Desconectado";
  DatabaseHelper _dbHelper = DatabaseHelper();
  List <pw.Widget> pdfitem = [];
  List <pw.Widget> pdfitemphoto = [];
  late List _filtrofotos;
  late pw.Widget title;

  String documento = "";
  bool saved = false;
  bool _isGenerating = false;

  late String titulo;
  late String fecha;
  late List<Items> listapdf;
  late List fotospdf;
  late String logopdf;
  late String proyecto;
  String _fullPath ="";
  late int _selectedQuality;
  late pw.Document pdf;
  // DateTime date = DateFormat("dd/MM/yyyy").parse(widget.fecha);

  @override
  void initState() {
    user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _SyncColor = Colors.green[800];
      SyncSet = "Conectado";
    }
    titulo = widget.titulo;
    fecha = widget.fecha;
      listapdf = widget.listapdf;
    fotospdf = widget.fotospdf;
    // documento = '${widget.titulo}-(${widget.fecha})';
    // documento = '${widget.titulo}-(${DateFormat("dd-MM-yyyy").format(DateFormat("dd/MM/yyyy").parse(widget.fecha))})';
    documento = '${widget.titulo}-(${DateFormat("yyyy-MM-dd").format(DateFormat("dd/MM/yyyy").parse(widget.fecha))})';
    logopdf = widget.logo;
    proyecto = widget.proyecto;
    _selectedQuality = 100; // default "alta"
    pdf = pw.Document();
    }

  crearpdf(image) {
    pdfitem = [];
    pdfitemphoto = [];
    print(logopdf);
    var _pdflogo;
    if (logopdf.isNotEmpty && File(logopdf).existsSync()) {
      _pdflogo = pw.MemoryImage(File(logopdf).readAsBytesSync());
    }
    else {
      _pdflogo = pw.MemoryImage(image);
    }
    pdfitem.add(pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.end,
      children: [
        pw.Container(
        // alignment: pw.Alignment.centerRight,
      alignment: pw.Alignment.topRight,
      margin: const pw.EdgeInsets.only(top: 1.0 * PdfPageFormat.cm),
      // padding: const pw.EdgeInsets.all(0.3 * PdfPageFormat.mm),
      // decoration: pw.BoxDecoration(
      //   border: pw.Border.all(width: 0.5, color: PdfColors.grey),),
      height: 75,
      width: 75,
      child: pw.Image(_pdflogo),
    )]));
    pdfitem.add(pw.Container(
        alignment: pw.Alignment.centerLeft,
        margin: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
        padding: const pw.EdgeInsets.all(1.5 * PdfPageFormat.mm),
        // padding: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
        decoration: pw.BoxDecoration(
          border: pw.Border.all(width: 0.5, color: PdfColors.grey),
        ),
        // level: 0,
        child: pw.Text("Reporte: $titulo",
          textAlign: pw.TextAlign.center,
          style: pw.TextStyle(
            color: PdfColors.grey700,
            fontWeight: pw.FontWeight.bold,
            fontSize: 20,
          ),
        )
    ));
    pdfitem.add(pw.Header(
        level: 2,
        child: pw.Text("Fecha: $fecha",
          style: pw.TextStyle(
            color: PdfColors.grey600,
            fontStyle: pw.FontStyle.italic,
            fontSize: 10,
          ),
        )));
    pdfitem.add(pw.Header(
        level: 2,
        child: pw.Text("DETALLES OBSERVADOS EN LA INSPECCIÓN",
          style: pw.TextStyle(
            color: PdfColors.grey600,
            // fontStyle: pw.FontStyle.italic,
            fontSize: 10,
            decoration: pw.TextDecoration.underline,
          ),
        )));
    // for (var ccc = 0; ccc <= fotospdf.length-1; ccc++){
    //   print(fotospdf[ccc].itemId);
    // }

    if(listapdf.isNotEmpty) {
      for (var i = 0; i <= listapdf.length - 1; i++) {
        _filtrofotos =
            fotospdf.where((j) => j.itemId == listapdf[i].id).toList();
        // pdfitem.add(pw.Paragraph(text: "holi $i"));
        // pdfitem.add(pw.Paragraph(text: listapdf[i].description));
        // print(listapdf[i].description);
        // print(fotospdf[0].photo);
        if (_filtrofotos.isNotEmpty) {
          for (var j = 0; j <= _filtrofotos.length - 1; j++) {
            // print(_filtrofotos[j].itemId);
            // var foto = pw.MemoryImage(base64Decode(_filtrofotos[j].photo));
            var FotoOriginal = img.decodeImage(File(_filtrofotos[j].photo).readAsBytesSync());
            var FotoRed = img.encodeJpg(FotoOriginal!, quality: _selectedQuality);
            var foto = pw.MemoryImage(FotoRed);
            // var foto = pw.MemoryImage(File(_filtrofotos[j].photo).readAsBytesSync());
            pdfitemphoto.add(pw.Container(
              padding: const pw.EdgeInsets.all(0.3 * PdfPageFormat.mm),
              decoration: pw.BoxDecoration(
                border: pw.Border.all(width: 0.5, color: PdfColors.grey),),
              height: 100,
              width: 100,
              child: pw.Image(foto),
            ));
          }
        }
        pdfitem.add(pw.Container(
          alignment: pw.Alignment.centerLeft,
          margin: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
          padding: const pw.EdgeInsets.all(1.5 * PdfPageFormat.mm),
          // padding: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
          decoration: pw.BoxDecoration(
            border: pw.Border.all(width: 0.5, color: PdfColors.black),),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Paragraph(text: '${i+1}) ${listapdf[i].description}',
                  style: pw.TextStyle(
                    // color: PdfColors.grey600,
                    // fontStyle: pw.FontStyle.italic,
                    fontSize: 10,
                  ),),
                pw.Paragraph(text: 'Fotografías:',
                  style: pw.TextStyle(
                    // color: PdfColors.grey600,
                    // fontStyle: pw.FontStyle.italic,
                    fontSize: 10,
                  ),),
                pw.Wrap(
                  spacing: 4,     // horizontal space between photos
                  runSpacing: 4,  // vertical space between rows of photos
                  children: pdfitemphoto,
                ),
                // pw.Row(
                //     crossAxisAlignment: pw.CrossAxisAlignment.center,
                //     children: pdfitemphoto),
              ]
          ),
        ));
        pdfitemphoto = [];
      }
    }
    return pdfitem;
  }

  writeOnPdf() async {
    pdf = pw.Document();
    Uint8List image = await rootBundle
        .load('assets/Lonchi_ing.png')
        .then((value) => value.buffer.asUint8List());
    pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.letter,
          margin: pw.EdgeInsets.all(20),
          footer: (pw.Context context) {
            return pw.Container(
                alignment: pw.Alignment.centerRight,
                margin: const pw.EdgeInsets.only(top: 1.0 * PdfPageFormat.cm),
                child: pw.Text('${context.pageNumber} / ${context.pagesCount}',
                  style: pw.TextStyle(
                  color: PdfColors.grey600,
                  // fontStyle: pw.FontStyle.italic,
                  fontSize: 10,
                ),));
          },
          build: (pw.Context context){
            return crearpdf(image);
          },
        )
    );
  }

  Future savePdf() async{
    final output = await ExternalPath.getExternalStoragePublicDirectory("Download");
    final FinalPath = await '$output/Lonchi-Ing/$proyecto/Reportes inspección';
    if (await Directory(FinalPath).exists()){
      print ('Ya existe $FinalPath');
    } else{
      print ('NO existe $FinalPath');
      await new Directory(FinalPath).create(recursive: true);
    }
    final file = File('$FinalPath/$documento.pdf');
    _fullPath = '$FinalPath/$documento.pdf';
    await file.writeAsBytes(await pdf.save());
  }

  Future sharePdf() async{
    String? output = await ExternalPath.getExternalStoragePublicDirectory("Download");
    final FinalPath = await '$output/Lonchi-Ing/$proyecto/Reportes inspección';
    final file = File("$FinalPath/$documento.pdf");
    var binaries = await file.readAsBytes();
    await Printing.sharePdf(bytes: await binaries, filename: '$documento.pdf');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[900],

        appBar: MyAppBar("Reporte PDF", context),

        body: Container(
          width: double.infinity,
          height: double.infinity,
          child:  _isGenerating
              ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.redAccent),
                ),
                const SizedBox(height: 16),
                Text(
                  "Generando PDF...",
                  style: TextStyle(color: Colors.grey[400], fontSize: 16),
                ),
              ],
            ),
          )
              : Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text("Generar reporte en PDF", style: TextStyle(fontSize: 34, color: Colors.grey[400],),),
              Text("Salvar", style: TextStyle(fontSize: 20, color: Colors.grey[400],),),
              Text("Visualizar, compartir, sincronizar", style: TextStyle(fontSize: 20, color: Colors.grey[400],),),
              Padding(
                padding: EdgeInsets.only(
                  top: 12.0,
                  bottom: 6.0,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 1,
                      child: SizedBox(),
                    ),
                    Expanded(
                      flex: 3,
                      child: Text("Nombre:",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 13,
                          )),
                    ),
                    Expanded(
                      flex: 1,
                      child: SizedBox(),
                    ),
                    Expanded(
                      flex: 11,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(
                          color: Colors.grey[800],
                          border: Border.all(color: Colors.grey[600]!),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: TextField(
                          controller: TextEditingController()..text = documento,
                          onChanged: (value) {
                            documento = value;
                          },
                          decoration: InputDecoration(
                            hintStyle: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[400],
                                fontStyle: FontStyle.italic),
                            border: InputBorder.none,
                          ),
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[400],
                          ),
                          maxLines: null,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: SizedBox(),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: 12.0,
                  bottom: 6.0,
                ),
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: SizedBox(),
                    ),
                    Expanded(
                      flex: 3,
                      child: Text(
                        "Calidad imágenes:",
                        textAlign: TextAlign.start,
                        style: TextStyle(color: Colors.grey[400], fontSize: 13),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: SizedBox(),
                    ),
                    Expanded(
                      flex: 11,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(
                          color: Colors.grey[800],
                          border: Border.all(color: Colors.grey[600]!),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: DropdownButton<int>(
                          isExpanded: true,
                          underline: Container(),
                          dropdownColor: Colors.grey[900],
                          value: _selectedQuality,
                          style: TextStyle(color: Colors.grey[400], fontSize: 14),
                          items: const [
                            DropdownMenuItem(value: 100, child: Text("Alta")),
                            DropdownMenuItem(value: 75, child: Text("Media")),
                            DropdownMenuItem(value: 50, child: Text("Baja")),
                            DropdownMenuItem(value: 25, child: Text("Muy baja")),
                          ],
                          onChanged: (value) {
                            if (value != null) {
                              setState(() {
                                _selectedQuality = value;
                              });
                            }
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: SizedBox(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              backgroundColor: Colors.red[900],
              heroTag: "B1",
              onPressed: () async{
                if (documento != "") {
                  setState(() {
                    _isGenerating = true;
                  });

                  await Future.delayed(Duration(milliseconds: 500));
                  Future(() async {
                    await WakelockPlus.enable();
                    try {
                      var status = await Permission.photos.request();
                      if (status.isDenied) {
                        openAppSettings();
                        print('No se tiene permiso');
                      }
                      else {
                        print('Sí se tiene permiso');
                        await writeOnPdf();
                        await savePdf();
                        print('documento salvado');
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: const Text('PDF creado'),
                            duration: const Duration(seconds: 2),
                          ));
                          setState(() {
                            saved = true;
                            _isGenerating = false;
                          });
                        }
                      }
                    } finally {
                      await WakelockPlus.disable();
                    }
                  });
                }
              },
              child: Icon(Icons.save,
                  color: documento == "" ?
                  Colors.red[700]:
                  Colors.grey[400]),
            ),
            FloatingActionButton(
              backgroundColor: Colors.red[900],
              heroTag: "B2",
              onPressed: () async{
                if (documento != "") {
                  String? output = await ExternalPath.getExternalStoragePublicDirectory("Download");
                  final FinalPath = await '$output/Lonchi-Ing/$proyecto/Reportes inspección';
                  String fullPath = "$FinalPath/$documento.pdf";
                  print(FinalPath);
                  if (await File(fullPath).exists()){
                    saved = true;
                    print('ARCHIVO EXISTE');
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: const Text('PDF existe y cargado'),
                      duration: const Duration(seconds: 2),
                    ));
                    setState(() {
                      saved = true;
                    });
                  }
                  else {
                    saved = false;
                    print('ARCHIVO NOOOO EXISTE');
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: const Text('PDF no existe'),
                      duration: const Duration(seconds: 2),
                    ));
                    setState(() {
                      saved = false;
                    });
                  }
                }
              },
              child: Icon(Icons.file_open,
                  color: documento == "" ?
                  Colors.red[700]:
                  Colors.grey[400]),
            ),
            FloatingActionButton(
              backgroundColor: Colors.red[900],
              heroTag: "B3",
              onPressed: () async{
                if (saved == true) {
                  String? output = await ExternalPath.getExternalStoragePublicDirectory("Download");
                  final FinalPath = await '$output/Lonchi-Ing/$proyecto/Reportes inspección';
                  String fullPath = "$FinalPath/$documento.pdf";
                  print(FinalPath);
                  if (await File(fullPath).exists()){
                    print('ARCHIVO EXISTE');
                  }
                  else {
                    print('ARCHIVO NOOOO EXISTE');
                  }
                  await OpenFilex.open(fullPath);
                }
              },
              child: Icon(Icons.preview,
                  color: saved == false ?
                  Colors.red[700]:
                  Colors.grey[400]),
            ),
            FloatingActionButton(
              backgroundColor: Colors.red[900],
              heroTag: "B4",
              onPressed: ()async{
                if (saved == true) {
                  await sharePdf();
                }
              },
              child: Icon(Icons.share,
                  color: saved == false ?
                  Colors.red[700]:
                  Colors.grey[400]),
            ),
            FloatingActionButton(
              backgroundColor: Colors.red[900],
              heroTag: "B5",
              onPressed: ()async{
                if (saved == true) {
                  if (user == null) {
                    await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => SignInScreenOnly(),
                      ),
                    );
                  } else {
                  }
                  await Authentication();
                  user = await FirebaseAuth.instance.currentUser;
                  setState(() {
                    user = user;
                    if (user != null) {
                      _SyncColor = Colors.green[800];
                      SyncSet = "Conectado";
                    }
                  });
                  await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => DriveSyncScreen(ProyectoTitle: proyecto, DocTitle: _fullPath, SyncType: "documento"),
                    ),
                  );
                }
              },
              child: Icon(Icons.cloud_sync,
                  color: saved == false ?
                  Colors.red[700] :
                  _SyncColor),
            ),
          ],
        )
    );
  }
}