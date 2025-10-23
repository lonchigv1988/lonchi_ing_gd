import 'package:flutter/material.dart';
import 'package:lonchi_ing_gd/MyWidgets/MyAppBarTab.dart';
import 'package:lonchi_ing_gd/acero/WRes.dart';
import '../MyClasses/ResDef.dart';
import '../MyClasses/ResDeman.dart';

class Wresults extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return WresScreen();
  }
}


class WresScreen extends StatefulWidget {
  @override
  _WresScreenState createState() => _WresScreenState();
}

class _WresScreenState extends State<WresScreen> {

  List tabdet = [
    tab(txt:'Demanda', tabicon: Icon(Icons.vertical_align_bottom), func: ResDeman()),
    tab(txt:'Capacidad', tabicon: Icon(Icons.insert_chart), func: WRes()),
    tab(txt:'Deflex', tabicon: Icon(Icons.insert_chart), func: ResDef()),
    tab(txt:'Resumen', tabicon: Icon(Icons.calculate), func: WRes()),];



  @override
  Widget build(BuildContext context) {
    return MyAppBarTab(titulo: 'Resultados', listatab: tabdet);
  }
}
