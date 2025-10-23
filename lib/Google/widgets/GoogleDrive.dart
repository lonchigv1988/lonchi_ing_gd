import 'dart:async';
import 'dart:io' as io;

import 'package:flutter/material.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:lonchi_ing_gd/Google/utils/show_dialog.dart';
import 'package:path/path.dart' as Path;
import '../../DB/MyDB.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

class GoogleAuthClient extends http.BaseClient {
  final Map<String, String> _headers;
  final _client = new http.Client();

  GoogleAuthClient(this._headers);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    request.headers.addAll(_headers);
    return _client.send(request);
  }
}

class DriveSyncScreen extends StatefulWidget {
  final String? ProyectoTitle;
  final String? DocTitle;
  final int? DBProyectoId;
  final int? DBReportId;
  final String? SyncType;
  DriveSyncScreen ({this.ProyectoTitle, this.DBProyectoId, this.SyncType, this.DocTitle, this.DBReportId});
  
  @override
  _DriveSyncScreen createState() => _DriveSyncScreen();
}

class _DriveSyncScreen extends State<DriveSyncScreen> {
  bool _synced = false;
  DatabaseHelper _dbHelper = DatabaseHelper();
  late String _proyectoTitle;
  late String _DocTitle;
  late String _SyncType;
  late int _DBproyectoID;
  late int _DBreporteID;
  late List fotos;
  late bool _loginStatus;
  final googleSignIn = GoogleSignIn.standard(scopes: [
    drive.DriveApi.driveAppdataScope,
    drive.DriveApi.driveFileScope,
  ]);
  User? user = null;
  String? Estado = "";
  String? Progreso;
  double _ValorProgreso = 0;

  @override
  void initState() {
    Progreso = "";
    user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _loginStatus = true;
    } else {
      _loginStatus = false;
    }
    _proyectoTitle = widget.ProyectoTitle!;
    if (widget.SyncType == "proyecto") {
      _DBproyectoID = widget.DBProyectoId!;
    }
    if (widget.SyncType == "reporte") {
      _DBreporteID = widget.DBReportId!;
    }
    if (widget.SyncType == "documento") {
      _DocTitle = widget.DocTitle!;
    }

    _SyncType = widget.SyncType!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(backgroundColor: Colors.grey[900],
        appBar: AppBar(
          title: Text("Sincronizar con Google",
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
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        body: _createBody(context),
      ),
    );
  }

