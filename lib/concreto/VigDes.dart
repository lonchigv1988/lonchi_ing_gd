import 'package:flutter/material.dart';
import 'package:lonchi_ing_gd/MyWidgets/MyAppBarTab.dart';
import 'package:lonchi_ing_gd/MyWidgets/MyTab_VigCon.dart';
import 'package:lonchi_ing_gd/concreto/VigDesEle.dart';
import 'package:lonchi_ing_gd/MyClasses/Demanda.dart';

import 'VigDesRef.dart';
import 'Vigresults.dart';


class VigDes extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return VigDesScreen();
  }
}

class VigDesScreen extends StatefulWidget {
  @override
  _VigDesScreenState createState() => _VigDesScreenState();
}

class _VigDesScreenState extends State<VigDesScreen> with AutomaticKeepAliveClientMixin{

  @override
  bool get wantKeepAlive => true;

  List tabdet = [
    tab(txt:'Propiedades', tabicon: Icon(Icons.edit), func: VigDesEle()),
    tab(txt:'Refuerzo', tabicon: Icon(Icons.apps_rounded), func: VigDesRef()),
    tab(txt:'Demanda', tabicon: Icon(Icons.vertical_align_bottom), func: Dem()),
  ];

  // int i=1;
  // WProp2 Wtype;
  // WProp WSelted;
  // Deman DemandSel;


  @override
  Widget build(BuildContext context) {
    // final SecProvider = Provider.of<WProvider>(context, listen: false);
    // final MyProvider = Provider.of<DemProvider>(context, listen: false);

    return MyTab_VigCon(
      titulo: 'Diseño de vigas concreto',
      listatab: tabdet,
      loc: Vigresults(),
    );
  }
}
