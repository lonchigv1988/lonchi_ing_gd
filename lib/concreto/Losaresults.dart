import 'package:flutter/material.dart';
import 'package:lonchi_ing_gd/MyWidgets/MyAppBarTab.dart';
import '../MyClasses/ResDef.dart';
import '../MyClasses/ResDeman.dart';
import 'LosaCap.dart';
import 'LosaRes.dart';

class Losaresults extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return LosaresScreen();
  }
}


class LosaresScreen extends StatefulWidget {
  @override
  _LosaresScreenState createState() => _LosaresScreenState();
}

class _LosaresScreenState extends State<LosaresScreen> {

  List tabdet = [
    tab(txt:'Demanda', tabicon: Icon(Icons.vertical_align_bottom), func: ResDeman()),
    tab(txt:'Capacidad', tabicon: Icon(Icons.insert_chart), func: LosaCap()),
    tab(txt:'Deflex', tabicon: Icon(Icons.insert_chart), func: ResDef()),
    tab(txt:'Resumen', tabicon: Icon(Icons.calculate), func: LosaRes()),];

  @override
  Widget build(BuildContext context) {
    return MyAppBarTab(titulo: 'Resultados', listatab: tabdet);
  }
}
