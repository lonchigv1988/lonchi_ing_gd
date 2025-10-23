// import 'package:date_field/date_field.dart';
import 'package:camera/camera.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
// import 'package:jiffy/jiffy.dart';
import 'package:lonchi_ing_gd/MyClasses/MyItems.dart';
// import 'package:lonchi_ing_gd/MyClasses/MyPhotos.dart';
import 'package:lonchi_ing_gd/MyClasses/MyReport.dart';
import 'package:lonchi_ing_gd/MyClasses/ReportWidgets.dart';
import 'package:lonchi_ing_gd/Reportes/PDFreport.dart';
import '../DB/MyDB.dart';
import '../Google/screens/sign_in_screen_only.dart';
import '../Google/utils/authentication.dart';
import '../Google/widgets/GoogleDrive.dart';
import 'DOCreport.dart';
import 'itempage.dart';

class Reportpage extends StatefulWidget {
  final int? proyectoId;
  final String? ProyectTitle;
  final Report? report;
  final Proyecto? proyecto;

  Reportpage({this.proyectoId, this.ProyectTitle, required this.report, this.proyecto});

  @override
  _ReportpageState createState() => _ReportpageState();
}

class _ReportpageState extends State<Reportpage> {
  DatabaseHelper _dbHelper = DatabaseHelper();
  User? user = null;
  var _SyncColor = Colors.grey[400];
  String SyncSet = "Desconectado";

  TextEditingController TEController = new TextEditingController();
  int _reportId = 0;
  int _proyectoId = 0;
  String _ProyectTitle = "";
  String _reportTitle = "";
  String _ItemDesc = "";
  int _count = 0;
  Report? _report = null;
  late String _proyectlogo;
  late var logo;
  late Proyecto _proyecto;
  var _reportDateController = TextEditingController();

