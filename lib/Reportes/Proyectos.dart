import 'package:camera/camera.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lonchi_ing_gd/DB/MyDB.dart';
import 'package:lonchi_ing_gd/Google/utils/authentication.dart';
import 'package:lonchi_ing_gd/MyClasses/ReportWidgets.dart';
import 'package:lonchi_ing_gd/Reportes/Search-proyectos.dart';
import 'package:lonchi_ing_gd/MyWidgets/MyAppBar.dart';
import 'dart:io';
import 'package:lonchi_ing_gd/MyClasses/MyPhotos.dart';
import 'package:permission_handler/permission_handler.dart';
import '../Google/screens/sign_in_screen_only.dart';
import 'Reportes.dart';


class Proyectos extends StatefulWidget {
  // final Logo logo;
  // Proyectos ({this.logo});

  @override
  ProyectosState createState() {
    return ProyectosState();
  }
}

class ProyectosState extends State<Proyectos> {
  DatabaseHelper _dbHelper = DatabaseHelper();

  late File _image;
  String _itempic = "";
  late Logo _newPhoto;
  User? user = null;
  var _SyncColor = Colors.grey[400];
  String SyncSet = "Desconectado";

  @override
  void initState() {
    user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _SyncColor = Colors.green[800];
      SyncSet = "Conectado";
    }
    super.initState();
  }

    onButtonTap(Widget page) {
    Navigator.push(
        context, MaterialPageRoute(builder: (BuildContext context) => page));
    // Navigator.push(
    // context, MaterialPageRoute(builder: (BuildContext context) => page));
  }


  @override
  Widget build(BuildContext context) {
    // final MyProvider = Provider.of<DemProvider>(context);
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: MyAppBar('Proyectos', context),
      body: SafeArea(
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          color: Colors.grey[900],
          child:
          Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 3),
                      child: FutureBuilder(
                        initialData: [],
                        future: _dbHelper.getProyectos(),
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
                                        builder: (context) => Reportes(
                                          proyecto: snapshot.data[index],
                                          // logo: _dbHelper.getLogo(index)[0],
                                          // report: snapshot.data[index],
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
                                    child: ProyectoWidget(
                                      title: snapshot.data[index].title,
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
                    tooltip: 'Estado con Google Drive',
                    color: _SyncColor,
                    iconSize: 45,
                    onPressed: () async {
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
              child: SizedBox(),
            ),
            Expanded(
              flex: 1,
              child: IconButton(
                icon: Icon(Icons.search),
                tooltip: 'Buscar proyecto',
                color: Colors.grey[400],
                iconSize: 45,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>SearchProyectosTitulo()),
                  ).then((value) {
                    setState(() {});
                  },
                  );
                },
              ),
            ),
            Expanded(
              flex: 1,
              child:IconButton(
                icon: Icon(Icons.add_circle),
                tooltip: 'Proyecto nuevo',
                color: Colors.grey[400],
                // MyProvider.getLSel() != null &&
                // MyProvider.getApSel() != null
                // ? Colors.black
                // : Colors.grey[600],
                iconSize: 45,
                onPressed: () async {
                  await availableCameras();
                  //Pedir permisos necesarios:
                  Map<Permission, PermissionStatus> statuses = await [
                    Permission.camera,
                    // Permission.storage,
                    Permission.microphone,
                    Permission.photos,
                  ].request();
                  int count = 0;
                  for (var key in statuses.keys) {
                    if (statuses[key]!.isDenied) {
                      await key.request();
                    }
                    else {
                      count = count + 1;
                      // print(count);
                    }
                  }
                  if (count == statuses.length) {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Reportes(
                            proyecto: null,
                          )),
                    ).then((value) {
                      setState(() {});
                    },
                    );
                  }
                  else {
                    AlertaPermisos(context);
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

void AlertaPermisos(BuildContext context) {
  // set up the buttons
  Widget cancelButton = TextButton(
    child: Text("Cancelar"),
    onPressed:  () {
      Navigator.of(context).pop();
    },
  );
  Widget continueButton = TextButton(
    child: Text("Ir a configuración"),
    onPressed:  () async {
      await  openAppSettings();
      // int count = 2;
      // Navigator.of(context).popUntil((_) => count-- <= 0);
      // Navigator.of(context).pop();
      // Navigator.pop(context);
    },
  );
  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Alerta"),
    content: Text("Se necesita otorgar permisos para continuar"),
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