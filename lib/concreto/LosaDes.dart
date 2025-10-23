import 'package:flutter/material.dart';
import 'package:lonchi_ing_gd/MyWidgets/MyAppBarTab.dart';
import 'package:lonchi_ing_gd/MyWidgets/MyTab_LosaCon.dart';
import 'package:lonchi_ing_gd/concreto/LosaDesEle.dart';
import 'package:lonchi_ing_gd/concreto/LosaDesRef.dart';
import 'package:lonchi_ing_gd/MyClasses/Demanda.dart';
import 'Losaresults.dart';


class LosaDes extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LosaDesScreen();
  }
}

class LosaDesScreen extends StatefulWidget {
  @override
  _LosaDesScreenState createState() => _LosaDesScreenState();
}

class _LosaDesScreenState extends State<LosaDesScreen> with AutomaticKeepAliveClientMixin{

  @override
  bool get wantKeepAlive => true;

  List tabdet = [
    tab(txt:'Propiedades', tabicon: Icon(Icons.edit), func: LosaDesEle()),
    tab(txt:'Refuerzo', tabicon: Icon(Icons.apps_rounded), func: LosaDesRef()),
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

    return MyTab_LosaCon(
      titulo: 'Diseño de losas concreto',
      listatab: tabdet,
      loc: Losaresults(),
    );
  }
}