  Future<Null> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      firstDate: DateTime(2000),
      // initialDate: DateTime.now(),
      initialDate:
        _reportDateController.text != ""
            ? DateFormat('dd/MM/yyyy').parse(_reportDateController.text)
            : DateTime.now(),
      lastDate: DateTime(2100),

    );
    if (picked != null) {
      await _dbHelper.updateReportDate(_reportId, DateFormat('dd/MM/yyyy').format(picked));
      await _dbHelper.updateReportDateTime(_reportId, picked.millisecondsSinceEpoch);
      // print(picked.toString());
      setState(() {
        _reportDateController.text = DateFormat('dd/MM/yyyy').format(picked);
        // print( _reportDateController);
      });
    }
  }

  // FocusNode _titleFocus;
  // FocusNode _dateFocus;
  // FocusNode _descriptionFocus;
  // FocusNode _todoFocus;

  bool _contentVisile = false;

  @override
  void initState() {
    user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _SyncColor = Colors.green[800];
      SyncSet = "Conectado";
    }
    _proyectoId = widget.proyectoId!;
    _ProyectTitle = widget.ProyectTitle!;
    _proyecto = widget.proyecto!;
    logo = _proyecto.photo;
    if (logo == null) {
      _proyectlogo = "";
    } else {
      _proyectlogo = logo;
    }
    print(_proyectlogo);
    if (widget.report != null) {
      _contentVisile = true;
      _report = widget.report;
      _reportTitle = widget.report!.title!;
      TEController.text = widget.report!.title!;
      _reportDateController.text = widget.report!.date!;
      _reportId = widget.report!.id!;
      _count = widget.report!.count!;
    } else {
      // New report defaults
      _contentVisile = false;
      _reportTitle = "";
      TEController.text = "";
      // _reportDateController.text = DateFormat('dd/MM/yyyy').format(DateTime.now());
      _reportId = 0;
      _count = 0;
    }

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future SaveUpdateReporte(String value) async {
    if (value != "") {
      if (_report == null) {
        Report _newReport = Report(
            title: value,
            proyectoId: _proyectoId,
            count: 0,
            date: DateFormat('dd/MM/yyyy').format(DateTime.now()),
            datetime: DateTime.now().millisecondsSinceEpoch);
        _reportId = await _dbHelper.insertReport(_newReport);
        _report = _newReport;
        await _dbHelper.updateProyectoCount(_proyectoId);
        _reportTitle = value;
        _reportDateController.text = DateFormat('dd/MM/yyyy').format(DateTime.now());
        print("Reporte creado");
      } else {
        await _dbHelper.updateReportTitle(_reportId, value);
        print("Reporte actualizado");
      }
      // _descriptionFocus.requestFocus();
    }
  }

  void showDeleteDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("Cancelar"),
      onPressed:  () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = TextButton(
      child: Text("Confirmar"),
      onPressed:  () async {
        await _dbHelper.deleteReport(_reportId, _proyectoId);
        Navigator.of(context).pop();
        Navigator.pop(context);
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Alerta"),
      content: Text("Está seguro que desea eliminar reporte?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void _ExportPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.picture_as_pdf),
                      title: new Text('Generar pdf'),
                      onTap: () async {
                        Navigator.of(context).pop();
                        FocusScope.of(context).requestFocus(FocusNode());
                        if(_reportId != 0) {
                          String titulo = '$_ProyectTitle-$_reportTitle';
                          String fecha;
                          if (_reportDateController.text != "") {
                            fecha = _reportDateController.text;
                          }
                          else {
                            fecha = DateFormat("dd/MM/yyyy").format(DateTime.now());
                          }
                          List fotos = await _dbHelper.getReportPhotos(_reportId);
                          List<Items> lista = await _dbHelper.getItems(_reportId);
                          String logo = _proyectlogo;
                          String proyecto = '$_ProyectTitle';
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PDFcreate(
                                titulo: titulo,
                                fecha: fecha,
                                listapdf: lista,
                                fotospdf: fotos,
                                logo: logo,
                                proyecto: proyecto,
                              ),
                            ),
                          );
                        }
                      }
                  ),
                  new ListTile(
                    leading: new Icon(Icons.library_books),
                    title: new Text('Generar docx'),
                    onTap: () async {
                      Navigator.of(context).pop();
                      FocusScope.of(context).requestFocus(FocusNode());
                      if(_reportId != 0) {
                        String titulo = '$_ProyectTitle-$_reportTitle';
                        // String titulo = _reportTitle;
                        String fecha;
                        if (_reportDateController.text != "") {
                          fecha = _reportDateController.text;
                        }
                        else {
                          fecha = DateFormat("dd/MM/yyyy").format(DateTime.now());
                        }
                        List fotos = await _dbHelper.getReportPhotos(_reportId);
                        List<Items> lista = await _dbHelper.getItems(_reportId);
                        String logo = _proyectlogo;
                        String proyecto = '$_ProyectTitle';
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DOCcreate(
                              titulo: titulo,
                              fecha: fecha,
                              listapdf: lista,
                              fotospdf: fotos,
                              logo: logo,
                              proyecto: proyecto,
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          );
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      // appBar: MyAppBar('Ingreso de reporte', context),
      appBar: AppBar(
        title: Text('Ingreso de reporte',
          style: TextStyle(
            color: Colors.grey[400],
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.red[900],
        automaticallyImplyLeading: true,
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            color: Colors.grey[400],
            onPressed: () async {
              await SaveUpdateReporte(_reportTitle);
              Navigator.pop(context, true);
            }
        ),
      ),
      body: SafeArea(
        child: Container(
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                          flex: 4,
                          child: Text("Título:",
                              textAlign: TextAlign.end,
                              style: TextStyle(
                                color: Colors.grey[400],
                                fontSize: 20,
                              )),
                        ),
                        Expanded(
                          flex: 1,
                          child: SizedBox(),
                        ),
                        Expanded(
                          flex: 15,
                          child: TextField(
                            autofocus: _report == null ? true : false,
                            textCapitalization: TextCapitalization.sentences,
                            textInputAction: TextInputAction.done,
                            maxLines: null,
                            onChanged: (value) async {
                              _contentVisile = true;
                              _reportTitle = value;
                            },
                            onSubmitted: (value) async {
                              await SaveUpdateReporte(value);
                            },
                            controller: TEController
                              ..text = _reportTitle,
                            decoration: InputDecoration(
                              hintText: "Ingresar título",
                              hintStyle: TextStyle(
                                  fontSize: 15.0,
                                  color: Colors.grey[400],
                                  fontStyle: FontStyle.italic),
                              border: InputBorder.none,
                            ),
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[400],
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
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 3,
                        child: SizedBox(),
                      ),
                      Expanded(
                        flex: 2,
                        child: Padding(
                          padding: EdgeInsets.only(
                            bottom: 12.0,
                          ),
                          child: FutureBuilder(
                              initialData: [],
                              future: _dbHelper.getProyectoReports(_proyectoId),
                              builder: (context, snapshot) {
                                return IconButton(
                                  icon: Icon(
                                    Icons.calendar_today,
                                    color: Colors.red[900],
                                  ),
                                  onPressed: () async {
                                    // print((DateFormat('dd/MM/yyyy').parse(_reportDateController.text)).millisecondsSinceEpoch);
                                    selectDate(context);
                                  },
                                );
                              }
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: SizedBox(),
                      ),
                      Expanded(
                        flex: 15,
                        child: TextField(
                          enabled: false,
                          controller: _reportDateController,
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.grey[400],
                            height: 1.5,
                          ),
                          decoration: InputDecoration(
                            labelText: 'Fecha',
                            labelStyle: TextStyle(
                              fontSize: 16.0,
                              color: Colors.grey[400],
                              height: 1.5,
                            ),
                            hintText: 'Escoger fecha',
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: SizedBox(),
                      ),
                    ],
                  ),
                  Visibility(
                    // visible: _contentVisile,
                    child: FutureBuilder(
                      initialData: [],
                      future: _dbHelper.getItems(_reportId),
                      builder: (context, AsyncSnapshot snapshot) {
                        return Expanded(
                          child: ListView.builder(
                            itemCount: _reportId == 0 ? 0 : snapshot.data.length,
                            // itemCount: 1,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () async {
                                  WidgetsFlutterBinding.ensureInitialized();
                                  final cameras = await availableCameras();
                                  final firstCamera = cameras.first;
                                  if(_reportId != 0) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => Itempage(
                                          item: snapshot.data[index],
                                          camera: firstCamera,
                                          proyecto: _ProyectTitle,
                                        ),
                                      ),
                                    ).then(
                                          (value) {
                                        setState(() {});
                                      },
                                    );
                                  }
                                },
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(3,5,3,3),
                                  child: ItemWidget(
                                    id: index + 1,
                                    desc: snapshot.data[index].description,
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        height: 100,
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 16.0),
        color: Colors.red[900],
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: Column(
                children: [
                  IconButton(
                    icon: Icon(Icons.cloud_sync),
                    tooltip: 'Estado con Google Drive',
                    color: _SyncColor,
                    iconSize: 45,
                    onPressed: () async {
                      print(_reportId);
                      await SaveUpdateReporte(_reportTitle);
                      // print(user);
                      if (user == null) {
                        await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => SignInScreenOnly(),
                          ),
                        );
                      } else {
                      }
                      await Authentication();
                      await Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => DriveSyncScreen(ProyectoTitle: _ProyectTitle, DBReportId: _reportId, SyncType: "reporte",),
                        ),
                      );
                      user = await FirebaseAuth.instance.currentUser;
                      setState(() {
                        user = user;
                        if (user != null) {
                          _SyncColor = Colors.green[800];
                          SyncSet = "Conectado";
                        }
                      });
                    },
                  ),
                  Text(SyncSet,
                    style: TextStyle(
                      color: _SyncColor,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: IconButton(
                icon: Icon(Icons.delete),
                tooltip: 'Borrar reporte',
                color: Colors.grey[400],
                // _reportId == 0
                //     ? Colors.red[700]
                //     : Colors.grey[400],
                iconSize: 45,
                onPressed: () async {
                  FocusScope.of(context).requestFocus(FocusNode());
                  if(_reportId != 0) {
                    showDeleteDialog(context);
                  }
                },
              ),
            ),
            Expanded(
              flex: 1,
              child: IconButton(
                icon: Icon(Icons.edit_document),
                tooltip: 'Exportar',
                color: Colors.grey[400],
                // _reportId == 0
                //     ? Colors.red[700]
                //     : Colors.grey[400],
                iconSize: 45,
                onPressed: () async {
                  _ExportPicker(context);
                },
              ),
            ),
            Expanded(
              flex: 1,
              child:IconButton(
                icon: Icon(Icons.add_circle),
                tooltip: 'Agregar item',
                color: Colors.grey[400],
                // _reportId == 0
                //     ? Colors.red[700]
                //     : Colors.grey[400],
                iconSize: 45,
                onPressed: () async {
                  await SaveUpdateReporte(_reportTitle);
                  FocusScope.of(context).requestFocus(FocusNode());
                  WidgetsFlutterBinding.ensureInitialized();
                  final cameras = await availableCameras();
                  final firstCamera = cameras.first;

                  if(_reportId != 0) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Itempage(
                          item: null,
                          ReportNum: _reportId,
                          ProyectoNum: _proyectoId,
                          camera: firstCamera,
                          proyecto: _ProyectTitle,
                        ),
                      ),
                    ).then(
                          (value) {
                        setState(() {});
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
