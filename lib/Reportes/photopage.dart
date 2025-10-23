import 'package:flutter/material.dart';
import 'package:lonchi_ing_gd/MyWidgets/MyAppBar.dart';
import 'dart:async';
import 'dart:io';
import '../DB/MyDB.dart';
import 'package:lonchi_ing_gd/MyClasses/MyPhotos.dart';
import 'package:photo_view/photo_view.dart';

import 'Anotaciones.dart';

class Photopage extends StatefulWidget {
  final Photos photo;
  String proyecto;

  Photopage({required this.photo, required this.proyecto});
  // Photopage({@required this.item});

  @override
  _PhotopageState createState() => _PhotopageState();
}

class _PhotopageState extends State<Photopage> {
  DatabaseHelper _dbHelper = DatabaseHelper();

  int _reportId = 0;
  int _itemId = 0;
  int _id = 0;
  late String _photoloc;
  late Photos _photo;
  late String proyecto;

  var _reportDateController = TextEditingController();

  bool _contentVisile = false;

  @override
  void initState() {
    // Set visibility to true
    _contentVisile = true;

    _photo = widget.photo;
    _id = widget.photo.id!;
    _reportId = widget.photo.reportId;
    _itemId = widget.photo.id!;
    _photoloc = widget.photo.photo!;
    proyecto = widget.proyecto;
      // else {
    //   _reportId = widget.ReportNum;
    // }
    super.initState();
  }

  @override
  void dispose() {
    // _titleFocus.dispose();
    // _dateFocus.dispose();
    // _descriptionFocus.dispose();
    // _todoFocus.dispose();
    super.dispose();
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
      child: SizedBox(
          width: 180,
          child: Text(
            "Confirmar (eliminar solo en app)",
            textAlign: TextAlign.end,
          ),
      ),
      onPressed:  () async {
        await _dbHelper.deletePhoto(_id);
        Navigator.of(context).pop();
        Navigator.pop(context);
      },
    );
    Widget continueAllButton = TextButton(
      child: SizedBox(
          width: 180,
          child: Text(
            "Confirmar (eliminar COMPLETAMENTE)",
            textAlign: TextAlign.end,
          ),
      ),
      onPressed:  () async {
        await _dbHelper.deletePhoto(_id);
        await File(_photoloc).delete();
        Navigator.of(context).pop();
        Navigator.pop(context);
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Alerta"),
      content: Text("Está seguro que desea eliminar foto?"),
      actions: [
        continueButton,
        continueAllButton,
        cancelButton,
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
      appBar: MyAppBar('Foto', context),
      body: SafeArea(
          child: Container(
            constraints: BoxConstraints.expand(height: 700),
            alignment: Alignment.center,
            child: PhotoView(
              imageProvider: FileImage(File(_photoloc)),
            ),
          )
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.red[900],
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: IconButton(
                icon: Icon(Icons.delete),
                tooltip: 'Borrar foto',
                color: Colors.grey[400],
                iconSize: 45,
                onPressed: () async {
                  if(_id != 0) {
                    showAlertDialog(context);
                  }
                },
              ),
            ),
            Expanded(
              flex: 2,
              child: SizedBox(),
            ),
            Expanded(
              flex: 1,
              child:IconButton(
                icon: Icon(Icons.create),
                tooltip: 'Agregar notas foto',
                color:
                _reportId == 0
                    ? Colors.red[700]
                    : Colors.grey[400],
                iconSize: 45,
                onPressed: () async {
                  if(_reportId != 0) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        // builder: (context) => LonchiNotas(_photo),
                        builder: (context) => Anotaciones(_photo,proyecto),
                      ),
                    ).then(
                          (value) {
                        setState(() {
                          _photoloc = _photo.photo!;
                        });
                        Timer(Duration(milliseconds: 100), () {
                          Navigator.pop(context, true);
                        });
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