  Widget _createBody(BuildContext context) {
    final Sincronizar = Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: _synced
            ? CircularProgressIndicator(
          // value: _ValorProgreso,
          // color: Colors.green,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
        )
            : OutlinedButton(
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all(Colors.white),
            shape: WidgetStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(40),
              ),
            ),
          ),
          onPressed: () async {
            setState(() {
              _synced = true;
            });
            setState(() {
              _synced = false;
            });
            try {
              // Prevenir que el dispositivo entre en modo suspensión
              await WakelockPlus.enable();
              setState(() {
                WakelockPlus.enable();
              });

              if (_SyncType == "proyecto") {
                Estado = await _SincronizarProyecto(
                    _proyectoTitle, _DBproyectoID);
              }
              if (_SyncType == "reporte") {
                Estado = await _SincronizarReporte(
                    _proyectoTitle, _DBreporteID);
              }
              if (_SyncType == "documento") {
                Estado = await _SincronizarDoc(
                    _proyectoTitle, _DocTitle);
              }

              setState(() {
                Estado = Estado;
              });

            } finally {
              // Restaurar el comportamiento normal del dispositivo
              await WakelockPlus.disable();
              setState(() {
                _synced = false;
                WakelockPlus.disable();
              });
            }
          },
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image(
                  image: AssetImage("assets/Lonchi-ing-round.png"),
                  height: 37,
                ),
                Image(
                  image: AssetImage("assets/google_logo.png"),
                  height: 37,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text(_SyncType == "documento" ?
                    'Sincronizar documento' : 'Sincronizar fotos $_SyncType',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black54,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      );

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Center(child: Sincronizar),
        Center(child: Text("Estado de conexión: ${_loginStatus ? "Conectado" : "Desconectado"}", style: TextStyle(color: Colors.grey[400]),)),
        Center(child: Text(Progreso!, style: TextStyle(color: Colors.grey[400]),)),
        Center(child: Text(Estado!, style: TextStyle(color: Colors.grey[400]),)),
        // Divider(),
        // Center(child: signIn),
      ],
    );
  }

    Future<drive.DriveApi?> _getDriveApi() async {
    final googleUser = await googleSignIn.signIn();
    final headers = await googleUser?.authHeaders;
    if (headers == null) {
      await showMessage(context, "Sign-in first", "Error");
      return null;
    }

    final client = GoogleAuthClient(headers);
    final driveApi = drive.DriveApi(client);
    return driveApi;
  }

  Future<String?> _BuscarFolder(String _FolderName, String _FolderLocation, _driveApi) async {
    String? FolderId;
    String? FolderLocation = await _FolderLocation;
    final driveApi = _driveApi;
    final mimeType = "application/vnd.google-apps.folder";

    // Se busca/crea folder y se determina su ID
    final FindFolder = await driveApi.files.list(
      q: "mimeType = '$mimeType' and name = '$_FolderName' and trashed=false and '$FolderLocation' in parents",
      $fields: "files(id, name)",
    );
    final FoundFolder = await FindFolder.files;
    if (FoundFolder!.isNotEmpty) {
      FolderId = await FoundFolder.first.id;
    }
    else {
      // Crear folder
      var folder = new drive.File();
      folder.name = _FolderName;
      folder.mimeType = mimeType;
      folder.parents = ['$FolderLocation'];
      final folderCreation = await driveApi.files.create(folder);
      FolderId = folderCreation.id;
    }
    return FolderId;
  }

  Future _BuscarFotos(String _FotoLocation, _driveApi) async {
    final driveApi = _driveApi;
    String? FotoLocation = await _FotoLocation;

    final mimeType = "application/vnd.google-apps.folder";

    // Se buscan fotos en folder y se determina su ID
    final FindFoto = await driveApi?.files.list(
      q: "mimeType != '$mimeType' and trashed=false and '$FotoLocation' in parents",
      $fields: "files(id, name)",
    );
    final FoundFoto = await FindFoto?.files;
    return FoundFoto;
  }

  Future<String?> _SubirFotos(String _FotoName, List? _FotoList, String _FotoLocation, _driveApi) async {
    final driveApi = _driveApi;
    String? _FotoId;
    String? BaseFotoName = Path.basename(_FotoName);
    String? FotoLocation = await _FotoLocation;
    List? FoundFotos = _FotoList;
    Iterable? FoundFoto = [];

    FoundFoto = await FoundFotos?.where((f) => f.name == BaseFotoName);
    // print('Fotos encontradas totales ${FoundFotos?.length}');

    if (FoundFoto!.isNotEmpty) {
      // print('Fotos con nombre ${FoundFoto.length}');
      _FotoId = await FoundFoto.first.id;
      // print(_FotoId);
      // await driveApi.files.delete(_FotoId!);
    }
    else {
      // Crear foto
      var foto = new io.File(_FotoName);
      var drivefoto = new drive.File();
      drivefoto.name = BaseFotoName;
      drivefoto.parents = ['$FotoLocation'];
      var FotoCreation = await driveApi.files.create(
        drivefoto,
        uploadMedia: drive.Media(foto.openRead(), foto.lengthSync()),
      );
      _FotoId =  FotoCreation.id;
      // print(_FotoId);
    }
    return null;
  }

  Future _BuscarDoc(String _DocLocation, _driveApi) async {
    final driveApi = _driveApi;
    String? _FotoId;
    String? DocLocation = await _DocLocation;

    final mimeType = "application/vnd.google-apps.folder";

    // Se buscan docs en folder y se determina su ID
    final FindDoc = await driveApi?.files.list(
      q: "mimeType != '$mimeType' and trashed=false and '$DocLocation' in parents",
      $fields: "files(id, name)",
    );
    final FoundDoc = await FindDoc?.files;
    return FoundDoc;
  }

  Future<String?> _SubirDoc(String _DocName, List? _DocList, String _DocLocation, _driveApi) async {
    final driveApi = _driveApi;
    String? _DocId;
    String? BaseDocName = Path.basename(_DocName);
    String? DocLocation = await _DocLocation;
    List? FoundDocs = _DocList;
    Iterable? FoundDoc = [];
    var body_value;
    var response;

    FoundDoc = await FoundDocs?.where((f) => f.name == BaseDocName);


    if (FoundDoc!.isNotEmpty) {
      _DocId = await FoundDoc.first.id;
      response = await _driveApi.files.delete(_DocId);
    }

    // Crear doc
    var doc = new io.File(_DocName);
    var drivedoc = new drive.File();
    drivedoc.name = BaseDocName;
    drivedoc.parents = ['$_DocLocation'];
    var DocCreation = await driveApi.files.create(
      drivedoc,
      uploadMedia: drive.Media(doc.openRead(), doc.lengthSync()),
    );
    _DocId =  await DocCreation.id;
    return null;
    // print(_FotoId);
  }

  Future<List> _IdProyectoFolder(String _ProyectoName) async {
    String _ParentName = "App Lonchi-Ing";
    String _ParentLocation = "root";
    late String? ParentFolderId;
    late String? ProyectoFolderId;
    late String? FotosFolderId;

    final driveApi = await _getDriveApi();
    final mimeType = "application/vnd.google-apps.folder";

    ParentFolderId = await _BuscarFolder(_ParentName, _ParentLocation, driveApi);
    // print(ParentFolderId);

    ProyectoFolderId = await _BuscarFolder(_ProyectoName, ParentFolderId!, driveApi);
    // print(ProyectoFolderId);

    // await _BuscarFolder("Fotos", ProyectoFolderId!);
    // await _BuscarFolder("Reportes inspección", ProyectoFolderId!);

    // return ProyectoFolderId;
    return [ProyectoFolderId, driveApi];
  }

  Future<String?> _SincronizarProyecto(String _ProyectoName, int _DBProyectoId) async {
    String? ProyectoFolderId;
    String? FotoFolderId;
    List? FotosProyecto;
    var ResProyectoId;
    final driveApi;
    _ValorProgreso = 0.0;

    // Indicador de proceso
    IndicadorProgresoReal(context, _ValorProgreso);

    List fotos = await _dbHelper.getProyectoPhotos(_DBProyectoId);

    ResProyectoId = await _IdProyectoFolder(_ProyectoName);
    ProyectoFolderId = ResProyectoId[0];
    driveApi = ResProyectoId[1];

    FotoFolderId = await _BuscarFolder("Fotos", ProyectoFolderId!, driveApi);
    FotosProyecto = await _BuscarFotos(FotoFolderId!, driveApi);

    if(fotos.isNotEmpty) {
      for (var i = 0; i <= fotos.length - 1; i++) {
        await _SubirFotos(fotos[i].photo, FotosProyecto, FotoFolderId, driveApi);
        print('Foto ${i+1} sincronizada');
        Progreso = 'Fotos sincronizadas: ${i+1}/${fotos.length}';
        _ValorProgreso = (i+1)/fotos.length;
        print (_ValorProgreso);
        Navigator.pop(context);
        IndicadorProgresoReal(context, _ValorProgreso);
        setState(() {
          _ValorProgreso = (i+1)/fotos.length;
          Progreso = Progreso;
        });
      }
    }
    print('PROYECTO SINCRONIZADO CON LA NUBE');

    // Remove a dialog
    Timer(Duration(milliseconds: 200),(){
      Navigator.pop(context);
    });
    return 'Fotos del proyecto sincronizadas con la nube';
  }

  Future<String?> _SincronizarReporte(String _ProyectoName, int _DBReporteId) async {
    String? ProyectoFolderId;
    String? FotoFolderId;
    List? FotosProyecto;
    var ResProyectoId;
    final driveApi;
    _ValorProgreso = 0.0;

    // Indicador de proceso
    IndicadorProgresoReal(context, _ValorProgreso);

    List fotos = await _dbHelper.getReportPhotos(_DBReporteId);

    ResProyectoId = await _IdProyectoFolder(_ProyectoName);
    ProyectoFolderId = ResProyectoId[0];
    driveApi = ResProyectoId[1];

    FotoFolderId = await _BuscarFolder("Fotos", ProyectoFolderId!, driveApi);
    FotosProyecto = await _BuscarFotos(FotoFolderId!, driveApi);

    if(fotos.isNotEmpty) {
      for (var i = 0; i <= fotos.length - 1; i++) {
        await _SubirFotos(fotos[i].photo, FotosProyecto, FotoFolderId, driveApi);
        print('Foto ${i+1} sincronizada');
        Progreso = 'Fotos sincronizadas: ${i+1}/${fotos.length}';
        _ValorProgreso = (i+1)/fotos.length;
        print (_ValorProgreso);
        Navigator.pop(context);
        IndicadorProgresoReal(context, _ValorProgreso);
        setState(() {
          _ValorProgreso = (i+1)/fotos.length;
          Progreso = Progreso;
        });
      }

    }
    print('DOCUMENTO SINCRONIZADO CON LA NUBE');

    // Remove a dialog
    Timer(Duration(milliseconds: 200),(){
      Navigator.pop(context);
    });
    return 'Fotos del reporte sincronizadas con la nube';
  }

  Future<String?> _SincronizarDoc(String _ProyectoName, String _DocName) async {
    String? ProyectoFolderId;
    String? DocFolderId;
    List? DocsProyecto;
    var ResProyectoId;
    final driveApi;
    // String? DocName = _DocName;
    //
    // Indicador de proceso
    IndicadorProgresoGeneral(context);
    ResProyectoId = await _IdProyectoFolder(_ProyectoName);
    ProyectoFolderId = ResProyectoId[0];
    driveApi = ResProyectoId[1];
    DocFolderId = await _BuscarFolder("Reportes inspección", ProyectoFolderId!, driveApi);

    DocsProyecto = await _BuscarDoc(DocFolderId!, driveApi);
    await _SubirDoc(_DocName, DocsProyecto, DocFolderId, driveApi);
    print('DOCUMENTO SINCRONIZADO CON LA NUBE');
    // Remove a dialog
    Navigator.pop(context);
    return 'Documento sincronizado con la nube';
  }
}

