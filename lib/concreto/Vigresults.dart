import 'package:flutter/material.dart';
import 'package:lonchi_ing_gd/MyWidgets/MyAppBarTab.dart';
import '../MyClasses/ResDef.dart';
import '../MyClasses/ResDeman.dart';
import 'VigCap.dart';
import 'VigRes.dart';

class Vigresults extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return VigresScreen();
  }
}


class VigresScreen extends StatefulWidget {
  @override
  _VigresScreenState createState() => _VigresScreenState();
}

class _VigresScreenState extends State<VigresScreen> {

  List tabdet = [
    tab(txt:'Demanda', tabicon: Icon(Icons.vertical_align_bottom), func: ResDeman()),
    tab(txt:'Capacidad', tabicon: Icon(Icons.insert_chart), func: VigCap()),
    tab(txt:'Deflex', tabicon: Icon(Icons.insert_chart), func: ResDef()),
    tab(txt:'Resumen', tabicon: Icon(Icons.calculate), func: VigRes()),];

  @override
  Widget build(BuildContext context) {
    return MyAppBarTab(titulo: 'Resultados', listatab: tabdet);
  }
}
