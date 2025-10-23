import 'package:external_path/external_path.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lonchi_ing_gd/DB/MyDB.dart';
import 'package:lonchi_ing_gd/MyClasses/MyReport.dart';
import 'package:lonchi_ing_gd/MyClasses/ReportWidgets.dart';
import 'package:lonchi_ing_gd/Reportes/Search-reportes.dart';
import 'package:lonchi_ing_gd/Reportes/reportpage.dart';
import 'dart:async';
import 'dart:io';
import 'package:lonchi_ing_gd/MyClasses/Utility.dart';
import 'package:lonchi_ing_gd/MyClasses/MyPhotos.dart';
import '../Google/screens/sign_in_screen_only.dart';
import '../Google/utils/authentication.dart';
import '../Google/widgets/GoogleDrive.dart';
import '../MyWidgets/Rebuilder.dart';
import 'Search-reportes-item.dart';
import 'logopage.dart';
import 'package:googleapis/drive/v3.dart' as drive;

class Reportes extends StatefulWidget {
  final int? proyectoId;
  final Logo? logo;
  final Proyecto? proyecto;

  Reportes ({this.proyectoId, this.logo, this.proyecto});

  @override
  ReportesState createState() {
    return ReportesState();
  }
}

class ReportesState extends State<Reportes> {
  User? user = null;
  DatabaseHelper _dbHelper = DatabaseHelper();

  TextEditingController TEController = new TextEditingController();
  int _proyectoId = 0;
  String _proyectoTitle = "";
  late File _image;
  String _itempic = "";
  late Future<List> _ProyectLogo;
  late Future<String?> _logoFuture;
  Proyecto? _proyecto = null;
  late String LogoPic;
  late FocusNode _TituloNode;
  bool LogoExists = false;
  var _SyncColor = Colors.grey[400];
  String SyncSet = "Desconectado";
  final googleSignIn = GoogleSignIn.standard(scopes: [
    drive.DriveApi.driveAppdataScope,
    drive.DriveApi.driveFileScope,
  ]);

