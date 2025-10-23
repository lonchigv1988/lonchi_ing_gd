import 'package:external_path/external_path.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lonchi_ing_gd/MyClasses/MyItems.dart';
import 'package:lonchi_ing_gd/MyClasses/ReportWidgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lonchi_ing_gd/Reportes/Camera.dart';
import 'package:lonchi_ing_gd/Reportes/photopage.dart';
import 'package:lonchi_ing_gd/Reportes/reportpage.dart';
import 'dart:async';
import 'dart:io';
import '../DB/MyDB.dart';
import 'package:lonchi_ing_gd/MyClasses/Utility.dart';
import 'package:lonchi_ing_gd/MyClasses/MyPhotos.dart';
import 'package:camera/camera.dart';

import '../MyClasses/MyReport.dart';


class ItempageDesc extends StatefulWidget {
  
  final CameraDescription camera;
  final Items? item;
  final int? ReportNum;
  final int? ProyectoNum;
  String? proyecto;

  ItempageDesc({required this.camera, required this.item, this.ReportNum, this.ProyectoNum, this.proyecto});
  // ItempageDesc({@required this.item});

  @override
  _ItempageDescState createState() => _ItempageDescState();
}

class _ItempageDescState extends State<ItempageDesc> {
  DatabaseHelper _dbHelper = DatabaseHelper();

  TextEditingController TEController = new TextEditingController();
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  int _proyectoId = 0;
  int _reportId = 0;
  int _itemId = 0;
  String _itemDesc = "";
  String _proyectoTitle = "";
  File? _image;
  String? _itempic;
  Photos? _newPhoto;
  bool isCameraReady = false;
  bool showCapturedPhoto = false;
  String? ImagePath = null;
  Items? _item = null;
  late String proyecto;
  late Color _buttonColor;
  // final deviceRatio = 0;

  var _reportDateController = TextEditingController();

  bool _contentVisile = false;

  @override
  void initState() {
    super.initState();

    if (widget.item != null) {
      // Set visibility to true
      _contentVisile = true;
      _item = widget.item;
      _proyectoId = widget.item!.proyectoId!;
      _reportId = widget.item!.reportId!;
      _itemId = widget.item!.id!;
      _itemDesc = widget.item!.description!;
      TEController.text = widget.item!.description!;
      _buttonColor = Colors.grey[400]!;
      // _itempic = widget.item!.photo!;
    }
    else {
      _reportId = widget.ReportNum!;
      _proyectoId = widget.ProyectoNum!;
      _buttonColor = Colors.red[700]!;
    }

    if (widget.proyecto != null) {
      _proyectoTitle = widget.proyecto!;
    }
    else {
      _proyectoTitle = widget.proyecto!;
    }


    super.initState();
  }

  @override
  void dispose() {
    // TEController.dispose();
    super.dispose();
  }

  Future SaveUpdateItem(String value) async {
    if (value != "") {
      if (_item == null) {
        Items _newItem = Items(description: value, reportId: _reportId, proyectoId: _proyectoId);
        int aaa = await _dbHelper.insertItem(_newItem);
        await _dbHelper.updateReportCount(_reportId);
        await _dbHelper.updateItemDesc(_itemId, value);
        _itemId = aaa;
        _item = _newItem;
        setState(() {
          _buttonColor = Colors.red[700]!;
        });
        print("Item creado");
      }
      else {
        await _dbHelper.updateItemDesc(_itemId, value);
        print("Item actualizado");
      }
    }
  }

  void _logError(String code, String? message) {
    // ignore: avoid_print
    print('Error: $code${message == null ? '' : '\nError Message: $message'}');
  }


  Future _SaveFromCamera() async {
    if (ImagePath != null) {
      String imgString = Utility.base64String(File(ImagePath!).readAsBytesSync());
      // saveGallery(imgString);
      // _newPhoto = Photos(itemId: _itemId, reportId: _reportId, photo: imgString);
      _newPhoto = Photos(itemId: _itemId, proyectoId: _proyectoId, reportId: _reportId, photo: ImagePath);
      // await ImageGallerySaver.saveImage(Utility.dataFromBase64String(imgString));
      await _dbHelper.insertPhoto(_newPhoto!);
      // _dbHelper.savePhoto(_itemId, imgString);
      setState(() {
        _image = File(ImagePath!);
        _itempic = imgString;
      });
    }
  }

