import 'dart:io';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:docx_template/docx_template.dart';
// import 'package:downloads_path_provider/downloads_path_provider.dart';
import 'package:external_path/external_path.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lonchi_ing_gd/DB/MyDB.dart';
import 'package:lonchi_ing_gd/MyClasses/MyItems.dart';
import 'package:lonchi_ing_gd/MyWidgets/MyAppBar.dart';
import 'package:pdf/widgets.dart' as pw;
// import 'package:pdf/widgets.dart';
import 'package:permission_handler/permission_handler.dart';
import '../Google/screens/sign_in_screen_only.dart';
import '../Google/utils/authentication.dart';
import '../Google/widgets/GoogleDrive.dart';
import 'package:share_plus/share_plus.dart';
import 'package:open_filex/open_filex.dart';
import 'package:wakelock_plus/wakelock_plus.dart';


class DOCcreate extends StatefulWidget {
  String titulo;
  String fecha;
  List<Items> listapdf;
  List fotospdf;
  String logo;
  String proyecto;

  DOCcreate(
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
  _DOCcreateState createState() => _DOCcreateState();
}

class _DOCcreateState extends State<DOCcreate> {
  User? user = null;
  var _SyncColor = Colors.grey[400];
  String SyncSet = "Desconectado";
  DatabaseHelper _dbHelper = DatabaseHelper();
  List <pw.Widget> pdfitem = [];
  List <Content> docitem = [];
  late RowContent rowfotos;
  List <Content> docfotos = [];
  List  <Content> docitem2 = [];
  List <pw.Widget> pdfitemphoto = [];
  List _filtrofotos = [];
  late pw.Widget title;
  // List _pdflogo;

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
  }

  Future shareDoc() async{
    String? output = await ExternalPath.getExternalStoragePublicDirectory("Download");
    final FinalPath = await '$output/Lonchi-Ing/$proyecto/Reportes inspección';
    await Share.shareXFiles([XFile('$FinalPath/$documento.docx')]);
  }

  createdoc() async {
      Uint8List image = await rootBundle
          .load('assets/Lonchi_ing.png')
          .then((value) => value.buffer.asUint8List());

    var _doclogo;
    if (logopdf.isNotEmpty) {
      // _doclogo = base64Decode(logopdf[0].photo);
      _doclogo = File(logopdf).readAsBytesSync();
    }
    else {
      _doclogo = image;
    }

    final data = await rootBundle.load('assets/Reporttemplate.docx');
    final bytes = data.buffer.asUint8List();

    final docx = await DocxTemplate.fromBytes(bytes);

    Content c = Content();
    c
      ..add(ImageContent('Doclogo', _doclogo))
      ..add(TextContent("Doctitulo", titulo))
      ..add(TextContent("Docfecha", fecha));

      if(listapdf.isNotEmpty) {
        for (var i = 0; i <= listapdf.length - 1; i++) {

          docitem.add(PlainContent("plainvista")
            ..add(TableContent("tabla", [
              RowContent()
                ..add(TextContent("itemdesc", "${i+1}) ${listapdf[i].description}"))
            ])));

          c
            ..add(ListContent("plainlista", docitem));

          _filtrofotos =
              fotospdf.where((j) => j.itemId == listapdf[i].id).toList();

          if (_filtrofotos.isNotEmpty) {
            for (var j = 0; j <= _filtrofotos.length - 1; j++) {
              // print(_filtrofotos[j].itemId);
              var foto = File(_filtrofotos[j].photo).readAsBytesSync();
              // var foto = base64Decode(_filtrofotos[j].photo);

              docfotos.add(PlainContent("pruebavista")
                ..add(ImageContent("Prueba1", foto)));
              c
                ..add(ListContent("pruebalista", docfotos));
            }
          }
        }
      };
      final output = await ExternalPath.getExternalStoragePublicDirectory("Download");
      final FinalPath = await '$output/Lonchi-Ing/$proyecto/Reportes inspección';
      if (await Directory(FinalPath).exists()){
        print ('Ya existe $FinalPath');
      } else{
        print ('NO existe $FinalPath');
        await new Directory(FinalPath).create(recursive: true);
      }
      final file = File('$FinalPath/$documento.docx');
      _fullPath = '$FinalPath/$documento.docx';
      final d = await docx.generate(c);
      if (d != null) await file.writeAsBytes(d);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[900],

        appBar: MyAppBar("Reporte DOCX", context),

        body: Container(
          width: double.infinity,
          height: double.infinity,

          child:   _isGenerating
              ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.redAccent),
                ),
                const SizedBox(height: 16),
                Text(
                  "Generando DOCX...",
                  style: TextStyle(color: Colors.grey[400], fontSize: 16),
                ),
              ],
            ),
          )
              : Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text("Generar reporte DOCX", style: TextStyle(fontSize: 34, color: Colors.grey[400],),),
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
                          // _descriptionFocus.requestFocus();
                          decoration: InputDecoration(
                            hintText: documento,
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
                      await createdoc();
                      print('documento salvado');
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: const Text('DOCX creado'),
                        duration: const Duration(seconds: 2),
                      ));
                      setState(() {
                        saved = true;
                        _isGenerating = false;
                      });
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
            ), // This trailing comma makes auto-formatting nicer for build methods.
            FloatingActionButton(
              backgroundColor: Colors.red[900],
              heroTag: "B2",
              onPressed: () async{
                if (documento != "") {
                  final output = await ExternalPath.getExternalStoragePublicDirectory("Download");
                  final FinalPath = await '$output/Lonchi-Ing/$proyecto/Reportes inspección';
                  String fullPath = "$FinalPath/$documento.docx";
                  if (await File(fullPath).exists()){
                    saved = true;
                    print('ARCHIVO EXISTE');
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: const Text('DOCX existe y cargado'),
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
                      content: const Text('DOCX no existe'),
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
                  final output = await ExternalPath.getExternalStoragePublicDirectory("Download");
                  final FinalPath = await '$output/Lonchi-Ing/$proyecto/Reportes inspección';
                  String fullPath = "$FinalPath/$documento.docx";
                  OpenFilex.open(fullPath);
                  //
                  // Navigator.push(context, MaterialPageRoute(
                  //     builder: (context) => PdfPreviewScreen(path: fullPath,)
                  // ));
                }
              },
              child: Icon(Icons.preview,
                  color: saved == false ?
                  Colors.red[700]:
                  Colors.grey[400]),
            ),
            FloatingActionButton(
              backgroundColor: Colors.red[900],
              heroTag: "B3",
              onPressed: ()async{
                if (saved == true) {
                  await shareDoc();
                }
              },
              child: Icon(Icons.share,
                  color: saved == false ?
                  Colors.red[700]:
                  Colors.grey[400]),
            ),
            FloatingActionButton(
              backgroundColor: Colors.red[900],
              heroTag: "B4",
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