IndicadorProgresoGeneral(context) {
  showGeneralDialog(
    context: context,
    barrierDismissible: false,
    transitionDuration: Duration(milliseconds: 200),
    barrierColor: Colors.black.withOpacity(0.5),
    pageBuilder: (context, animation, secondaryAnimation) => Center(
      child: SizedBox(
        height: 50,
        width: 50,
        child: ProgresoCircular(),
      ),
    ),
  );
}

IndicadorProgresoReal(context, _valor) {
  showGeneralDialog(
    context: context,
    barrierDismissible: false,
    transitionDuration: Duration(milliseconds: 200),
    barrierColor: Colors.black.withOpacity(0.5),
    pageBuilder: (context, animation, secondaryAnimation) => Center(
      child: Stack(
          children: [
            SizedBox(
              height: 75,
              width: 75,
              child: CircularProgressIndicator(
                  value: _valor,
                  backgroundColor: Colors.white,
                  color: Colors.white,
                  strokeWidth: 10.0,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.green)
              ),
            ),
            Positioned(
              left: 12.5,
              top: 12.5,
              child: SizedBox(
                height: 50,
                width: 50,
                child: ProgresoCircular(),
              ),
            )
          ]
      ),
    ),
  );
}

ProgresoCircular() {
  return CircularProgressIndicator(
      backgroundColor: Colors.blue,
      strokeWidth: 7.5,
      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
  );
}