  Future _imgFromGallery() async {
    XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 100);
    if (image != null) {
      final output = await ExternalPath.getExternalStoragePublicDirectory("Download");
      final FinalPath = await '$output/Lonchi-Ing/$_proyectoTitle/Fotos';
      if (await Directory(FinalPath).exists()){
        print ('Ya existe $FinalPath');
      } else{
        print ('NO existe $FinalPath');
        await new Directory(FinalPath).create(recursive: true);
      }
      String imgString = Utility.base64String(File(image.path).readAsBytesSync());
      DateTime now = DateTime.now();
      String nowtext = DateFormat('yyyy-MM-dd-(kk.mm.ss)').format(now);
      final path = (FinalPath + "/$nowtext.jpeg");
      image.saveTo(path);
      _newPhoto = Photos(itemId: _itemId, proyectoId: _proyectoId, reportId: _reportId, photo: path);
      await _dbHelper.insertPhoto(_newPhoto!);
      setState(() {
        _image = File(path);
        _itempic = imgString;
      });
    }
  }


  void showAlertDialog(BuildContext context) {
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
        await _dbHelper.deleteItem(_itemId,_reportId);
        Navigator.of(context).pop();
        Navigator.pop(context);
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Alerta"),
      content: Text("Está seguro que desea eliminar item?"),
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
    return Scaffold(
      backgroundColor: Colors.grey[900],
      // appBar: MyAppBar('Ingreso de item', context),
      appBar: AppBar(
        title: Text('Ingreso de item',
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
              await SaveUpdateItem(_itemDesc);
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
                  // Add this in your Column before the description Row
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
                    child: FutureBuilder<Report?>(
                      future: _dbHelper.getReport(_reportId), // fetch the report
                      builder: (context, snapshot) {
                        if (!snapshot.hasData || snapshot.data == null) {
                          return SizedBox(); // or CircularProgressIndicator()
                        }

                        Report report = snapshot.data!;

                        return FutureBuilder<Proyecto?>(
                          future: _dbHelper.getProyectoById(_proyectoId),
                          builder: (context, proyectoSnapshot) {
                            if (!proyectoSnapshot.hasData ||
                                proyectoSnapshot.data == null) {
                              return SizedBox(); // or CircularProgressIndicator()
                            }

                            Proyecto _proyecto = proyectoSnapshot.data!;

                            return ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blueGrey[700],
                              ),
                              icon: Icon(Icons.assignment, color: Colors.grey[400],),
                              label: Text("Ir al reporte",
                              style: TextStyle(color: Colors.grey[400]),),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        Reportpage(
                                          proyectoId: _proyectoId,
                                          ProyectTitle: _proyectoTitle,
                                          report: report,
                                          proyecto: _proyecto,
                                        ),
                                  ),
                                ).then((value) {
                                  setState(() {}); // refresh if needed
                                });
                              },
                            );
                          },
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      top: 12.0,
                      bottom: 6.0,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      // mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 1,
                          child: SizedBox(),
                        ),
                        Expanded(
                          flex: 5,
                          child: Text("Descripción:",
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
                          flex: 14,
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            decoration: BoxDecoration(
                              color: Colors.grey[800],
                              border: Border.all(color: Colors.grey[600]!),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: TextField(
                              autofocus: _item == null ? true : false,
                              textCapitalization: TextCapitalization.sentences,
                              textInputAction: TextInputAction.done,
                              maxLines: null,
                              onChanged: (value) async {
                                _contentVisile = true;
                                _itemDesc = value;
                              },
                              onSubmitted: (value) async {
                                await SaveUpdateItem(_itemDesc);
                              },
                              controller: TEController
                                ..text = _itemDesc,
                                // ..selection = TextSelection.fromPosition(TextPosition(offset: TextEditingController().text.length)),
                              decoration: InputDecoration(
                                hintText: "Ingresar descripción",
                                hintStyle: TextStyle(
                                    fontSize: 15.0,
                                    color: Colors.grey[400],
                                    fontStyle: FontStyle.italic),
                                border: InputBorder.none,
                              ),
                              style: TextStyle(
                                fontSize: 15.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[400],
                              ),
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
                  SizedBox(
                    height: 32,
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(1.0),
                      child: FutureBuilder(
                        initialData: [],
                        future: _dbHelper.getItemPhotos(_itemId),
                        builder: (context, AsyncSnapshot snapshot) {
                          return ScrollConfiguration(
                            behavior: NoGlowBehaviour(),
                            child: GridView.builder(
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                              childAspectRatio: 1.0,
                              mainAxisSpacing: 4.0,
                              crossAxisSpacing: 4.0),
                              // padding: const EdgeInsets.fromLTRB(3,0,3,3),
                              // itemCount: 3,
                              itemCount: snapshot.data.length,
                            // itemCount: (snapshot.data.toList()).length,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => Photopage(
                                          photo: snapshot.data[index],
                                          proyecto: _proyectoTitle,
                                        ),
                                      ),
                                    ).then(
                                          (value) {
                                        setState(() {});
                                      },
                                    );
                                  },
                                  child: PhotoWidget(
                                    photo: snapshot.data[index].photo,
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
        color: Colors.red[900],
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: IconButton(
                icon: Icon(Icons.delete),
                tooltip: 'Borrar item',
                color: Colors.grey[400],
                // _itemId == 0
                //     ? Colors.red[700]
                //     : Colors.grey[400],
                iconSize: 45,
                onPressed: () async {
                  // await _dbHelper.getphotocount(_itemId).then((val){
                  //   print ('Fotos en item: $val');
                  // });
                  if(_itemId != 0) {
                    showAlertDialog(context);
                  }
                },
              ),
            ),
            Expanded(
              flex: 1,
              child: SizedBox(),
            ),
            Expanded(
              flex: 1,
              child: IconButton(
                icon: Icon(Icons.photo_library),
                tooltip: 'Agregar de galería',
                color: _itemId == 0
                    ? Colors.red[700]
                    : Colors.grey[400],
                iconSize: 45,
                onPressed: () async {
                  await SaveUpdateItem(_itemDesc);
                  if(_itemId != 0) {
                    _imgFromGallery();
                    // Navigator.of(context).pop();
                  }
                },
              ),
            ),
            Expanded(
              flex: 1,
              child: IconButton(
                icon: Icon(Icons.camera_alt),
                tooltip: 'Agregar de cámara',
                color: _itemId == 0
                    ? Colors.red[700]
                    : Colors.grey[400],
                iconSize: 45,
                onPressed: () async {
                  await SaveUpdateItem(_itemDesc);
                  // FocusScope.of(context).requestFocus(FocusNode());
                  if(_itemId != 0) {
                    final allcameras = await availableCameras();
                    try {
                      WidgetsFlutterBinding.ensureInitialized();

                    } on CameraException catch (e) {
                      _logError(e.code, e.description);
                    }
                    final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CameraHome(
                                allcameras: allcameras, proyecto: _proyectoTitle)));
                    setState(() {
                      ImagePath = result;
                    });
                    // Navigator.of(context).pop();
                    if (ImagePath != null) {
                      await _SaveFromCamera();
                    }
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