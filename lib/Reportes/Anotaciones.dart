import 'dart:io';
import 'package:external_path/external_path.dart';
import 'package:lonchi_ing_gd/DB/MyDB.dart';
import 'package:lonchi_ing_gd/MyClasses/MyPhotos.dart';
import 'package:flutter/material.dart';
import 'package:image_painter/image_painter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:intl/intl.dart';


class Anotaciones extends StatelessWidget {
  Anotaciones(this.photo, this.proyecto);
  final Photos photo;
  String proyecto;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: MyAppBar('Anotaciones', context),
      body: NotePage(photo,proyecto),
    );
  }
}

class NotePage extends StatefulWidget {
  Photos photo;
  String proyecto;
  NotePage(this.photo, this.proyecto);

  @override
  _NotePageState createState() => new _NotePageState();
}

class _NotePageState extends State<NotePage> {
  DatabaseHelper _dbHelper = DatabaseHelper();

  // bool _finished = false;
  final _imageKey = GlobalKey<ImagePainterState>();
  final _controller = ImagePainterController(
    color: Colors.red,
    strokeWidth: 4,
    mode: PaintMode.freeStyle,
    );
  final _key = GlobalKey<ScaffoldState>();

  bool _isButtonEnable = true;

  String _photoloc = "";
  String _newphotoloc = "";
  Photos? _photo;
  late String proyecto;

  // int _photoId = 0;
  int _proyectoId = 0;
  int _reportId = 0;
  int _itemId = 0;
  Photos? _newPhoto;

  GlobalKey<ImagePainterState> painterKey = GlobalKey<ImagePainterState>();

  saveImage() async {
    // ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(
    //       elevation: 6.0,
    //       duration: const Duration(seconds: 2),
    //       backgroundColor: Colors.red[900],
    //         shape: RoundedRectangleBorder(
    //             borderRadius: BorderRadius.all(Radius.circular(20))),
    //       // padding: const EdgeInsets.only(left: 10),
    //       content: Row(
    //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //         children: [
    //           const Text("ESPERAR",
    //               style: TextStyle(color: Colors.white)),
    //         ],
    //       ),
    //     ),
    // );

    // Show loading dialog with spinner
    showDialog(
      context: context,
      barrierDismissible: false, // prevent closing by tapping outside
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.black87,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.redAccent),
                ),
                const SizedBox(height: 16),
                Text(
                  "Guardando imagen...",
                  style: TextStyle(color: Colors.grey[400], fontSize: 16),
                ),
              ],
            ),
          ),
        );
      },
    );

    // Perform the actual saving
    final image = await _controller.exportImage();
    await _getDirectory(context, image, _itemId, _proyectoId, _reportId, proyecto);

    // Close the loading dialog
    Navigator.of(context).pop();

    // Show confirmation SnackBar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        elevation: 6.0,
        duration: const Duration(seconds: 1),
        backgroundColor: Colors.red[900],
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        content: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Imagen salvada", style: TextStyle(color: Colors.white)),
          ],
        ),
      ),
    );

    // ScaffoldMessenger.of(context).showSnackBar(
    //   SnackBar(
    //     elevation: 6.0,
    //     duration: const Duration(seconds: 1),
    //     backgroundColor: Colors.red[900],
    //     shape: RoundedRectangleBorder(
    //         borderRadius: BorderRadius.all(Radius.circular(20))),
    //     content: Row(
    //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //       children: [
    //         const Text("Imagen salvada",
    //             style: TextStyle(color: Colors.white)),
    //       ],
    //     ),
    //   ),
    // );
  }

  @override
  void initState() {
    _photo = widget.photo;
    _photoloc = widget.photo.photo!;
    _itemId = widget.photo.itemId;
    _proyectoId = widget.photo.proyectoId;
    _reportId = widget.photo.reportId;
    // _photoId = widget.photo.id!;
    proyecto = widget.proyecto;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      appBar: AppBar(
        title: Text("Anotaciones",
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
          onPressed: () => Navigator.pop(context, true),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
              color: Colors.grey[400],
            tooltip: 'Salvar',
            // onPressed: saveImage,
              onPressed: () async {
                if (_isButtonEnable) {
                  _isButtonEnable = false;
                  await saveImage();
                  setState(() {
                    _isButtonEnable = false;
                  });
                  Navigator.pop(context, true);
                }
              }
          )
        ],
      ),
      body: ImagePainter.file(
        controller: _controller,
        File(_photoloc),
        key: _imageKey,
        scalable: false,
      ),
    );
  }

  Future<bool> _requestPermission(Permission permission) async {
    if (await permission.isGranted) {
      return true;
    } else {
      var result = await permission.request();
      if (result == PermissionStatus.granted) {
        return true;
      }
    }
    return false;
  }

  _getDirectory(BuildContext context, image, int _itemId, int _proyectoId, int _reportId, String proyecto) async {
    DatabaseHelper _dbHelper = DatabaseHelper();
    final output = await ExternalPath.getExternalStoragePublicDirectory("Download");
    final FinalPath = await '$output/Lonchi-Ing/$proyecto/Fotos';
    if (await Directory(FinalPath).exists()){
      print ('Ya existe $FinalPath');
    } else{
      print ('NO existe $FinalPath');
      await new Directory(FinalPath).create(recursive: true);
    }
    DateTime now = DateTime.now();
    String nowtext = DateFormat('yyyy-MM-dd-(kk.mm.ss)').format(now);
    final path = (FinalPath + "/$nowtext.png");
    File(path).writeAsBytesSync(image);
    _newPhoto = Photos(itemId: _itemId,
        proyectoId: _proyectoId,
        reportId: _reportId,
        photo: path);
    await _dbHelper.insertPhoto(_newPhoto!);
  }
}
