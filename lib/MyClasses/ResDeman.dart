import 'package:flutter/material.dart';
import 'package:lonchi_ing_gd/MyWidgets/MyResultButton.dart';
import 'package:provider/provider.dart';
import 'package:lonchi_ing_gd/MyWidgets/MyTitle.dart';
import 'MyProviders.dart';


class ResDeman extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ResDemanScreen();
  }
}

class ResDemanScreen extends StatefulWidget {

  State createState() =>  ResDemanScreenState();
}

class ResDemanScreenState extends State<ResDemanScreen> {

  var L;
  var wCP;
  var wCT;
  var wCPP;
  var wCTT;
  var wCU;
  var Apoyo;
  var PP;
  var Ancho;
  var Ixx;
  var EE;

  var MDis;
  var VDis;
  var Def;
  double? VuMax;
  double? MuMax;
  double? MuMin;
  double? DefCP;
  double? DefCT;

  // var pCP;
  // var pCT;
  final number = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final MyProvider = Provider.of<DemProvider>(context, listen: false);
    final ResProvider = Provider.of<ResultProvider>(context, listen: false);

    MuMax = ResProvider.getMupos();
    MuMin = ResProvider.getMuneg();
    VuMax = ResProvider.getVumax();

    return Scaffold(
      backgroundColor: Colors.grey[900],
      // appBar: MyAppBar('Diseño de elementos W', context),
      body: ListView(
          children: [
            MyTitle(titulo: 'FLEXIÓN-MOMENTO POSITIVO:',),
            MyResultButton(
              titulo: 'Mu pos =',
              result: '$MuMax kg*m',
            ),
            MyTitle(titulo: 'FLEXIÓN-MOMENTO NEGATIVO:',),
            MyResultButton(
              titulo: 'Mu neg =',
              result: '$MuMin kg*m',
            ),
            MyTitle(titulo: 'CORTANTE:',),
            MyResultButton(
              titulo: 'Vu max =',
              result: '$VuMax kg',
            ),
          ]),
    );
  }
}