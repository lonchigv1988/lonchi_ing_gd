// import 'package:date_field/date_field.dart';
// import 'dart:html';
import 'package:flutter/material.dart';
import 'package:lonchi_ing_gd/MyWidgets/MyAppBar.dart';
import 'dart:io';
import '../DB/MyDB.dart';
import 'package:photo_view/photo_view.dart';

class Logopage extends StatefulWidget {
  final int proyectoId;
  final String logo;

  Logopage({required this.proyectoId, required this.logo});

  @override
  _LogopageState createState() => _LogopageState();
}

class _LogopageState extends State<Logopage> {
  DatabaseHelper _dbHelper = DatabaseHelper();

  int _id = 0;
  int _proyectoId = 0;
  String _logopic = "";

  var _reportDateController = TextEditingController();

  bool _contentVisile = false;

  @override
  void initState() {
    // Set visibility to true
    _proyectoId = widget.proyectoId;
    // _id = widget.logo.id!;
    _logopic = widget.logo;
      super.initState();
  }

  @override
  void dispose() {
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
      child: Text("Confirmar"),
      onPressed:  () async {
        await _dbHelper.deleteLogo(_proyectoId);
        await File(_logopic).delete();
        Navigator.of(context).pop();
        Navigator.pop(context);
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Alerta"),
      content: Text("Está seguro que desea eliminar logo?"),
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
      appBar: MyAppBar('Logo de reportes para proyecto', context),
      body: SafeArea(
          child: Container(
              constraints: BoxConstraints.expand(height: 700),
              alignment: Alignment.center,
              child: PhotoView(imageProvider: FileImage(File(_logopic)),
              ))
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.red[900],
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: IconButton(
                icon: Icon(Icons.delete),
                color: Colors.grey[400],
                iconSize: 45,
                onPressed: () async {
                    showAlertDialog(context);
                },
              ),
            ),
            Expanded(
              flex: 2,
              child: SizedBox(),
            ),
            Expanded(
              flex: 1,
              child: SizedBox(),
            ),
          ],
        ),
      ),
    );
  }
}