  @override
  void initState() {
    user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _SyncColor = Colors.green[800];
      SyncSet = "Conectado";
    }
    _ProyectLogo = _dbHelper.getLogo(_proyectoId);
    _logoFuture = _loadLogo();
    if (widget.proyecto != null) {
      _proyectoId = widget.proyecto!.id!;
      _proyecto = widget.proyecto!;
      _proyectoTitle = widget.proyecto!.title!;
      _itempic = widget.proyecto!.photo!;
      TEController.text = widget.proyecto!.title!;
    }
    else {
    }
    super.initState();
    _loadLogo().then((path) {
      setState(() {
        _logoFuture = Future.value(path);
      });
    });
  }

  // Function to load the logo and return its path or null
  Future<String?> _loadLogo() async {
    String? logoPath = await _dbHelper.getLogoPath(_proyectoId); // Fetch logo path from DB
    if (logoPath != null && await File(logoPath).exists()) {
      setState(() {
        _itempic = logoPath; // Store the logo path if it exists
      });
      return logoPath; // Return the logo path if it exists
    }
    return null; // Return null if logo doesn't exist
  }



  Future _checkLogoExist() async {
    imageCache.clear();
    if (await File(_itempic).exists()) {
      LogoExists = true;
      print("logo existe");
    } else {
      LogoExists = false;
      print("logo no existe");
    }
    setState(() {
      _ProyectLogo = (_dbHelper.getLogo(_proyectoId));
      imageCache.evict(File(_itempic), includeLive: true);
      // _itempic = widget.proyecto!.photo!;
    });
    return _dbHelper.getLogo(_proyectoId);

  }

  Future SaveUpdateProyecto(String value) async {
    _proyectoTitle = value;
    final output = await ExternalPath.getExternalStoragePublicDirectory("Download");
    var path = await '$output/Lonchi-Ing/$_proyectoTitle/Logo.jpeg';
    if (value != "") {
      if (_proyecto == null)  {
        Proyecto _newProyecto = Proyecto(title: value, count: 0, photo: path);
        _proyectoId = await _dbHelper.insertProyecto(_newProyecto);
        _proyecto = _newProyecto;
        _itempic = path;
        // print("Proyecto nuevo creado");
      } else {
        await _dbHelper.updateProyectoTitle(_proyectoId, value);
        print("Nuevo nombre de proyecto es:$value");
        path = await '$output/Lonchi-Ing/$value/Logo.jpeg';
        print("Nuevo logo está en:$path");
        await _dbHelper.saveLogo(_proyectoId, path);
        // await _dbHelper.updateProyectoLogo(_proyectoId, path);
        if (widget.proyecto == null) {
          // _proyecto = widget.proyecto!;
          _proyectoTitle = value;
          _itempic = path;
        }
      }
    }
    setState(() {
      _proyectoTitle = value;
    });
  }

  Future<void> _pickLogo() async {
    final XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 75);
    if (image != null) {
      final output = await ExternalPath.getExternalStoragePublicDirectory("Download");
      final folderPath = '$output/Lonchi-Ing/$_proyectoTitle';
      final path = '$folderPath/Logo.jpeg';

      // Ensure folder exists
      final dir = Directory(folderPath);
      if (!(await dir.exists())) {
        await dir.create(recursive: true);
      }

      await image.saveTo(path);
      await _dbHelper.saveLogo(_proyectoId, path);

      setState(() {
        _logoFuture = Future.value(path); // avoid re-calling DB
        _itempic = path;
      });
    }
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.search),
                      title: new Text('Por título y fechas'),
                      onTap: () {
                        Navigator.of(context).pop();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>SearchReportes(proyectoId: _proyectoId)),
                        ).then((value) {
                          setState(() {});
                        },
                        );
                      }
                  ),
                  new ListTile(
                    leading: new Icon(Icons.search),
                    title: new Text('Por descripción'),
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>SearchReportesItem(proyectoId: _proyectoId, proyecto: _proyectoTitle,)),
                      ).then((value) {
                        setState(() {});
                      },
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        }
    );
  }


  Future _showPicker2(context) async {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Galería de fotos'),
                      onTap: () async {
                        await _pickLogo();
                        Navigator.of(context).pop();
                        await Navigator.push(context,MaterialPageRoute(builder: (context) =>Rebuilder(),),);
                        // Navigator.push(context,MaterialPageRoute(builder: (context) =>Rebuilder(),),);
                        setState(() {
                          imageCache.evict(File(_itempic), includeLive: true);
                        });
                      }

                  ),
                ],
              ),
            ),
          );
        }
    );
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
        await _dbHelper.deleteProyecto(_proyectoId);
        Navigator.of(context).pop();
        Navigator.pop(context);
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Alerta"),
      content: Text("Está seguro que desea eliminar proyecto?"),
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


  @override
  Widget build(BuildContext context) {
    // final MyProvider = Provider.of<DemProvider>(context);
    return Scaffold(
      backgroundColor: Colors.grey[900],
      // appBar: MyAppBar('Datos y reportes de proyecto', context),
      appBar: AppBar(
        title: Text('Datos y reportes de proyecto',
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
              // await SaveUpdateProyecto(_proyectoTitle);
              Navigator.pop(context, true);
            }
        ),
      ),
      body: SafeArea(
        child: Container(
          child:
          Stack(
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
                          child: Text("Proyecto:",
                              textAlign: TextAlign.end,
                              style: TextStyle(
                                color: Colors.grey[400],
                                fontSize: 15,
                              )),
                        ),
                        Expanded(
                          flex: 1,
                          child: SizedBox(),
                        ),
                        Expanded(
                          flex: 15,
                          child: TextField(
                            autofocus: _proyecto == null ? true : false,
                            textCapitalization: TextCapitalization.sentences,
                            textInputAction: TextInputAction.done,
                            maxLines: null,
                            onChanged: (value) async {
                              _proyectoTitle = value;
                              await SaveUpdateProyecto(_proyectoTitle);
                              setState(() {
                                _proyectoTitle = value;
                              });
                            },
                            onSubmitted: (value) async {
                              await SaveUpdateProyecto(_proyectoTitle);
                            },
                            controller: TEController
                              ..text = _proyectoTitle,
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
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 3,
                        child: Text("Logo:",
                            textAlign: TextAlign.end,
                            style: TextStyle(
                              color: Colors.grey[400],
                              fontSize: 13,
                            )),
                      ),
                      Expanded(
                          flex: 2,
                          child: IconButton(
                            icon: Icon(
                              Icons.photo,
                              color: Colors.red[900],
                            ),
                            onPressed: () async {
                              await _showPicker2(context);
                              final path = await _loadLogo();
                              setState(() {
                                _itempic = path!;
                                _logoFuture = Future.value(path);
                              });
                            },
                          )
                      ),
                      Expanded(
                        flex: 1,
                        child: SizedBox(),
                      ),
                      Expanded(
                        flex: 14,
                        child: FutureBuilder(
                            future: _logoFuture,
                            builder: (context, snapshot) {
                              // Handle loading state with CircularProgressIndicator
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return Center(child: CircularProgressIndicator()); // Show loading while fetching logo
                              }
                              // Handle error state (if something went wrong)
                              if (snapshot.hasError) {
                                return Icon(Icons.error, color: Colors.red); // Show error icon if there's an issue
                              }

                              final logoPath = snapshot.data;
                              final hasLogo = logoPath != null && File(logoPath).existsSync(); // Sync is fine here for display

                              // If logo exists (snapshot.data is not null), show the logo image
                              if (snapshot.hasData && snapshot.data != null) {
                                _itempic = snapshot.data!; // Set the logo path
                              } else {
                                _itempic = ""; // Set to empty if no logo
                              }

                              return Container(
                                constraints: BoxConstraints(
                                  minHeight: 100,
                                  maxHeight: 125,
                                  minWidth: double.infinity,
                                ),
                                padding: EdgeInsets.all(5.0),
                                decoration: BoxDecoration(
                                  color: Colors.black12,
                                  // borderRadius: BorderRadius.circular(20.0),
                                ),
                                child: GestureDetector(
                                  onTap: hasLogo
                                      ? () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => Logopage(
                                          proyectoId: _proyectoId,
                                          logo: logoPath!,
                                        ),
                                      ),
                                    ).then((value) async {
                                      final updatedPath = await _loadLogo();
                                      imageCache.evict(File(updatedPath!), includeLive: true);
                                      setState(() {
                                        _itempic = updatedPath;
                                        _logoFuture = Future.value(updatedPath);
                                      });
                                    });
                                  }
                                      : null,
                                  child: GridTile(
                                    child: hasLogo
                                        ? Image.file(File(logoPath!))
                                        : Icon(Icons.photo, color: Colors.grey[400], size: 30),
                                  ),
                                ),
                              );
                            }
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 3),
                      child: FutureBuilder(
                        initialData: [],
                        // future: _dbHelper.getReports(),
                        future: _dbHelper.getProyectoReports(_proyectoId),
                        builder: (context, AsyncSnapshot snapshot) {
                          return ScrollConfiguration(
                            behavior: NoGlowBehaviour(),
                            child: ListView.builder(
                              // padding: const EdgeInsets.fromLTRB(3,0,3,3),
                              itemCount: snapshot.data.length,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => Reportpage(
                                          proyectoId: _proyectoId,
                                          ProyectTitle: _proyectoTitle,
                                          report: snapshot.data[index],
                                          proyecto: _proyecto,
                                        ),
                                      ),
                                    ).then(
                                          (value) {
                                        setState(() {});
                                      },
                                    );
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(3,5,3,3),
                                    child: TaskCardWidget(
                                      title: snapshot.data[index].title,
                                      date: snapshot.data[index].date,
                                      count: snapshot.data[index].count == null ? 0 : snapshot.data[index].count,
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  )
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
                    tooltip: 'Sincronizar',
                    color: _SyncColor,
                    iconSize: 45,
                    onPressed: () async {
                      // await SaveUpdateProyecto(_proyectoTitle);
                      if (user == null) {
                        await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => SignInScreenOnly(),
                          ),
                        );
                        await Authentication();
                        user = await FirebaseAuth.instance.currentUser;
                        setState(() {
                          user = user;
                          if (user != null) {
                            _SyncColor = Colors.green[800];
                            SyncSet = "Conectado";
                          }
                        });
                      }
                      await Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => DriveSyncScreen(ProyectoTitle: _proyectoTitle, DBProyectoId: _proyectoId, SyncType: "proyecto",),
                        ),
                      );
                      // await getDriveApi();
                      setState(() {
                        // SyncSet = true;
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
                tooltip: 'Borrar proyecto',
                color: Colors.grey[400],
                iconSize: 45,
                onPressed: () async {
                  FocusScope.of(context).requestFocus(FocusNode());
                  if(_proyectoId != 0) {
                    showDeleteDialog(context);
                  }
                },
              ),
            ),
            // Expanded(
            //   flex: 1,
            //   child: SizedBox(),
            // ),
            Expanded(
              flex: 1,
              child: IconButton(
                icon: Icon(Icons.search),
                tooltip: 'Buscar reporte',
                color: Colors.grey[400],
                iconSize: 45,
                onPressed: () {
                  _showPicker(context);
                },
              ),
            ),
            Expanded(
              flex: 1,
              child:IconButton(
                icon: Icon(Icons.add_circle),
                tooltip: 'Reporte nuevo',
                color: Colors.grey[400],
                // MyProvider.getLSel() != null &&
                // MyProvider.getApSel() != null
                // ? Colors.black
                // : Colors.grey[600],
                iconSize: 45,
                onPressed: () async {
                  // await SaveUpdateProyecto(_proyectoTitle);
                  FocusScope.of(context).requestFocus(FocusNode());
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Reportpage(
                          proyectoId: _proyectoId,
                          ProyectTitle: _proyectoTitle,
                          report: null,
                          proyecto: _proyecto,
                        )),
                  ).then((value) {
                    setState(() {});
                  },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}