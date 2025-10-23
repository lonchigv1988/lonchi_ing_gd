import 'package:flutter/material.dart';
import 'package:lonchi_ing_gd/MyWidgets/MyAppBarTab.dart';
import 'package:lonchi_ing_gd/MyWidgets/MyTab_W.dart';
import 'package:lonchi_ing_gd/acero/WDesEle.dart';
import 'package:lonchi_ing_gd/acero/WResults.dart';
import 'package:lonchi_ing_gd/MyClasses/Demanda.dart';

class WDes extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WDesScreen();
  }
}

class WDesScreen extends StatefulWidget {
  @override
  _WDesScreenState createState() => _WDesScreenState();
}

class _WDesScreenState extends State<WDesScreen> with AutomaticKeepAliveClientMixin{

  @override
  bool get wantKeepAlive => true;

  List tabdet = [
    tab(txt:'Elemento', tabicon: Icon(Icons.edit), func: WDesEle()),
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

    return MyTab_W(
        titulo: 'Diseño de elementos W',
        listatab: tabdet,
        loc: Wresults(),
    );
  }
}
